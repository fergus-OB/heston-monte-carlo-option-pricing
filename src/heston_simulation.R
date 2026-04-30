
T=1
dt=1/252 # mesh-size is one business day in the US
N=T/dt
# Heston stochastic variance v_t
sigma=0.16 # standard deviation of returns in B-S
sigma_v=0.1
kappa=3
theta=sigma^2# need to square to get variance of returns


# Asset Path S_t

mu=0.08 #annualized average return of S&P500
rho=-0.9 # for leverage effect 
#(corr of Brownian motions' increments)


########################
v_0=theta #start at mean-reversion level theta.(choice)
v_t=v_0
v_vec=c(v_0)
S_0=100
S_t=S_0 #starting value
S_vec=c(S_0)#asset price path


for (i in 1:N){
#For stochastic variance:
dB1=rnorm(1,0,sqrt(dt))
dv_t=kappa*(theta-v_t)*dt+sigma_v*sqrt(v_t)*dB1
v_t=abs(v_t+dv_t)# the absolute value ensures positivity
v_vec=c(v_vec,v_t)
##For Asset simulation:
dB3=rnorm(1,0,sqrt(dt))#auxilliary BM increment
#independent of dB1
dB2=rho*dB1+sqrt(1-rho^2)*dB3 #correlation will be rho
# Cov(dB1,dB2)=rho*dt
dS_t=S_t*(mu*dt+sqrt(v_t)*dB2)
S_t=S_t+dS_t
S_vec=c(S_vec,S_t)
}

plot(S_vec,type='l')
