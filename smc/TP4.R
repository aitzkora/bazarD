# fonction simuler selon l'a priori initial  p(x_1)
mu_1 = 0
sigma_1 = 1
init = function (n_part)  { mu_1 + sigma_1 * rnorm(n_part) }

# fonction simuler selon un nouvel etat : x_t | x_{t-1} 
sigma_u = 1
evol = function (x) { x + sigma_u * rnorm(length(x)) }

# fonction simuler une mesure : y_t | x_t
sigma_v = 1
measure = function (x) { x + sigma_v * rnorm(1) }

# fonction log-vraisemblance : densité p(y_t | x_t)
log_likelihood = function(y, x) { -0.5*log(2*pi)-log(sigma_v)- 0.5 * ((y-x)/sigma_v)^2 }

# fontion generation de donnees
sample_data = function (t_final) {
  x=vector(length=t_final)
  y=vector(length=t_final)
  x[1]=init(1);
  y[1]=measure(x[1]);
  for (t in 2:t_final) {
    x[t]=evol(x[t-1])
    y[t]=measure(x[t])
  }
  return (list(x=x, y=y))
}

# fonction filtre de kalman
kalman_filter = function (y) {
  require(sspir)
  model_sspir <- sspir::SS(Fmat = function(tt, x, phi) {return(matrix(1))},
                           Gmat = function(tt, x, phi) {return(matrix(1))},
                           Vmat = matrix(sigma_v^2),
                           Wmat = matrix(sigma_u^2),
                           y=as.matrix(y),
                           m0=matrix(mu_1),
                           C0=matrix(sigma_1^2))
  
  kf_sspir = sspir::kfilter(model_sspir)
  x_mean = kf_sspir$m # moyenne
  x_sd = sqrt(as.numeric(kf_sspir$C)) # ecart-type
  
  return(list(x=x_mean, sd=x_sd))
}

# fonction re-echantillonnage multinomial
resample = function (w_t, x_t) {
  # on tire une uniforme entre 0 et 1
  u = runif(length(w_t))
  
  # indices des particules parentes
  idx = rowSums(outer(u, cumsum(w_t), ">"))+1
  
  # reaffectations
  x_t = x_t[idx]
  
  return (x_t)
}

# fonction filtre particulaire
particle_filter <- function (t_final, # temps final
                             y_obs, # observations
                             N) # nombre de particules
{
  # allocation
  x     = matrix(NA, N, t_final) # valeurs des particules
  log_w = matrix(NA, N, t_final) # logarithmes des poids
  w     = matrix(NA, N, t_final) # poids
  ess   = vector(length=t_final) # effective sample size
  
  # initialisation
  x[,1] = init(N)
  # calcul des poids
  log_w[,1] = log_likelihood(y_obs[1], x[,1])
  w[,1] = exp(log_w[,1])
  # normalisation
  w_sum = sum(w[,1])
  w[,1] = w[,1] / w_sum
  log_w[,1] = log_w[,1] - log(w_sum)
  # log vraisemblance marginale
  log_z = log(w_sum)
  # effective sample size
  ess[1] = 1/sum(w[,1]^2)
  
  # itérations
  for(t in 2:t_final) {
    # re-echantillonnage
    x[,t-1] = resample(w[,t-1], x[,t-1])
    log_w[,t-1] = matrix(-log(N), N)
    w[,t-1] = matrix(1/N, N)
    
    # mutation / exploration
    x[,t] = evol(x[,t-1])
    
    # calcul des poids 
    log_w[,t] = log_w[,t-1] + log_likelihood(y_obs[t], x[,t])
    w[,t] = exp(log_w[,t])
    
    # normalisation
    w_sum = sum(w[,t])
    w[,t] = w[,t] / w_sum
    log_w[,t] = log_w[,t] - log(w_sum)
    
    # log vraisemblance marginale
    log_z = log_z + log(w_sum)
    
    # effective sample size
    ess[t] = 1/sum(w[,t]^2)
  }
  return (list(x=x, w=w, ess=ess, log_z=log_z))
}

## Utilisation ----------------------------------

t_final = 20
data = sample_data(t_final)

# Filtre particulaire
N = 100
out_pf = particle_filter(t_final, data$y, N)

# effective sample size
plot(out_pf$ess, type='l',
     main="ESS")

# estimations
x_pf_mean = colSums(out_pf$w * out_pf$x)
x_pf_sd = sqrt(colSums(out_pf$w * out_pf$x^2) - x_pf_mean^2)
x_pf_inf = x_pf_mean-1.96*x_pf_sd
x_pf_sup = x_pf_mean+1.96*x_pf_sd

# affichage
plot(data$x, type='p',
     ylim=range(x_pf_inf, x_pf_sup)) # vraie valeur
lines(x_pf_mean, type='l', col='red') # moyenne particulaire
lines(x_pf_inf, col='red', lty="dashed") # intervalle de confiance à 95%
lines(x_pf_sup, col='red', lty="dashed")

# Kalman
out_kf = kalman_filter(data$y)

x_kf_mean = out_kf$x
x_kf_sd = out_kf$sd
x_kf_inf = x_kf_mean-1.96*x_kf_sd
x_kf_sup = x_kf_mean+1.96*x_kf_sd

lines(x_kf_mean, col='green')
lines(x_kf_inf, col='green', lty="dashed")
lines(x_kf_sup, col='green', lty="dashed")

# erreur vs kalman
err_kf_pf = mean((x_kf_mean -x_pf_mean)^2)

## Convergence -----------------------------

# valeurs croissantes de N
N = c(10,50,100,500,1000)

# calculer l'erreur globale vs kalman pour chaque valeur de N
# en moyennant sur plusieurs simulations de données
err_kf_pf = vector(length=length(N))

# nombre de jeux de données simulés
n_simu = 10

for (i in 1:n_simu) {
  t_final = 20
  # simuler des donnees
  data = sample_data(t_final)
  
  # Kalman
  out_kf = kalman_filter(data$y)
  
  x_kf_mean = out_kf$x
  
  for (j in 1:length(N)) {
    # Filtre particulaire
    out_pf = particle_filter(t_final, data$y, N[j])
    
    # estimations
    x_pf_mean = colSums(out_pf$w * out_pf$x)
    
    # erreur vs kalman
    err_kf_pf[j] = err_kf_pf[j] + mean((x_kf_mean -x_pf_mean)^2)
  }
}

# moyennage des erreurs
err_kf_pf = err_kf_pf/n_simu

plot(N, log(err_kf_pf), type='b')
