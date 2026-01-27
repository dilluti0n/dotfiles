export HISTCONTROL="ignoreboth"
export HISTSIZE="99999"
export DMENU_FONT="Iosevka Term:size=10"
export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export PATH="$HOME/.local/usr/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export NPM_CONFIG_PREFIX=$HOME/.local/
export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"

if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# # TEMP for chromium (ozone-platform=wayland is unstable)
# XDG_SESSION_TYPE="x11"

# GUI session
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then

    # enabel hw accelated video encoding
    chromium_common_feat='VaapiVideoEncoder,VaapiIgnoreDriverChecks'

    if [ "$XDG_SESSION_TYPE" = "x11" ]; then
        export GTK_IM_MODULE=fcitx
        export QT_IM_MODULE=fcitx
        export GLFW_IM_MODULE=ibus
        # use vulkan
        CHROMIUM_USER_FLAGS="--enable-features=${chromium_common_feat},"
        CHROMIUM_USER_FLAGS+='VaapiVideoDecoder,'
        CHROMIUM_USER_FLAGS+='VaapiIgnoreDriverChecks,'
        CHROMIUM_USER_FLAGS+='Vulkan,'
        CHROMIUM_USER_FLAGS+='DefaultANGLEVulkan,'
        CHROMIUM_USER_FLAGS+='VulkanFromANGLE'
        export CHROMIUM_USER_FLAGS
    fi

    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        # use opengl (chromium with wayland does not support vulkan)
        CHROMIUM_USER_FLAGS="--enable-features=${chromium_common_feat},"
        CHROMIUM_USER_FLAGS+='AcceleratedVideoDecodeLinuxGL,'
        CHROMIUM_USER_FLAGS+='AcceleratedVideoDecodeLinuxZeroCopyGL,'
        CHROMIUM_USER_FLAGS+='AcceleratedVideoEncoder,'
        CHROMIUM_USER_FLAGS+='UseOzonePlatform '
        CHROMIUM_USER_FLAGS+='--ozone-platform=wayland --enable-wayland-ime'
        export CHROMIUM_USER_FLAGS
    fi
fi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    # export GTK_IM_MODULE=xim
    # discord --start-minimized &

    exec dbus-run-session sway
fi
