# last_verified: 2026-09-23 · bash (n/a)
# shellcheck shell=bash

# Parallel tasks with structured logging — L2 concept exercise.
# I wanted one small pattern for running a few shell tasks at once,
# keeping a log line per event, and still noticing which one failed.

# I log as "timestamp [LEVEL] message" because plain echo lines got
# confusing once three jobs printed at the same time.
log() {
  level="$1"
  shift
  printf '%s [%s] %s\n' "$(date '+%H:%M:%S')" "$level" "$*"
}

# I gave each task a name so the log tells me which background job
# is talking. The sleep values just fake real work while I practice.
run_task() {
  name="$1"
  seconds="$2"
  should_fail="$3"
  log "INFO" "$name starting (about ${seconds}s)"
  sleep "$seconds"
  if [ "$should_fail" = "fail" ]; then
    log "ERROR" "$name hit a problem"
    return 1
  fi
  log "INFO" "$name done"
  return 0
}

# I launch the three tasks with & and keep each PID so I can wait
# on them one by one. Waiting per-PID lets me record the right
# name next to each exit code — plain `wait` alone lost that for me.
main() {
  log "INFO" "launching 3 tasks in parallel"
  run_task "fetch" 2 "ok" &
  pid_fetch=$!
  run_task "lint" 1 "ok" &
  pid_lint=$!
  run_task "build" 3 "fail" &
  pid_build=$!

  # I collect failures in a string because I want every task to
  # finish even if an early one fails. Stopping at the first error
  # hid the other results when I tried it the other way.
  failed=""
  wait "$pid_fetch" || failed="$failed fetch"
  wait "$pid_lint" || failed="$failed lint"
  wait "$pid_build" || failed="$failed build"

  if [ -n "$failed" ]; then
    log "ERROR" "finished with failures:$failed"
    return 1
  fi
  log "INFO" "all tasks passed"
  return 0
}

main "$@"
