#!/usr/bin/env bash
# last_verified: 2026-08-08 · CI/CD Concepts n/a

# Parallelized, cached CI stage runner — L2 concept exercise for CI/CD Concepts.
#
# I built this to practice three CI ideas I kept reading about at once:
# running stages in parallel to cut wall-clock time, caching build outputs so a
# rerun skips work that already succeeded, and collecting every job's exit
# status into a single failure report instead of dying on the first one.

CACHE_DIR="${CI_CACHE_DIR:-./.ci-cache}"
REPORT_DIR="${CI_REPORT_DIR:-./.ci-results}"
mkdir -p "${CACHE_DIR}" "${REPORT_DIR}"

# I keep the job list as "name:command" pairs. Adding or removing a stage is
# just one array entry — the same config-driven approach I see in real CI
# systems, where the pipeline definition is separate from the runner itself.
# Each job has a unique name, so caches never collide across stages.
JOBS=(
  "lint:echo '[lint] checking style' && sleep 1 && echo lint-ok"
  "unit-test:echo '[unit-test] running unit tests' && sleep 2 && echo test-ok"
  "build:echo '[build] building image' && sleep 3 && echo build-ok"
  "integration-test:echo '[integ] running integration tests' && sleep 2 && echo integ-ok"
)

# Each job runs in a subshell so a non-zero exit is just a return code, not a
# signal that aborts the whole runner. I write a status file and a log file
# per stage so the reporter can summarize everything after the fan-out.
run_job() {
  local name="$1" cmd="$2"
  local marker="${CACHE_DIR}/${name}.done"

  # Cache check: if this stage already has a marker, we skip it on reruns.
  if [[ -f "${marker}" ]]; then
    echo "[${name}] CACHED (cache hit)"
    echo "cached" > "${REPORT_DIR}/${name}.status"
    return 0
  fi

  echo "[${name}] START"
  local output
  if output=$(bash -c "${cmd}" 2>&1); then
    echo "[${name}] PASSED"
    echo "${output}" > "${REPORT_DIR}/${name}.log"
    echo "passed" > "${REPORT_DIR}/${name}.status"
    touch "${marker}"
    return 0
  else
    echo "[${name}] FAILED"
    echo "${output}" > "${REPORT_DIR}/${name}.log"
    echo "failed" > "${REPORT_DIR}/${name}.status"
    return 1
  fi
}

echo "=== Parallelized CI stage runner ==="
echo "Cache: ${CACHE_DIR}"
echo "Results: ${REPORT_DIR}"
echo ""

# Fan out: launch every job in the background at once.
declare -a pids=()
for job in "${JOBS[@]}"; do
  name="${job%%:*}"
  cmd="${job#*:}"
  run_job "${name}" "${cmd}" &
  pids+=("$!")
done

# Wait for each background job individually. `wait $pid` returns the exit
# code of that specific job, so a failure in one stage does not stop the
# others from running or mask their results.
failures=()
for i in "${!pids[@]}"; do
  if ! wait "${pids[$i]}"; then
    failures+=("${JOBS[$i]%%:*}")
  fi
done

# Failure report: list every stage's final status, then break out the
# failures with a pointer to the detailed log for each one.
echo ""
echo "=== Stage results ==="
for job in "${JOBS[@]}"; do
  name="${job%%:*}"
  status="missing"
  [[ -f "${REPORT_DIR}/${name}.status" ]] && status="$(cat "${REPORT_DIR}/${name}.status")"
  printf '  %-18s %s\n' "${name}" "${status}"
done

echo ""
if (( ${#failures[@]} > 0 )); then
  echo "=== FAILURES (${#failures[@]}) ==="
  for f in "${failures[@]}"; do
    echo "  - ${f}  (log: ${REPORT_DIR}/${f}.log)"
  done
  echo ""
  echo "One or more stages failed; rerun with a clean cache to retry."
  exit 1
fi

echo "=== All ${#JOBS[@]} stages passed ==="
