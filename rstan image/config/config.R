dotR <- file.path(Sys.getenv("HOME"), ".R")
if(!file.exists(dotR)) dir.create(dotR)
M <- file.path(dotR, "Makevars")
if (!file.exists(M)) file.create(M)
cat("\nCXX14FLAGS=-O3 -march=native -mtune=native -fPIC",
    "CXX14=g++-10", 
    file = M, sep = "\n", 
    append = TRUE)