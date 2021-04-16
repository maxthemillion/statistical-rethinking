To open jupyter lab on localhost on your local machine follow these steps:

1. connect to vm via ssh

> ssh -i ~/.ssh/mcmc.pem azureuser@<publicip> -p 50000 -L 9999:localhost:9999

2. run docker container on vm

> $ docker run -it -p 9999:9999 maxthemillion/rstan-jupyter /bin/bash

3. run jupyter inside docker container

> $$ jupyter lab --ip 0.0.0.0 --port 9999:9999


then go to localhost:9999 on your local machine