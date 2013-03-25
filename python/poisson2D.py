from numpy import diag, ones , eye, kron, arange, pi, sin, cos, dot, outer, r_, real, zeros, imag, linspace
from numpy.linalg import norm
from scipy.fftpack import fft
def K1D(n):
    """
    Compute the 1D laplacian matrix
    
    >>> diag(K1D(4)).tolist()
    [2.0, 2.0, 2.0, 2.0]
    >>> diag(K1D(3),-1).tolist()
    [-1.0, -1.0]
    >>> diag(K1D(4),1).tolist()
    [-1.0, -1.0, -1.0]
    >>> norm(val1D(3)*v1D(3)-dot(K1D(3),v1D(3)))<1e-10
    True
    """

    K = 2 * eye(n) - diag(ones(n-1), -1)\
                   - diag(ones(n-1),  1)
    return K


def val1D(n, k = 1):
     return (2 - 2 * cos(k * pi / (n + 1)))

def v1D(n, k = 1):
     return sin(arange(1, n + 1) * k * pi / (n + 1))

def K2D(n):
    """ computes the 2D laplacian on the interior of the [0,1]^2 square
    if X is a (n+2) x (n+2), you could apply K2D
    to the vector X[1:-1,1:-1].flatten()

    >>> v11=outer(v1D(3),v1D(3)).flatten(); norm(dot(K2D(3),v11)-2*val1D(3)*(3+1)**2*v11)<1e-10
    True
    
    """
    return  (n+1)**2 * (kron(K1D(n), eye(n)) + kron(eye(n), K1D(n)))


def dst1D(x):
    return real(-fft(r_[0,x,0,-x[::-1]])[1:x.shape[0]+1]/2.j)

def dst1Dp(x):
    return -imag(fft(r_[0,x,zeros(x.shape),0])[1:x.shape[0]+1])

def dst2D(X):
    Y=zeros(X.shape)
    for i in range(X.shape[0]):
        Y[i,:] = dst1D(X[i,:].T).T
    for j in range(X.shape[1]):
        Y[:,j] = dst1D(Y[:,j])
    return Y    

def fft2D(X):
    Y=zeros(X.shape,dtype='complex')
    for i in range(X.shape[0]):
        Y[i,:] = fft(X[i,:].T).T
    for j in range(X.shape[1]):
        Y[:,j] = fft(Y[:,j])
    return Y    


def K2D_sparse(x):

        """
        applique le laplacien_2D a x 
     
        >>> u=linspace(0,1,5)
        >>> X_in=u[None,:]*u[:,None]; 
        >>> X_in[0, :] = 0; X_in[-1, :] = 0; 
        >>> X_in[:, 0] = 0; X_in[:, -1] = 0;
        >>> norm(K2D_sparse(X_in)[1:-1,1:-1].flatten()-dot(K2D(3),X_in[1:-1,1:-1].flatten()))<1e-27
        True
        
        """
        H = zeros(x.shape)
        H[1:-1, 1:-1] = 2. * x[1:-1, 1:-1] - x[0:-2, 1:-1] - x[2:, 1:-1] + \
                        2. * x[1:-1, 1:-1] - x[1:-1, 0:-2] - x[1:-1, 2:] 
 
        return (x.shape[0]-1)**2*H




if __name__ == "__main__":
    import doctest
    doctest.testmod() 
   

