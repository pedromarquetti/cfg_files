# syntax=docker/dockerfile:1
FROM ubuntu
ENV DEBIAN_FRONTENT=noninteractive

# update and install some thingsfirst
RUN apt update && apt upgrade -y && apt install -y sudo vim curl wget git && rm -rf /var/lib/apt/lists/*

# copy all the files to the container
COPY . .