# european put: black scholes formula

s_t=99
K=80
r=0.05
sigma=0.16

T=3/12
t=0

vanilla_price=function(r,sigma,t,T,s_t,K){

d1=(log(s_t/K)+(r+sigma^2/2)*T-t)/(sigma*sqrt(T-t))
d2=d1-sigma*sqrt(T-t)
put_price=K*exp(-r*(T-t))*pnorm(-d2) - s_t*pnorm(-d1)
call_price=s_t*pnorm(d1)-K*exp(-r*(T-t)) *pnorm(d2)

# verify Put-Call_Parity
#call_price-put_price
#s_t-k*exp(-r*(T-t))

return(c(call_price, put_price))
}

vanilla_price(r,sigma,t,T,s_t,K)

prices_vec=Vectorize(vanilla_price, "K")

plot(prices_vec(r,sigma,t,T,s_t,c(80:120))[2,],type='l')



# option deltas
option_deltas=function(r,sigma,t,T,s_t,K){
d1=(log(s_t/K)+(r+sigma^2/2)*T-t)/(sigma*sqrt(T-t))
d2=d1-sigma*sqrt(T-t)
return(c(call_price, put_price))
}





# replication at t=0

# specified by: initial wealth, cash, and risky asset holdings
# option writer sells 1 put, they collect the premium.
s_t=1250
K=1250*exp(r*T)

premium=vanilla_price(r=0.05,sigma=0.16,t=0,T=T,s_t,K)[2] 
premium

# premium is invested in replicating strategy
# initial wealth = premium
v_0=premium
phi_1=option_deltas(r=0.05, sigma=0.16,t=0,T=3/12,s_t=1250,K) # number of shares held Option Delta for put -Phi(-d1)
cash=v_0-phi_1*s_t  
print(c(cash,phi_1)) # trading strategy
# cash position >0, option delta roughly -1/2 (because ATM PUT)


#after one day (dt=1/252) we have to rebalance the portfolio to maintain the target.
s_t=s_t*(1+0.01)
print(s_t)
phi_1_new=option_deltas(r=0.05,sigma=0.16,t=1/252,T=3/12,s_t,K)[2]
print(c(phi_1,phi_1_new))
# new wealth, new option delta, new cash position

v_1=phi_1*s_t+cash*(1+r/360)
print(c(v_0,v_1))
cash_new=v_1-phi_1_new*s_t
print(cash_new)
