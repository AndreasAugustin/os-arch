#######################################
# image for dev build environment
######################################
FROM archlinux as DEV

ARG LOGIN=andy
ARG UID=1000
ARG GID=985
ARG PASSWORD=root

# install base-devel for makepkg git and zsh
RUN pacman -Sy --noconfirm base-devel git zsh sudo

# create user with group and add to sudoers
RUN useradd -g ${GID} -G wheel,storage,power -s /bin/zsh -u ${UID} -m ${LOGIN} \
    && echo "${LOGIN}:${PASSWORD}" | chpasswd \
    && echo "${LOGIN} ALL=(ALL) ALL" >> /etc/sudoers

# create empty .zsrhc for the user above
RUN echo "# empty .zshrc for user ${LOGIN}" >> /home/${LOGIN}/.zshrc

USER ${LOGIN}

WORKDIR /app

#######################################
# image for creating the documentation
######################################
FROM node:14.1.0-alpine as DOCS

# install packages
RUN apk add --update --no-cache bash make git zsh curl tmux

# Make zsh your default shell for tmux
RUN echo "set-option -g default-shell /bin/zsh" >> /root/.tmux.conf

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install quality gate
RUN npm install -g markdownlint-cli

WORKDIR /app
