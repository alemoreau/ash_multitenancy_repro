FROM elixir:1.18

# Build Args
ARG PHOENIX_VERSION=1.7.20
ARG NODE_VERSION=22.14.0
ARG IGNITER_VERSION=0.5.23

# Dependencies
RUN apt update \
  && apt upgrade -y \
  && apt install -y bash curl git build-essential inotify-tools libwxgtk-gl3.2-1 unzip

# NodeJS
ENV NVM_DIR /opt/nvm
RUN mkdir -p ${NVM_DIR} \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install ${NODE_VERSION} \
  && nvm alias default ${NODE_VERSION} \
  && nvm use default \
  && npm install -g yarn

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Phoenix
RUN mix local.hex --force
RUN mix archive.install --force hex phx_new ${PHOENIX_VERSION}
RUN mix archive.install --force hex igniter_new ${IGNITER_VERSION}

RUN mix local.rebar --force

# App Directory
ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# App Port
EXPOSE 4000

# Default Command
CMD ["mix", "phx.server"]