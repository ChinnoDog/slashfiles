# Set GIT_SSH_COMMAND when inside slashfiles (rooted at /)
if git rev-parse --show-toplevel 2>/dev/null | grep -qx /; then
  # Resolve invoking user's home directory without hardcoding
  INVOKER_HOME=$(getent passwd $(logname) | cut -d: -f6)

  # Set SSH command only if key exists
  if [ -r "$INVOKER_HOME/.ssh/id_rsa" ]; then
    export GIT_SSH_COMMAND="ssh -i $INVOKER_HOME/.ssh/id_rsa -o IdentitiesOnly=yes"
  fi
fi
