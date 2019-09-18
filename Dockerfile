FROM ubuntu

# Install packages, get texlive
RUN apt-get update && apt-get upgrade --yes
RUN apt-get install wget curl make --yes

# Install tzdata non-interactively
RUN ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

# Install the TeX Live distro
RUN apt-get install --yes texlive-xetex

# Ok, now install me some elixir!
RUN apt-get install gnupg --yes
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install esl-erlang elixir --yes
RUN apt-get install git build-essential erlang-dev --yes

# 
RUN mkdir /app
WORKDIR /app

COPY assets config lib mix.exs mix.lock priv test ./
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

CMD mix phx.server
