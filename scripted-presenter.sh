#!/usr/bin/env bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Name of the tmux session we'll create and run from
session="demo_sess"
main_win="demo"

function has-session {
    tmux has-session -t "${1}" 2>/dev/null
}

# If we aren't in the demo session, create it and enter.
# You can also use this to do environment setup in the session.
if [ "$DEMOSESSION" == "" ]; then
    if has-session "${session}"; then
        echo "Killing old session..."
        tmux kill-session -t ${session}
    fi

    tmux new-session -s "${session}" -n "${main_win}" -c $(pwd) -d
    tmux send-keys -t "${session}" 'export DEMOSESSION=1' C-m
    tmux send-keys -t "${session}" 'clear' C-m
    tmux send-keys -t "${session}" './presentation.sh' C-m
    exec tmux attach -t "${session}"
fi

# prompt prints the provided message and waits for <enter>
function prompt() {
    printf "${GREEN}${1}${NC}"
    read -p ""
}

# wait_and_prompt first prints "...Done" to indicate the previous command has
# finished, then waits for <enter> before calling prompt.
function wait_and_prompt() {
    printf "${GREEN}...Done${NC}"
    read -p ""

    clear
    prompt "${1}"
}

# run displays the command about to be run, waits for <enter>, then runs the
# command in the current tmux pane.
function run() {
    printf "\n\$ ${BLUE}${*}${NC}"
    read -p ""
    ${*}
}

# run_below creates a new tmux pane below the current one and executes a command
# in it. The first argument indicates the pane size, for example "-l 20" means
# 20 lines tall, or "-p 20" means 20 percent of the window. The second argument
# is the command to run.
#
# Note: When the command terminates the pane will close!
function run_below() {
    size_flags=${1}
    command=${2}

    tmux split-window -d -v -t "${session}" ${size_flags} "${command}"
}

# run_beside behaves exactly like run_below except the pane is created to the
# right of the current pane, rather than below it.
function run_beside() {
    size_flags=${1}
    command=${2}

    tmux split-window -d -h -t "${session}" ${size_flags} "${command}"
}

function run_background() {
    window_name=${1}
    command=${2}

    tmux new-window -d -n "${window_name}" -t "${session}" "${command}"
}

# focus_last switches to the last pane that was in focus. Useful if you start a
# new window or pane without providing the -d option.
function focus_last() {
    tmux last-pane -t "${session}"
}

# terminate kills the tmux session and all contained windows, panes, commands
# running, etc.
function terminate() {
    tmux kill-session -t "${session}"
}
