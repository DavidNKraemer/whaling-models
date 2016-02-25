# This script is a proof-of-concept which shows how to numerically solve the
# two-species competition environment model using Python. Specifically, this
# uses the odeint utility from SciPy.
#
# The odeint ODE solver uses the lsoda package from the FORTRAN library odepack.
#
# Sources:
# http://docs.scipy.org/doc/scipy-0.14.0/reference/generated/scipy.integrate.odeint.html
# http://scipy.github.io/old-wiki/pages/Cookbook/Zombie_Apocalypse_ODEINT

# coding: utf-8

import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import odeint

# The ODE model (LaTeX friendly)
# \begin{align*}
#     \frac{dx}{dt} &= r_1 x (1 - x/K_1) - \alpha_1 x y \\
#     \frac{dy}{dt} &= r_2 y (1 - y/K_2) - \alpha_2 x y
# \end{align*}
# 
# (Plaintext friendly)
#   x'(t) = r1 * x(t) * (1 - x(t) / K1) - a1 * x(t) * y(t)
#   y'(t) = r2 * y(t) * (1 - y(t) / K2) - a2 * x(t) * y(t)

# Parameters
[r1, r2] = [0.05, 0.08]
[K1, K2] = [150000, 400000]
[a1, a2] = [1e-8, 1e-8]

# ODE system function (for odeint)
def f(y, t):
    """
    Arguments:
        y -- a list of two floats (population levels)
        t -- a float or an ndarray of floats
    """
    Xi = y[0] # X population
    Yi = y[1] # Y population
    
    f0 = r1 * Xi * (1 - Xi / K1) - a1 * Xi * Yi
    f1 = r2 * Yi * (1 - Yi / K2) - a2 * Xi * Yi
    return [f0, f1]


# Initial conditions
X0 = 10000
Y0 = 10000
y0 = [X0, Y0]
t = np.linspace(0, 100., 1000)

# Resulting solutions
soln = odeint(f, y0, t)
X = soln[:, 0]
Y = soln[:, 1]

# Population levels over time
plt.plot(t, X, label='Blue Whale')
plt.plot(t, Y, label='Fin Whale')
plt.xlabel('Time')
plt.ylabel('Population')
plt.title('Whale populations')
plt.legend()
plt.show()

# Compute "derivative" of population levels
dX = np.diff(X) / X[:-1]
dY = np.diff(Y) / Y[:-1]

# Change in population over time
plt.plot(t[1:], dX, label='Blue Whale')
plt.plot(t[1:], dY, label='Fin Whale')
plt.xlabel('Time')
plt.ylabel('Percent change')
plt.title('Percent change in whale populations')
plt.legend()
plt.show()
