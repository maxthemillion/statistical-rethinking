# My attempts towards Bayesian modeling
I am currently working through the book ["Statistical Rethinking" by Richard McElreath](https://xcelab.net/rm/statistical-rethinking/). In this repository you can find my solutions to some of the end of chapter problems. It also contains my own experiments with the rethinking R-package and Bayesian Data Analysis in general.

# Installation of R-kernel for Jupyter Notebook:
> install.packages('IRkernel')  
> IRkernel::installspec()

# ssh to azure VM
[Connect to VM via ssh](https://docs.microsoft.com/en-us/azure/developer/javascript/tutorial/nodejs-virtual-machine-vm/connect-linux-virtual-machine-ssh)

> ssh -i ~/.ssh/mcmc.pem azureuser@<publicip>

# setup rstan env on linux


Configuring your toolchain like so:

````
dotR <- file.path(Sys.getenv("HOME"), ".R")
if (!file.exists(dotR)) dir.create(dotR)
M <- file.path(dotR, "Makevars")
if (!file.exists(M)) file.create(M)
cat("\nCXX14FLAGS=-O3 -march=native -mtune=native -fPIC",
    "CXX14=g++-10", # or clang++ but you may need a version postfix
    file = M, sep = "\n", append = TRUE)
````

And then this:
> Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1) 
> install.packages("rstan", repos = "https://cloud.r-project.org/", dependencies = TRUE)


However, installing rstan requires some packages with system resources like curl. Refer to the docker image for details on system requirements and configurations.




