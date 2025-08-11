# Docker file for base Neovim image.
#
# @author Maciej Bedra

# Debian image as base (unstable for newest software).
FROM debian:trixie

# Set image locale.
# Replace the existing ENV lines:
ENV TZ=America/Chicago
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Update repositories and install software:
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales tzdata && \
    sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    rm -rf /var/lib/apt/lists/*
# 1. curl.
# 2. fzf for fast file search.
# 3. ripgrep for fast text occurrence search.
# 4. tree for files tree visualization.
# 5. Git.
# 6. Lazygit for Git visualization.
# 7. xclip for clipboard handling.
# 8. Python 3.
# 9. pip for Python.
# 10. NodeJS.
# 11. npm for NodeJS.
# 12. tzdata to set default container timezone.
# 13. Everything needed to install Neovim from source.
# (Lines 27–39 replaced with:)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      curl fzf ripgrep tree git xclip python3 python3-pip python3-pynvim \
      nodejs npm tzdata ninja-build gettext libtool libtool-bin autoconf automake \
      cmake g++ pkg-config zip unzip bat zoxide eza jq man wget make && \
    rm -rf /var/lib/apt/lists/* && \
    npm i -g neovim
# Install Neovim from source.
RUN mkdir -p /root/TMP && \
    cd /root/TMP && git clone https://github.com/neovim/neovim && \
    cd /root/TMP/neovim && git checkout stable && make -j4 && make install && \
    rm -rf /root/TMP

RUN npm install -g typescript typescript-language-server

# Create user account and home directory

ARG USER_NAME
ARG USER_GRP
ARG USER_UID
ARG USER_GID

RUN groupadd -g ${USER_GID} ${USER_GRP} && \
    useradd -l -u ${USER_UID} -g ${USER_GRP} -m -d /home/${USER_NAME} -s /bin/bash ${USER_NAME} && \
    mkdir -p /home/${USER_NAME}/.ssh && \
    chown -R ${USER_UID}:${USER_GID} /home/${USER_NAME} && \
    chmod 700 /home/${USER_NAME}/.ssh

USER ${USER_UID}:${USER_GID}
WORKDIR /home/${USER_NAME}

# Install dotfiles
RUN git clone https://github.com/bmbroom/dotfiles.git .cfg && \
    git --git-dir=/home/${USER_NAME}/.cfg/.git remote set-url --push origin git@github.com:bmbroom/dotfiles.git && \
    git --git-dir=/home/${USER_NAME}/.cfg/.git --work-tree=/home/${USER_NAME} config --local status.showUntrackedFiles no && \
    git --git-dir=/home/${USER_NAME}/.cfg/.git --work-tree=/home/${USER_NAME} reset --hard

# Create directory for Neovim spell check dictionaries.
# RUN mkdir -p /home/{USER_NAME}/.local/share/nvim/site/spell

# Copy Neovim dictionaries.
# COPY ./spell/ /root/.local/share/nvim/site/spell/

# Install Vim Plug.
# RUN curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create directory for Neovim configuration files.
# RUN mkdir -p /root/.config/nvim

# Copy Neovim configuration files.
# COPY ./config/ /root/.config/nvim/

# Install Neovim extensions.
# RUN nvim --headless +PlugInstall +qall

# Create directory for Neovim COC extensions.
# RUN mkdir -p /root/.config/coc/extensions

# Install Neovim COC extensions.
# RUN cd /root/.config/coc/extensions && npm install $COC --global --only=prod

# Create TMP directory
# RUN mkdir -p /root/TMP

# Install Lazygit from binary
# RUN cd /root/TMP && curl -L -o $LG_ARCHIVE $LG_GITHUB
# RUN cd /root/TMP && tar xzvf $LG_ARCHIVE && mv $LG /usr/bin/

# Install GIT Flow
# RUN cd /root/TMP && git clone $GIT_FLOW_GITHUB
# RUN cd /root/TMP/$GIT_FLOW_DIR && git checkout master && make install

# Delete TMP directory
# RUN rm -rf /root/TMP

# Bash aliases
# COPY ./home/ /home/${USER_NAME}/

# Set default location after container startup.

# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]
