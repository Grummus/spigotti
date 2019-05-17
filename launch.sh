tmux new-session -s minecraft -d './start.sh'
tmux split-window -h './term.sh'
tmux split-window -v './info.sh'
tmux select-pane -L 
tmux attach -t minecraft
