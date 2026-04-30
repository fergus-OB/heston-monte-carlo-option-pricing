#############################################################################@@@@@@@@@@@@@@@@@@@@@@@@
rm(list=ls(all=TRUE))
T = 0.5
Dt = 1/252
N = T / Dt
r = 0.04
kappa = 2.0
theta = 0.04
sigma_v = 0.5
rho = -0.7
S_0 = 1250
V_0 = 0.04
S_t= S_0
v_t= V_0
S_vec = c(S_t)
v_vec = c(v_t)

set.seed(44)
K=1250 #for atm put option


####heston path 
path_Heston = function(){
  S_vec = numeric(N+1)
  V_vec =numeric(N+1)
  S_vec[1]=S_0
  V_vec[1]= V_0
  S_t = S_0   #local S_t +v_t
  v_t = V_0
  
  for (i in 1:N){
    Z1 = rnorm(1)
    Z2 =rnorm(1)
    W_v =Z1
    W_s =rho * Z1 + sqrt(1 - rho^2) * Z2
    dv_t= kappa * (theta - v_t) * Dt + sigma_v * sqrt(abs(v_t))* sqrt(Dt)* W_v   #fixed dt
    v_t =abs(v_t + dv_t) #positiv values only
    S_t =S_t * exp( (r - 0.5*v_t) *Dt +sqrt(v_t* Dt)* W_s )
    S_vec[i+1] =S_t   #c() wouldnt work
    V_vec[i+1] = v_t
  }
  return(list(S= S_vec,V= V_vec))
}
example = path_Heston()
plot(example$S, type='l', main='Simulated Heston Path', ylab='Asset Price', xlab='Time')



###Simulate
n_paths <- 10000
S_T = numeric(n_paths)    # end prices for European opts
S_avg = numeric(n_paths)    #avg prices for Asian
barrier_hit = numeric(n_paths) 

for(j in 1:n_paths){
  path = path_Heston()
  S_path = path$S
  
  S_T[j] = S_path[N+1]
  S_avg[j] = mean(S_path)
  barrier_hit[j] = any(S_path <= 0.95 *S_0)
}


# question 1 eurpoean call
ecall_pay = pmax(S_T - K,0)
call_price= exp(-r*T)*mean(ecall_pay)
call_se = sd(ecall_pay) / sqrt(n_paths)

#European put
put_payoff = pmax(K - S_T, 0)
put_price = exp(-r*T) * mean(put_payoff)
put_se = sd(put_payoff) / sqrt(n_paths)

# Asian call
asian_pay = pmax(S_avg - K, 0)
asian_price = exp(-r*T) * mean(asian_pay)
asian_se = sd(asian_pay)/sqrt(n_paths)

# Barier Type digital put
barrier_payoff = barrier_hit  #pays 1 if is hit
barrier_pric = exp(-r*T) * mean(barrier_payoff)
barrier_se = sd(barrier_payoff) / sqrt(n_paths)


#### BS Comparison
#in class, use sigma = sqrt(theta)
sigma_bs = sqrt(theta)

d1 = (log(S_0/K) + (r + 0.5*sigma_bs^2)*T) / (sigma_bs*sqrt(T))
d2 = d1 -sigma_bs*sqrt(T)

# BS Call price
bs_call = S_0 * pnorm(d1) - K * exp(-r*T) * pnorm(d2)

# BS Put price put call parity
bs_put = K * exp(-r*T)*pnorm(-d2) -S_0* pnorm(-d1)


cat("European call price (Heston MC):", call_price, "SE:", round(call_se,4), "\n")
cat("European put price (Heston MC):",put_price, "SE:", round(put_se,4), "\n")
cat("Asian call price (Heston MC):", asian_price, "SE:", round(asian_se,4), "\n")
cat("Barrier option price (Heston MC):", barrier_pric, "SE:", round(barrier_se,4), "\n")
cat("Black-Scholes call price:", bs_call, "\n")
cat("Black-Scholes put price;", bs_put, "\n")

#plots
example_path =path_Heston()
plot(example_path$S, type='l', main='Example Heston Path', ylab='Price',xlab='Time')
hist(S_T, breaks=50, main='Histogram of Terminal Prices', xlab='S_T')

#!!!!!! Extra question
# get barrier_price = 0.5
#different values as in class
#we could change kappa, theta, sigma_v
#try maje a loop for sigma keeping rest constant

sigma_v_vals = seq(0, .25, by=0.05)# make it smaller in class it was like.2
results = numeric(length(sigma_v_vals))
n_paths_test = 10000

for(s in 1:length(sigma_v_vals)){
  sigma_v = sigma_v_vals[s]
  barrier_hit= numeric(n_paths_test)
  for(j in 1:n_paths_test){
    path = path_Heston()
    S_path = path$S
    barrier_hit[j] = any(S_path <= 0.95 * S_0)}
  barrier_pric = exp(-r*T) * mean(barrier_hit)
  results[s] = barrier_pric
  cat("sigma_v is", sigma_v, "barrier price:", barrier_pric, "\n")
}
#ok thats not gonna work lets try change rest

theta = 0.005
kappa = 14
sigma_v = 0.25

barrier_hit = numeric(1000)
for(j in 1:10000){#try10000 
  path = path_Heston()
  S_path = path$S
  barrier_hit[j]=any(S_path<= 0.95*S_0)
}
barrier_pric =exp(-r*T) * mean(barrier_hit)
cat("Barrier price with theta ", theta, " sigma_v =", sigma_v, " kappa =", kappa, "is", barrier_pric, "\n")
    