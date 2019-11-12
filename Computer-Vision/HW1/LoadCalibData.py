'''Visualises the data file for cs410 camera calibration assignment
To run: %run LoadCalibData.py
'''
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d

data = np.loadtxt('X:/4thYear/4th-Year-Modules/Computer-Vision/HW1/data.txt')

def calibrateCamera3D(data):
    world_points = data[:,:3]  # Gets the first 3 points (x, y, z) of real world
    
    b = np.ones((world_points.shape[0], 1))
    
    A = np.zeros((len(data) * 2, 12))

    final_matrix = []

    for line in data:
        worldX = line[0]
        worldY = line[1]
        worldZ = line[2]

        imageX = line[3]
        imageY = line[4]
        # imageZ = int(b[i][2])

        X = [worldX, worldY, worldZ, 1, 0, 0, 0, 0, -imageX * worldX, -imageX * worldY, -imageX * worldZ, -imageX]
        
        # Y: [0, 0, 0, 0, 1, X, Y, Z, -yX, -yY, -yY, -y]
        Y = [0, 0, 0, 0, worldX, worldY, worldZ, 1, -imageY * worldX, -imageY * worldY, -imageY * worldZ, -imageY]

        final_matrix.append(X)
        final_matrix.append(Y)
        # print(A_NEW)

        # print(f"{X} \n {Y}")

    final_matrix = np.asarray(final_matrix)

    D, V = np.linalg.eig(final_matrix.transpose().dot(final_matrix))

    estlp = V[:,np.argmin(D)]
    #print(estlp)
    ypts_est =(-(estlp[2] + estlp[0]*X) / estlp[1])
    print(ypts_est)

    quit()



fig = plt.figure()
ax = fig.gca(projection="3d")
ax.plot(data[:,0], data[:,1], data[:,2],'k.')

fig = plt.figure()
ax = fig.gca()
ax.plot(data[:,3], data[:,4],'r.')

# plt.show()
calibrateCamera3D(data)