from numpy import diag, ones , eye, kron, arange, pi, sin, cos, dot
from numpy.linalg import norm
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
    """ computes the 2D laplacian on the [0,1]^2 square

    >>v11=outer(v1D(3),v1D(3)).flatten(); norm(dot(K2D(3),v11)-2*val1D(3)*(2-1)**2*v11)<1e-10
    True
    
    """
    return  (n-1)**2 * (kron(K1D(n), eye(n)) + kron(eye(n), K1D(n)))

#def compute_locale(self):
#        """
#        schema explicite 
#    
#        u[i,j]^{n+1}-u[i,j]^{n} = dt/(h_x*h_y) * (u[i-1,j] + u[  
#        
#        """
#        diag_x = - 2.0 + self.hx*self.hx/(2.*self.dt)
#        diag_y = - 2.0 + self.hy*self.hy/(2.*self.dt)
#        w_x =  self.dt /(self.hx * self.hx)
#        w_y =  self.dt /(self.hy * self.hy)
#        u=self.u
#        u_out[1:-1, 1:-1] = (u[0:-2, 1:-1] + 
#                             u[2:  , 1:-1] + 
#                             u[1:-1, 1:-1] * diag_x ) * w_x +\
#                            (u[1:-1, 0:-2] + 
#                             u[1:-1, 2:  ] + 
#                             u[1:-1, 1:-1] * diag_y ) * w_y
#



if __name__ == "__main__":
    import doctest
    doctest.testmod() 
   

