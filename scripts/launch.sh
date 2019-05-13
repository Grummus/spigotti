tmux new-session -s minecraft -d './start.sh'
tmux split-window -h './info.sh'
tmux split-window -v 'bash'
tmux select-pane -L 
tmux attach -t minecraft