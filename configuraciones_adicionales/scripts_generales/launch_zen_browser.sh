#!/bin/bash

export MOZ_ENABLE_WAYLAND=1
export MOZ_X11_EGL=1
export MOZ_DISABLE_RDD_SANDBOX=1

# Log environment for debugging (optional, can be removed later)
env > /tmp/zen_browser_env_wrapper.log

exec zen-gpu "$@"