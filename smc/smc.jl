function smc(init, logl, evol, resa, T, y, N)

    x     = zeros(N, T)
    log_w = zeros(N, T)
    w     = zeros(N, T)
    ess   = zeros(T)

    x[:, 1] = init(N)

    log_w[:, 1] = logl(y[1], x[:, 1])
    w[:, 1] = exp(log_w[:, 1])
    
    w_sum = sum(w[:, 1])
    w[:, 1] /= w_sum
    log_w[:, 1] -= log(w_sum)

    log_z = log(w_sum)
    ess[1] = 1. / sum(w[:, 1].^2)  

    for t = 2:T
        x[:, t - 1] = resa(w[:, t - 1], x[:, t - 1])
        log_w[:, t-1] = -log(N)
        w[:, t - 1] = 1./ N

        x[:, t] = evol(x[:, t - 1])

        log_w[:, t] = log_w[:, t - 1] + logl(y[t], x[:, t])
        w[:, t] = exp(log_w[:, t])

        w_sum = sum(w[:, t])
        w[:, t] /= w_sum
        log_w -= log(w_sum)

        log_z += log(w_sum)

        ess[t] = 1./ sum(w[:, t].^2)
    end
    
    return x, w, ess, log_z

end

mu_1 = 0
sigma_1 = 1
init = N -> mu_1 + sigma_1 * randn(N)

sigma_u = 1
evol = x -> x + sigma_u * randn()

sigma_v = 1
measure =  x -> x + sigma_v * randn()

logl = (x,y) -> - 0.5 * log(2 *pi) - log(sigma_v) - 0.5 * ((y-x) / sigma_v).^2

function gen_data(T)
    x = zeros(T)
    y = zeros(T)
    x[1] = init(1)[1]
    y[2] = measure(x[1])
    for t = 2:T
        x[t] = evol(x[t-1])
        y[t] = measure(x[t])
    end
    return x,y
end

function resample(w,x)
     #u = rand(size(w,1))
     u = 1./ size(w,1)*ones(size(w,1))
     idx = sum(bsxfun(>,u',cumsum(w)),1) + 1
     return x[idx]
end 

function resample2(w::Array{Float64,1},x::Array{Float64,1})
    n = size(w,1)
    W = cumsum(w)
    u = rand(n)
    idx = zeros(Int32,n)
    for i=1:n
        for j=1:n
            idx[i] += (u[i] >  W[j]) ? 1 : 0
        end    
    end
    return x[idx+1]
end    



t_final =  20
N = 10000
x, y  = gen_data(t_final)
@time x_smc, w, ess, log_z  = smc(init, logl, evol, resample2, t_final, y, N);
#@time x_smc, w, ess, log_z  = smc(init, logl, evol, resample, t_final, y, N);
