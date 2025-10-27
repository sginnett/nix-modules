#! /usr/bin/env fish
set -l USAGE "Usage: git recent [-n <number>]"

argparse 'h/help' 'n/number=' -- $argv
set -l argstatus $status

if not test $argstatus -eq 0
  echo $USAGE
  return $argstatus
end

if set -q _flag_help
  echo $USAGE
  return 0
end

set -l NUM 10
set -ql _flag_number[1]
and set NUM $_flag_number[1]

set -l BRANCHES (
  git reflog |
  egrep -io "moving from ([^[:space:]]+)" |
  awk '{ print $3 }' |
  awk ' !x[$0]++' |
  head -n $NUM
)

printf '%s\n' $BRANCHES

