# Connecting to jupyter lab running container on vm
To open jupyter lab on localhost on your local machine follow these steps:

1. connect to vm via ssh

> ssh -i ~/.ssh/mcmc.pem azureuser@<publicip> -p 50000 -L 9999:localhost:9999

2. run docker container on vm
> $ docker run --rm -d -p 9999:9999 maxthemillion/rstan-jupyter

then go to localhost:9999 on your local machine

# Connecting to jupyter running container locally
1. start docker container using
> $ docker run --rm -d -p 9999:9999 maxthemillion/rstan-jupyter:latest

# Connecting to jupyter running container locally and including a bind mount
> $ docker run --rm -d -p 9999:9999 --mount type=bind,source="$(pwd)",target=/src/notebooks maxthemillion/rstan-jupyter:latest