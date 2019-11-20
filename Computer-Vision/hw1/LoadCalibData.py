'''Visualises the data file for cs410 camera calibration assignment
To run: %run LoadCalibData.py
'''
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d

data = np.loadtxt('data.txt')

endPoints = None
point = None

def calibrateCamera3D(data):

    final_matrix = []

    for line in data:
        worldX = line[0]
        worldY = line[1]
        worldZ = line[2]

        imageX = line[3]
        imageY = line[4]

        X = [worldX, worldY, worldZ, 1, 0, 0, 0, 0, -imageX * worldX, -imageX * worldY, -imageX * worldZ, -imageX]
        
        Y = [0, 0, 0, 0, worldX, worldY, worldZ, 1, -imageY * worldX, -imageY * worldY, -imageY * worldZ, -imageY]

        final_matrix.append(X)
        final_matrix.append(Y)

    final_matrix = np.asarray(final_matrix)

    D, V = np.linalg.eig(final_matrix.transpose().dot(final_matrix))

    estlp = V[:,np.argmin(D)]

    P = np.zeros((3,4))
    P[0:] = estlp[0:4]
    P[1:] = estlp[4:8]
    P[2:] = estlp[8:12]

    return P

def visualiseCameraCalibration3D(data, P):
    global endPoints
    global point

    worldX = data[:,0]
    worldY = data[:,1]
    worldZ = data[:,2]

    imageX = data[:,3]
    imageY = data[:,4]

    worldPoints = np.ones((491, 4))
    for x in range(len(data)):
        worldPoints[x,0] = worldX[x]
        worldPoints[x,1] = worldY[x]
        worldPoints[x,2] = worldZ[x]

    point = np.ones((491, 3))
    for x in range(len(data)):
        point[x,0] = imageX[x]
        point[x,1] = imageY[x]

    worldPoints = P.dot(worldPoints.transpose())
    endPoints = worldPoints.transpose()

    endPoints[:,0] = endPoints[:,0] / endPoints[:,2]
    endPoints[:,1] = endPoints[:,1] / endPoints[:,2]

    fig = plt.figure()
    ax = fig.gca()
    ax.plot(endPoints[:,0], endPoints[:,1], 'g.')

    ax.plot(data[:,3], data[:,4], 'r.')
    plt.show()

def evaluateCameraCalibration3D(data, P):
    global endPoints
    global point

    dist = np.subtract(point, endPoints)
    print("Average distance between the two matrices is: " + str(np.mean(dist)) )

    print("Standard deviation/variance of measured 2D points: " + str(np.std(point)))
    print("Standard deviation/variance of re-projected 2D points: " + str(np.std(endPoints)))

    print("Maximum distance between the two matrices: " + str(np.abs(np.max(dist))))

    print("Minimum distance between the two matrices: " + str(np.abs(np.min(dist))))

P = calibrateCamera3D(data)

visualiseCameraCalibration3D(data, P)

evaluateCameraCalibration3D(data, P)