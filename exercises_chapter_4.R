library(rethinking)

# 4M1
mu = rnorm(1e4, 0, 10)
sigma = rexp(1e4, 1)
y_post_sim <- rnorm(1e4, mu, sigma )
dens(y_post_sim)

# 4M2
m.4m2 <- quap(
  alist(
    y ~ dnorm(mu, sigma),
    mu ~ dnorm(0, 10),
    sigma ~ dexp(1)
  ), data = d
)

# 4M4

# when we speak of students, we may need to distinguish school pupils and university
# students. The latter may have no growth at all in consecutive years so for the 
# purpose of this excercise we assume that we deal with school pupils.
year = seq(0, 2)
N = 1000
a = rnorm(N, 130, 10)
b = rlnorm(N, 2, 0.5)
sigma = runif(N, 0, 1)
mu = a+b*year
h = rnorm(N, mu, sigma)

plot( 
  NULL,
  xlim=range(year),
  ylim=c(100,200), 
  xlab="year",
  ylab="height")

for (i in 1:N) curve(a[i]+b[i]*(x),
      from=min(year),
      to=max(year),
      add=TRUE,
      col=col.alpha("black", 0.2))

class(b)


#### 4M7 ####
library(rethinking)
data(Howell1) 
d <- Howell1
d2 <- d[d$age>=18,]
plot (d2$height~d2$weight)

# define the average weight, x-bar
xbar <- mean(d2$weight)

# fit the model including xbar
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

# fit the model omitting xbar
m4.3_no_xbar <- quap(
  alist(
    height ~ dnorm(mu, sigma),
    mu <- a + b*(weight),
    a ~ dnorm(178,20),
    b ~ dlnorm(0,1),
    sigma ~ dunif(0, 50)
  ), data=d2)

precis(m4.3_no_xbar)
round(vcov(m4.3_no_xbar), 3)

# sampling mu from the posterior
post_xbar <- extract.samples(m4.3)
post_no_xbar <- extract.samples(m4.3_no_xbar)

a_xbar <- mean(post_xbar$a)
a_no_xbar <- mean(post_no_xbar$a)

b_xbar <- mean(post_xbar$b)
b_no_xbar <- mean(post_no_xbar$b)

# plotting the MAP and compatibility intervals
plot(height~weight, data=d2, col=rangi2)
curve(a_xbar+b_xbar*(x-xbar), add=TRUE)
curve(a_no_xbar+b_no_xbar*(x), add=TRUE)

weight.seq <- seq(30, 70, by=1)
mu <- link(m4.3, data=data.frame(weight=weight.seq))
mu.PI_xbar <- apply(mu, 2,  PI, prob=.89)
shade(mu.PI_xbar, weight.seq)

mu <- link(m4.3_no_xbar, data=data.frame(weight=weight.seq))
mu.PI_no_xbar <- apply(mu, 2,  PI, prob=.89)
shade(mu.PI_no_xbar, weight.seq)

# simulating data for model with and without xbar
sim.height_xbar <- sim(m4.3, data=list(weight=weight.seq))
sim.height_no_xbar <- sim(m4.3_no_xbar, data=list(weight=weight.seq))

height.PI_xbar <- apply(sim.height_xbar, 2, PI, prob=0.5)
height.PI_no_xbar <- apply(sim.height_no_xbar, 2, PI, prob=0.5)

shade(height.PI_no_xbar, weight.seq, col = col.alpha(rangi2))
shade(height.PI_xbar, weight.seq)


