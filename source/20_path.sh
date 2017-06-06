# RESET PATH
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"

# COMPOSER
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Add binaries into the path
export PATH="$DOTFILES/bin:$PATH"
export PATH="$DOTFILES/bin/dev:$PATH"
export PATH="$DOTFILES/bin/files:$PATH"
export PATH="$DOTFILES/bin/games:$PATH"
export PATH="$DOTFILES/bin/life:$PATH"
export PATH="$DOTFILES/bin/network:$PATH"
export PATH="$DOTFILES/bin/pentest:$PATH"
export PATH="$DOTFILES/bin/security:$PATH"
export PATH="$DOTFILES/bin/sed:$PATH"
export PATH="$DOTFILES/bin/text:$PATH"

# PROGRAMS VARIABLES
export ANDROID_HOME="/home/$USER/$DOTFILES_FOLDER_PROGRAMS/android-sdk-linux"
export ANDROID_PLATFORM_TOOLS="/home/$USER/$DOTFILES_FOLDER_PROGRAMS/android-sdk-linux/platform-tools/"
export PATH="$PATH:$ANDROID_HOME:$ANDROID_PLATFORM_TOOLS"

# go path
export GOPATH=$HOME/.go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin:/usr/share/bcc/tools

#OTHERS PROGRAMS
export PATH="$HOME/.composer/vendor/bin:$PATH"
