#!/bin/bash
# This is a post-commit hook created by gitreport (http://gitreport.com)
#
# To remove it issue 'bundle exec deactivate' in the projects main directory
# In case the gitreport gem is not installed anymore, simply remove this hook file
# and remove the calling line from git's 'post-commit' if there is any

bundler-installed()
{
  which bundle > /dev/null 2>&1
}

within-bundled-project(){
  local dir="$(pwd)"
  while [ "$(dirname $dir)" != "/" ]; do
      [ -f "$dir/Gemfile" ] && return
      dir="$(dirname $dir)"
  done
  false
}

run-with-bundler(){
  if bundler-installed && within-bundled-project; then
      bundle exec $@
  else
      $@
  fi
}

run-with-bundler gitreport commit
