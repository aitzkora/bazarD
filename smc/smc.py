from numpy import zeros, exp, log, sum, pi, cumsum, sqrt, 


def smc(init, logl, evol, resa, T, y, N):
    """
    run a 1D filter particle on an horizon [1,T]
    with N particles and observed data

    Inputs:
    init ~ initial state density 
    logl ~ log likelihood function : (y, x) -> log P(y | x)
    evol ~ evolution function x[t] -> x[t+1]
    resa ~ resample function
    T ~ final time (integer)
    y ~ vector of observed data
    N ~ number of particles (integer)
    
    Output
    
    x ~ state space matrix 
    w ~ weigths matrix  
    ess ~ ess vector
    log_z ~ marginal log likelihood

    """
    
    x     = zeros((N, T))
    log_w = zeros((N, T))
    w     = zeros((N, T))
    ess   = zeros(T)
    
    # init 
    x[:, 0] = init(N)
    
    # calcul des poids
    log_w[:, 0] = logl(y[0], x[:, 0])
    w[:, 0] = exp(log_w[:, 0])
    
    # et normalisation 
    w_sum = sum(w[:, 0])
    w[:, 0] /= w_sum
    log_w[:, 0] -= log(w_sum)

    # log vraisemblance marginale
    log_z = log(w_sum)

    # effective sample size
    ess[0] = 1. / sum(w[:, 0]**2)

    # iterations
    for t in range(1, T):
        x[:, t - 1] = resample(w[:, t - 1], x[:, t - 1])
        log_w[:, t - 1] = -log(N)
        w[:, t - 1] = 1./ N

        # mutation
        x[:, t] = evol(x[:, t - 1])

        # weights computation
        log_w[:, t] = log_w [:, t - 1] + logl(y[t], x[:, t])
        w[:, t] = exp(log_w[:, t])

        # normalization
        w_sum = sum(w[:, t])
        w[:, t] /= w_sum
        log_w -= log(w_sum)

        #marginal log likelihood
        log_z += log(w_sum)

        ess[t] = 1./ sum(w[:, t]**2)
    
    return x, w, ess, log_z


# example of parameters
from numpy.random import randn, rand

# initial state 
mu_1 = 0
sigma_1 = 1
init = lambda N : mu_1 + sigma_1 * randn(N)

# evolution
sigma_u = 1
evol = lambda x : x+ sigma_u * randn()

# simulate a measure
sigma_v = 1
measure = lambda x : x + sigma_v * randn()

# logl
logl = lambda x, y : -0.5 * log( 2 * pi) - log(sigma_v) - 0.5 * ((y - x)/sigma_v)**2

# genere data
def gen_data(T):
    x = zeros(T)
    y = zeros(T)
    x[0] = init(1)
    y[1] = measure(x[1])
    for t in range(1, T):
        x[t] = evol(x[t-1])
        y[t] = measure(x[t])
    return x,y

# resample
def resample(w, x):
    u = rand(w.shape[0])
    # indexes from parent particles
    idx = sum(u[None, :]>cumsum(w)[:, None], 0)
    #import pdb; pdb.set_trace()
    return x[idx]

t_final =  20
N = 10000
x, y  = gen_data(t_final)
import time
tic = time.time()
x_smc, w, ess, log_z  = smc(init, logl, evol, resample, t_final, y, N)
toc = time.time() -tic
print ("tps smc = %fs" % toc)
#x_pf_mean = sum(x_smc * w, 0)
#x_pf_sd = sqrt(sum( x_smc **2 * w, 0) - x_pf_mean**2)
#it=mgrid[0.:t_final]
#plot(it, x_pf_mean, '-', it, x_pf_mean - 1.96 * x_pf_sd, '-', 
#                         it, x_pf_mean + 1.96 * x_pf_sd, '-', it, x, '-')
