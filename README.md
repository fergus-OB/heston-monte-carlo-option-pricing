# Heston Monte Carlo Option Pricing

An R-based Monte Carlo simulation project using the **Heston stochastic volatility model** to simulate asset price paths and price derivative contracts.

This project demonstrates stochastic modelling, Monte Carlo simulation, correlated Brownian motion, option pricing, and comparison against Black-Scholes style benchmark methods.

## Project Overview

The Heston model extends the Black-Scholes framework by allowing volatility itself to evolve randomly over time. This makes it more realistic for financial markets, where volatility is not constant.

This project simulates asset paths under stochastic volatility and applies Monte Carlo methods to estimate option values.

## Objectives

- Simulate asset price paths using the Heston stochastic volatility model.
- Model stochastic variance using mean reversion, volatility of volatility, and correlation between asset and variance shocks.
- Price option contracts using Monte Carlo simulation.
- Estimate standard errors for simulated prices.
- Compare stochastic-volatility results against simpler benchmark pricing methods.

## Model Summary

The Heston model uses two coupled stochastic processes:

```math
dS_t = \mu S_t dt + \sqrt{v_t} S_t dW_t^S
```

heston-monte-carlo-option-pricing/
├── src/
│   ├── heston_monte_carlo_pricing.R
│   ├── heston_simulation.R
│   └── black_scholes_pricing.R
├── outputs/
│   └── simulated_heston_path.jpeg
├── docs/
├── README.md
├── .gitignore
└── LICENSE

```
