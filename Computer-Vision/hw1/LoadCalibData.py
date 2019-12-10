import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d

data = np.loadtxt('D:/Programming/University/Modules/Computer-Vision/hw1/data.txt')

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
    for line in range(len(data)):
        worldPoints[line,0] = worldX[line]
        worldPoints[line,1] = worldY[line]
        worldPoints[line,2] = worldZ[line]

    point = np.ones((491, 3))
    for line in range(len(data)):
        point[line,0] = imageX[line]
        point[line,1] = imageY[line]

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

    dist = (np.abs(np.subtract(point, endPoints)))
    print("Mean distance between the two matrices: " + str(np.mean(dist)) )

    print("The Variance of the points: " + str(np.std(dist)))
    
    print("Maximum distance between the two matrices: " + str(np.max(dist)))

    print("Minimum distance between the two matrices: " + str(np.min(dist)))

P = calibrateCamera3D(data)

visualiseCameraCalibration3D(data, P)

evaluateCameraCalibration3D(data, P)
