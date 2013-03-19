import numpy as np
def K1D(n):
    """
    Compute the 1D laplacian matrix
    
    >>> np.diag(K1D(4)).tolist()
    [2.0, 2.0, 2.0, 2.0]
    >>> np.diag(K1D(3),-1).tolist()
    [-1.0, -1.0]
    >>> np.diag(K1D(4),1).tolist()
    [-1.0, -1.0, -1.0]
    """

    K =2*np.eye(n) - np.diag(np.ones(n-1),-1)\
                   - np.diag(np.ones(n-1), 1)
    return K


def K2D(nx,ny):
    return np.kron(K1D(nx),np.eye(ny)) + np.kron(eye(nx), np.eye(ny))

def compute_locale(self):
        """
        schema explicite 
    
        u[i,j]^{n+1}-u[i,j]^{n} = dt/(h_x*h_y) * (u[i-1,j] + u[  
        
        """
        diag_x = - 2.0 + self.hx*self.hx/(2.*self.dt)
        diag_y = - 2.0 + self.hy*self.hy/(2.*self.dt)
        w_x =  self.dt /(self.hx * self.hx)
        w_y =  self.dt /(self.hy * self.hy)
        u=self.u
        u_out=u.copy()
        u_out[1:-1, 1:-1] = (u[0:-2, 1:-1] + 
                             u[2:  , 1:-1] + 
                             u[1:-1, 1:-1] * diag_x ) * w_x +\
                            (u[1:-1, 0:-2] + 
                             u[1:-1, 2:  ] + 
                             u[1:-1, 1:-1] * diag_y ) * w_y




if __name__ == "__main__":
    import doctest
    doctest.testmod() 
   

