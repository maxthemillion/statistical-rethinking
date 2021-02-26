#### Chapter 4 - Codeblocks ####

#### Grid Approximation ####

library(rethinking)
data(Howell1)
d <- Howell1

# available summary functions
str(d)
summary(d)
head(d)
precis(d , hist=FALSE)

# restricting the data to adults
d2 <- d[d$age >= 18, ]

# choosing priors
curve(dnorm(x, 178, 20), from=100, to=250)
curve(dunif(x, 0, 50), from =-10, to=60)
sample_mu <- rnorm(1e4, 178, 20)
sample_sigma <- runif(1e4, 0, 50)

# combined prior for body height
prior_h <- rnorm(1e4, sample_mu, sample_sigma)
dens(prior_h)

# sampling the combined prior with a large sample_mu_sigma
sample_mu <- rnorm(1e4, 178, 100)
prior_h <- rnorm(1e4, sample_mu, sample_sigma)
dens(prior_h)

# grid approximation of the posterior
# target: find the plausibility (probability) for all the combinations of mu and sigma
# approach: approximate the shape of the posterior probability distribution 
# with grid approximation. For each point of the grid, compute 

mu.list <-seq(from=150,to=160,length.out=100)
sigma.list <-seq(from=7,to=9,length.out=100)

# create grid
post <-expand.grid(mu=mu.list,sigma=sigma.list)

#  compute probability of the data (as sum of all log(p) at each gridpoint)
post$LL <-sapply(1:nrow(post),function(i)sum(dnorm(
  d2$height,
  post$mu[i],
  post$sigma[i],
  log=TRUE)))

# add priors
post$prod <-post$LL+dnorm(post$mu,178,20,TRUE)+dunif( post$sigma,0,50,TRUE)

# normalize to probabilities
post$prob <-exp(post$prod-max(post$prod))

contour_xyz(post$mu, post$sigma, post$prob)
image_xyz(post$mu, post$sigma, post$prob)
# the result is an approximate probability distribution 
# for the combinations of mu and sigma on the grid

# sampling from the posterior
sample.rows <-sample(1:nrow(post),size=1e4,replace=TRUE,prob=post$prob )
sample.mu <-post$mu[sample.rows]
sample.sigma <-post$sigma[sample.rows]

summary(post)
precis(post, hist=F)
str(post)

plot(sample.mu,sample.sigma,cex=0.5,pch=16,col=col.alpha(rangi2,0.1))

dens(sample.mu)
dens(sample.sigma)

# plausibility intervals
PI(sample.mu)
PI(sample.sigma)


# long tail to high variances
d3 <- sample(d2$height, size=20)
mu.list <-seq(from=150,to=170,length.out=200)
sigma.list <-seq(from=4,to=20,length.out=200)
post2 <-expand.grid(mu=mu.list,sigma=sigma.list)

post2$LL <-sapply(1:nrow(post2), function(i) sum(
  dnorm(
    d3, 
    mean=post2$mu[i], 
    sd=post2$sigma[i], 
    log=TRUE )
  ))
post2$prod <-post2$LL + dnorm(post2$mu,178,20,TRUE) + dunif( post2$sigma,0,50,TRUE)
post2$prob <-exp(post2$prod - max(post2$prod))

sample2.rows <-sample(
  1:nrow(post2),
  size=1e4,
  replace=TRUE, 
  prob=post2$prob )
sample2.mu <-post2$mu[sample2.rows]
sample2.sigma <-post2$sigma[sample2.rows]

plot( sample2.mu,sample2.sigma,cex=0.5,
      col=col.alpha(rangi2,0.3) ,
      xlab="mu" ,ylab="sigma",pch=16)

dens( sample2.sigma,norm.comp=TRUE)

#### Quadratic Approximation ####
# quadratic approximation of the posterior
# again we estimate the posterior based on the data and our prior beliefs
# quap very well approximates the shape of the distribution near the maximum

library(rethinking)
data(Howell1)
d <-Howell1
d2 <-d[d$age>=18,]

flist <-alist(
  height ~ dnorm(mu,sigma),
  mu ~ dnorm(178,20),
  sigma ~ dunif(0,50)
)

m4.1 <- quap(flist, data=d2)

# changed prior
m4.2 <-quap(
  alist(
    height ~dnorm(mu,sigma),
    mu ~dnorm(178,0.1),
    sigma ~dunif(0,50)
  ) ,data=d2)
precis(m4.2)

vcov(m4.1)
diag( vcov(m4.1))
cov2cor( vcov(m4.1))

# sampling the posterior
post <-extract.samples(m4.1,n=1e4)
head(post)
precis(post, hist=FALSE)
precis(m4.1)

#### Adding Weight as Predictor ####
# including weight. previously we only approximated the distribution of heights
data(Howell1) 
d <- Howell1
d2 <- d[d$age>=18,]
plot (d2$height~d2$weight)

# sampling and plotting from the prior
m4.3_plot <- function(a, b){
  set.seed(2971)
  N <-100 # 100lines
  plot( 
    NULL,
    xlim=range(d2$weight),
    ylim=c(-100,400), 
    xlab="weight",
    ylab="height")
  abline( h=0,lty=2)
  abline( h=272,lty=1,lwd=0.5)
  mtext( "b~dnorm(0,10)")
  xbar <-mean(d2$weight)
  for (i in 1:N) curve(a[i]+b[i]*(x-xbar),
                    from=min(d2$weight),
                    to=max(d2$weight),
                    add=TRUE,
                    col=col.alpha("black", 0.2))
}

a <-rnorm(N,178,20)
b <-rnorm(N,0,10)
m4.3_plot(a,b)

# correcting the prior for b
b <-rlnorm(1e4,0,1)
dens(b, xlim=c(0,5), adj=0.1)
# lognormal distribution is constrained to positive values

# choosing a different prior for b
b <-rlnorm(N,0,1)
m4.3_plot(a, b)

# finding the posterior

# define the average weight, x-bar
xbar <- mean(d2$weight)

# fit the model
m4.3 <-quap(
  alist(
    height ~ dnorm(mu,sigma),
    mu <- a+b*(weight-xbar),
    a ~ dnorm(178,20),
    b ~ dlnorm(0,1),
    sigma ~ dunif(0,50)
  ) ,data=d2)
precis(m4.3)
round( vcov(m4.3),3)
pairs(m4.3)
# precis(m4.1)


# sample and plot the posterior mean
plot(height~weight, data=d2, col=rangi2)
post <-extract.samples(m4.3)
a_map <-mean(post$a)
b_map <-mean(post$b)
curve( a_map+b_map*(x-xbar), add=TRUE)


post <- extract.samples(m4.3)
head(post)

N <-10
dN <-d2[1:N,]
mN <-quap(
  alist(
    height ~dnorm(mu,sigma),
    mu <-a+b*(weight-mean(weight)),
    a ~dnorm(178,20),
    b ~dlnorm(0,1),
    sigma ~dunif(0,50)
  ) ,data=dN)


# play with the amount of data to show the effect on uncertainty
library(dplyr)
library(rethinking)
m4.3_model <- function(N){
  #set.seed(42)
  dN <-d2[1:N,]
  
  # sampling some data
  #dN <- sample_n(d2, size = N, replace=TRUE)
  
  # fitting the model
  mN <-quap(
    alist(
      height ~dnorm(mu,sigma),
      #mu <-a+b*(weight-mean(weight)),
      mu <- a+b*(weight),
      a ~dnorm(178,20),
      b ~dlnorm(0,1),
      sigma ~dunif(0,50)
    ) ,data=dN)
  
  # extract 20 samples from the posterior
  post <- extract.samples(mN, n=20)
  
  # display raw data and sample size
  plot( dN$weight,dN$height,
        xlim=range(d2$weight) ,ylim=range(d2$height),
        col=rangi2 ,xlab="weight",ylab="height")
  
  mtext(concat("N =",N))
  
  # plot the lines, with transparency
  for (i in 1:20)
    curve( post$a[i]+post$b[i]*(x-mean(dN$weight)),
           col=col.alpha("black",0.3) ,add=TRUE)
}

m4.3_model(N=100)


post <- extract.samples(m4.3)

# "predicting" height at a fixed value for weight
mu_at_50 <- post$a+post$b*(50-xbar)
dens( mu_at_50, col=rangi2, lwd=2, xlab="mu|weight=50")

mu <-link(m4.3)
str(mu)


## define sequence of weights to compute predictions for
# these values will be on the horizontal axis
weight.seq <- seq(from=25,to=70,by=1)
# use link to compute mu
# for each sample from posterior
# and for each weight in weight.seq
mu <- link(m4.3, data=data.frame(weight=weight.seq))
str(mu)

post <- extract.samples(m4.3)

# use type="n" to hide raw data
plot( height~weight, d2)
# loop over samples and plot each mu value
for (i in 1:100)
  points( weight.seq, mu[i,], pch=16,col=col.alpha(rangi2,0.05))
post <-extract.samples(m4.3)
a_map <-mean(post$a)
b_map <-mean(post$b)
curve( a_map+b_map*(x-xbar), add=TRUE)

# summarize distribution of each weight value
mu.mean <-apply(mu,2,mean)
mu.PI <-apply(mu,2,PI,prob=0.89)

# plot raw data
# fading out points to make line and interval more visible
plot( height~weight,data=d2,col=col.alpha(rangi2,0.5))
# plot the MAP line, aka the mean mu for each weight
lines(weight.seq, mu.mean)
# plot a shaded region for 89% PI
shade(mu.PI, weight.seq)

#### Prediction Intervals ####
# simulate posterior observations = simulate 
sim.height <- sim(m4.3, data=list(weight=weight.seq))
str(sim.height)

# 89% posterior prediction interval of observable heights across
# across the values in weight.seq
height.PI <- apply(sim.height, 2, PI, prob=0.5)

# plot raw data
plot(height ~ weight, d2, col=col.alpha(rangi2, .5))
# draw MAP
lines(weight.seq, mu.mean)
# draw HPDI region for line
shade(mu.PI, weight.seq)
# draw PI for simulated heights
shade(height.PI, weight.seq)

# PI for simulated heights: wide shaded region.
# the model expects to find 89% of actual heights in the population in this region

# Compatibility interval: The central 89% of the ways for the model to produce
# the data place the *average X* in this region
# 
# Prediction interval: also incorporates the standard deviation (uncertainty) of height
# 

#### Non-linear relationships ####

# polynomials
library(rethinking)
data(Howell1)
d <- Howell1

plot(height ~ weight, data=d)
d$weight_s <- (d$weight - mean(d$weight))/sd(d$weight)
d$weight_s2 <- d$weight_s^2
d$weight_s3 <- d$weight_s^3

# fitting the quap
m4.5 <- quap(
  alist(
    height ~ dnorm(mu, sigma),
#    mu <- a + b1*weight_s + b2*weight_s2,
    mu <- a + b1*weight_s + b2*weight_s2 + b3 * weight_s3,
    a ~ dnorm(178, 20),
    b1 ~ dlnorm(0,1), 
    b2 ~ dnorm(0,1),
    b3 ~ dnorm(0,1),
    sigma ~ dunif(0, 50)
  ), data=d)
precis(m4.5)
summary(m4.5)

# plotting the mean curves using the estimators
plot(height ~ weight_s, d)
coef <- m4.5@coef
curve(coef[1]+coef[2]*x+coef[3]*x^2+coef[4]*x^3, add=TRUE, col=col.alpha('red', alpha=1))

# generate a grid of values to create preditions for
weight.seq <- seq(from=-2.2, to=2, length.out=30)
pred_dat <- list(weight_s=weight.seq, weight_s2=weight.seq^2, weight_s3=weight.seq^3)
#pred_dat
#weight.seq

# generate distributions of posterior values for mu
mu <- link(m4.5, data=pred_dat)
mu.mean <- apply(mu, 2, mean)
mu.PI <- apply(mu, 2, PI, prob=0.89)
mu 

# simulate posterior observations (considers uncertainty stemming from sigma)
sim.height <- sim(m4.5, data=pred_dat)
height.PI <- apply(sim.height, 2, PI, prob=0.89)

# plot this
plot(height ~ weight_s, d, col=col.alpha(rangi2, .5))
lines(weight.seq, mu.mean)
shade(mu.PI, weight.seq)
shade(height.PI, weight.seq)


#### Splines ####
data("cherry_blossoms")
d <- cherry_blossoms
precis(d, hist=F)

plot(doy~year, data=d)
