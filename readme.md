# My attempts towards Bayesian modeling
I am currently working through the book ["Statistical Rethinking" by Richard McElreath](https://xcelab.net/rm/statistical-rethinking/). In this repository you can find my solutions to some of the end of chapter problems. It also contains my own experiments with the rethinking R-package and Bayesian Data Analysis in general.

# Installation of R-kernel for Jupyter Notebook:
> install.packages('IRkernel')  
> IRkernel::installspec()


# setup mcmc sampler on azure vm
[Connect to VM via ssh](https://docs.microsoft.com/en-us/azure/developer/javascript/tutorial/nodejs-virtual-machine-vm/connect-linux-virtual-machine-ssh)

> ssh -i ~/.ssh/mcmc.pem azureuser@<publicip>

[configure toolchain](https://github.com/stan-dev/rstan/wiki/Configuring-C-Toolchain-for-Linux)

[Solve issue with v8 when installing rstan on linux](https://github.com/stan-dev/rstan/issues/863)

# ssh to vm
