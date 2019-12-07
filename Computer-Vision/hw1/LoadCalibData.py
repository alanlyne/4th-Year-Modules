'''Visualises the data file for cs410 camera calibration assignment
To run: %run LoadCalibData.py
'''
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d

data = np.loadtxt('D:/Programming/University/Modules/Computer-Vision/hw1/data.txt')

fig = plt.figure()
ax = fig.gca(projection="3d")
ax.plot(data[:,0], data[:,1], data[:,2],'k.')

fig = plt.figure()
ax = fig.gca()
ax.plot(data[:,3], data[:,4],'r.')

fig = plt.figure()
ax = fig.gca(projection="3d")
ax.plot(data[:,0], data[:,1], data[:,2], data[:,3], data[:,4],'k.')

plt.show()


fig = plt.figure()
ax = fig.gca(projection="3d")
ax.plot(calibrateCamera3D(data))


P = calibrateCamera3D(data)

def calibrateCamera3D(data):
    data[:,0], data[:2]

plt.show()




