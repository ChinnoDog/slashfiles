# System default .bashrc
if [ ! -f "$HOME/.bashrc.d/.bashrc" ] && [ -f "/etc/skel/.bashrc" ]; then
. /etc/skel/.bashrc
fi

# Execute .bashrc.d scripts
if [ -d "$HOME/.bashrc.d" ]; then
  for i in "$HOME/.bashrc.d/.bashrc" "$HOME"/.bashrc.d/*.sh; do
    [ -e "$i" ] || continue # Skip if no matching files
    [ -r "$i" ] && . "$i"
  done
  unset i
fi
