'''Visualises the data file for cs410 camera calibration assignment
To run: %run LoadCalibData.py
'''
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d

data = np.loadtxt('X:/4thYear/4th-Year-Modules/Computer-Vision/HW1/data.txt')


def calibrateCamera3D(data):
    world_points = data[:,:3]  # Gets the first 3 points (x, y, z) of real world
    # print(world_points[:,0:1])
    # quit()

    image_points = data[:, 3:] # Gets the last two (X,Y) of 2d world
    # print(world_points, "\n" ,image_points)
    # print(image_points.shape[0])
    # print(image_points.shape[1])
    # print(world_points.shape[2])
    # quit()
    # quit()
    # b = np.ones((image_points.shape[0], image_points.shape[1] + 1))
    # b[:, :-1] = image_points
    # b = np.ones(world_points.shape[0], world_points.shape[1]+ 1)
    # b = np.ones((image_points.shape[0], image_points.shape[1] + 1))
    # b[:, :-1] = image_points
    b = np.ones((world_points.shape[0], 1))
    
    #print(np.hstack((world_points, b)))
    # # print(np.dot(world_points, b.transpose()))
    # # print(np.dot(world_points.transpose(), image_points))
    # quit()
    # print(image_points)
    A = np.zeros((len(data) * 2, 12))

    for i in range(len(data)):
        worldX = world_points[i][0]
        worldY = world_points[i][1]
        worldZ = world_points[i][2]

        imageX = image_points[i][0]
        imageY = image_points[i][1]
        # imageZ = int(b[i][2])

        X = [worldX, worldY, worldZ, 1, 0, 0, 0, 0, -imageX * worldX, -imageX * worldY, -imageX * worldZ, -imageX]
        # Y: [0, 0, 0, 0, 1, X, Y, Z, -yX, -yY, -yY, -y]
        Y = [0, 0, 0, 0, worldX, worldY, worldZ, 1, -imageY * worldX, -imageY * worldY, -imageY * worldZ, -imageY]

        

        #A = np.append(X, Y)
        print(f"{X} \n {Y}")

    # print(A)
    D, V = np.linalg.eig(A.transpose().dot(A))
    print(D)
    print()
    print()
    print(V)
    # print(A)
    quit()



fig = plt.figure()
ax = fig.gca(projection="3d")
ax.plot(data[:,0], data[:,1], data[:,2],'k.')

fig = plt.figure()
ax = fig.gca()
ax.plot(data[:,3], data[:,4],'r.')

# plt.show()
calibrateCamera3D(data)