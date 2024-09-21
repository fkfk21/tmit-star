#!/bin/env zsh

prefix=()
suffix=()
profile_run=false
if [ "$1" = "profile" ]; then
  echo "Running with perf profiling..."
  profile_run=true
  prefix+=(perf record --call-graph dwarf -F 99 --)
  shift 1
  TRAPINT() {
    echo "Caught interrupt! Continuing to generate perf file..."
    return 0
  }
elif [ "$1" = "debug" ]; then
  echo "Running with lldb..."
  prefix+=(lldb)
  suffix+=(--)
  shift 1
elif [ "$1" = "rr" ]; then
  echo "Running with rr..."
  prefix+=(rr record)
  shift 1
fi

cmd=("${prefix[@]}" build/tmit-star "${suffix[@]}" "${@[@]}")
env "${cmd[@]}"

if $profile_run; then
  perf script -F +pid > tmit-star.perf
fi
