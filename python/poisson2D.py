import numpy as np
def K1D(n):
    K =2*np.eye(n) - np.diag(np.ones(n-1),-1)\
                   - np.diag(np.ones(n-1), 1)
    return K

def K2D(nx,ny):
    return np.kron(K1D(nx),np.eye(ny)) + np.kron(eye(nx), np.eye(ny))


from numpy.random import rand


