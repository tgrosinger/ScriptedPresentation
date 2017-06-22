#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/../scripted-presenter.sh"

################################################################################
# copy this file and modify the section below for each presentation
################################################################################

prompt "This is the first step, no need to wait here"
run echo "Hello World"

wait_and_prompt "First command done, moving on to the second one"
run echo "Example command number two"

wait_and_prompt "Let's start a ping down below..."
run_below "-l 10" "ping localhost"

wait_and_prompt "Now open a ping in a new window, but don't show that window"
run_background "win-name" "ping localhost"

wait_and_prompt "Finally, run a ping next to this"
run_beside "-p 30" "ping localhost"

wait_and_prompt "Pressing enter one more time will kill the whole demo"
terminate
