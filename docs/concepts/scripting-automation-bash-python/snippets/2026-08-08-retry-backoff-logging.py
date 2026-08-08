# last_verified: 2026-08-08 · python n/a
#
# Retry, backoff, and structured-logging helpers I copy next to any automation
# script that calls something flaky (an HTTP endpoint, a DB, another CLI).
#
# I kept this to the standard library so there's nothing extra to install —
# tenacity would be nicer, but spinning up a venv every time I debug a CI step
# is more friction than this file is worth. L2: still learning, single file.

import json
import logging
import random
import time
from functools import wraps


# --- Structured logging -------------------------------------------------------
# Plain logging spits out a string I have to parse by eye. JSON logging emits
# one object per line, so I can pipe the same output to `jq` or a log shipper
# without changing the code. Every call below can thread extra context
# (request_id, step, ...) through `extra={...}`.

class JsonFormatter(logging.Formatter):
    """Format each LogRecord as a single JSON line."""

    # attrs that belong to a plain LogRecord — anything else on the record
    # came from the caller's `extra={}` and should appear in the JSON output.
    _BASE = frozenset(vars(logging.makeLogRecord({})).keys()) | {"message", "asctime"}

    def format(self, record):
        entry = {
            "ts": self.formatTime(record, "%Y-%m-%dT%H:%M:%S"),
            "level": record.levelname,
            "msg": record.getMessage(),
        }
        for key, value in vars(record).items():
            if key not in self._BASE and not key.startswith("_"):
                entry[key] = value
        if record.exc_info:
            entry["exc"] = self.formatException(record.exc_info)
        return json.dumps(entry)


def get_json_logger(name="automation", level=logging.INFO):
    """Return a logger that writes JSON lines to stderr."""
    log = logging.getLogger(name)
    if not log.handlers:
        handler = logging.StreamHandler()
        handler.setFormatter(JsonFormatter())
        log.addHandler(handler)
    log.setLevel(level)
    log.propagate = False
    return log


# --- Retry + exponential backoff ----------------------------------------------
# I wrote this decorator after curl kept flapping on a flaky endpoint and my
# script would just die on the first transient 5xx. I tell it which exceptions
# are worth retrying, how many tries, the base delay, and a multiplier that
# grows the wait each attempt (1s -> 2s -> 4s ...). Jitter desyncs retries
# when several calls fail at once.

def retry(exceptions=(Exception,), tries=4, delay=1.0, backoff=2.0, jitter=True):
    def decorate(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            last_error = None
            for attempt in range(1, tries + 1):
                try:
                    return fn(*args, **kwargs)
                except exceptions as exc:
                    last_error = exc
                    if attempt == tries:
                        break
                    wait = delay * (backoff ** (attempt - 1))
                    if jitter:
                        # full equal jitter: half the backoff plus a random half
                        # — keeps the average close to delay while spreading peaks
                        wait = (wait / 2.0) + random.uniform(0, wait / 2.0)
                    time.sleep(wait)
            raise last_error
        return wrapper
    return decorate


# --- Tiny demo so I can sanity-check by running `python this_file.py` ---------
if __name__ == "__main__":
    log = get_json_logger()

    state = {"n": 0}

    @retry(exceptions=(RuntimeError,), tries=3, delay=0.2, backoff=2.0, jitter=False)
    def flaky_call():
        state["n"] += 1
        if state["n"] < 3:
            raise RuntimeError("endpoint flapped — retrying")
        return "ok"

    try:
        result = flaky_call()
        log.info("call succeeded", extra={"attempt": state["n"], "result": result})
    except Exception as exc:
        log.error("call gave up after retries",
                  extra={"attempt": state["n"]}, exc_info=True)
