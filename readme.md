# My attempts towards Bayesian modeling
I am currently working through the book ["Statistical Rethinking" by Richard McElreath](https://xcelab.net/rm/statistical-rethinking/). In this repository you can find my solutions to some of the end of chapter problems. It also contains my own experiments with the rethinking R-package and Bayesian Data Analysis in general.

# Installation of R-kernel for Jupyter Notebook:
> install.packages('IRkernel')  
> IRkernel::installspec()

# ssh to azure VM
[Connect to VM via ssh](https://docs.microsoft.com/en-us/azure/developer/javascript/tutorial/nodejs-virtual-machine-vm/connect-linux-virtual-machine-ssh)

> ssh -i ~/.ssh/mcmc.pem azureuser@<publicip>

# setup rstan env on azure vm

Basically, all you should need is
> Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1) 
> install.packages("rstan", repos = "https://cloud.r-project.org/", dependencies = TRUE)

However, installing V8 requires some system resources like curl. So you can fix those like this: 

[Installing V8 system dependencies](https://stackoverflow.com/questions/62302713/not-able-to-install-v8-package-on-ubuntu)

Then install V8 like this:
[Solve (some) issue with v8 when installing rstan on linux](https://github.com/stan-dev/rstan/issues/863)

Then you can run install.packages("rstan") like so: 
[installing RStan](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started)

[configure toolchain](https://github.com/stan-dev/rstan/wiki/Configuring-C-Toolchain-for-Linux)



