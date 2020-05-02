#######################################
# image for dev build environment
######################################
FROM archlinux as DEV

ARG LOGIN=andy
ARG UID=1000
ARG GID=985

# install base-devel for makepkg git and zsh
RUN pacman -Sy --noconfirm base-devel git zsh

# create user with group
RUN useradd -g ${GID} -u ${UID} -m ${LOGIN}
# create empty .zsrhc for the user above
RUN echo "# empty .zshrc for user ${LOGIN}" >> /home/${LOGIN}/.zshrc

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
