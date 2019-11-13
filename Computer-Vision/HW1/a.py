import numpy as np
np.set_printoptions(threshold=np.inf, suppress=True)
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d

# Load the data file.
data = np.loadtxt('data.txt')

"""
Global variables that we'll use to evaluate the re-projection vs.
the original 2D image points.
"""
final_points = None
two_points = None

def calibrateCamera3D(data):
   two = data[::,3:5] # 2D points of the data
   three = data[::,0:3] # 3D points of the data

   A = np.zeros((len(data) * 2, 12))

   X_list = []
   Y_list = []

   for i in range(len(data)):
      # Get each 3D X,Y,Z value
      three_x = three[i,0]
      three_y = three[i,1]
      three_z = three[i,2]

      # Get each 2D x,y value
      two_x = two[i,0]
      two_y = two[i,1]


      X = three_x, three_y, three_z, 1, 0, 0, 0, 0, -two_x*three_x, -two_x*three_y, -two_x*three_z, -two_x*1

      Y = 0, 0, 0, 0, three_x, three_y, three_z, 1, -two_y*three_x, -two_y*three_y, -two_y*three_z, -two_y*1

      X_list.append(list(X))
      Y_list.append(list(Y)) # below puts these two into smae list


   a = 0
   for j in range(0, 982, 2):
      A[j] = X_list[a]
      A[j+1] = Y_list[a]
      a += 1

   # Find and compute the eigenvalues and eigen vectors of A'A,
   # then find the index of the minimum eigenvalue.
   D,V = np.linalg.eig(A.transpose().dot(A))
   est = V[:,np.argmin(D)]

   # Build the 3x4 camera matrix and inserting the 12 eigenvalues
   # into the matrix in groups of 4
   P = np.zeros((3,4))
   P[0:] = est[0:4]
   P[1:] = est[4:8]
   P[2:] = est[8:12]
   # print(P, type(P))
   return P

def visualiseCameraCalibration3D(data, P):
   global final_points
   global two_points

   three_x = data[:,0]
   three_y = data[:,1]
   three_z = data[:,2]

   two_x = data[:,3]
   two_y = data[:,4]
   print(three_x)
   quit()

   # Convert the 3d points in the data into homogenous coordinates [X,Y,Z,1].
   threepoints = np.ones((491, 4))
   for i in range(len(data)):
      threepoints[i,0] = three_x[i]
      threepoints[i,1] = three_y[i]
      threepoints[i,2] = three_z[i]

   # Convert the 2d points in the data into homogenous coordinates [x,y,1].
   two_points = np.ones((491, 3))
   for i in range(len(data)):
      two_points[i,0] = two_x[i]
      two_points[i,1] = two_y[i]

   """
   Get the re-projection matrix by getting the dot product of the Camera
   matrix, P, and the transpose of the 3D points, then transposing the
   result.
   """
   threepoints = P.dot(threepoints.transpose())
   final_points = threepoints.transpose()

   final_points[:,0] = final_points[:,0] / final_points[:,2] # X = X/Z
   final_points[:,1] = final_points[:,1] / final_points[:,2] # Y = Y/Z

   # Plot the re-projected 2D points.
   fig = plt.figure()
   ax = fig.gca()
   ax.plot(final_points[:,0], final_points[:,1], 'b.')
   # The reprojection againest the old 2D points.
   ax.plot(data[:,3], data[:,4],'r.')
   plt.show()


def evaluateCameraCalibration3D(data, P):
   global final_points
   global two_points

   # Distance (difference) between each point
   dist = np.subtract(two_points, final_points)
   print("Average distance between the two matrices: " + str(np.mean(dist)))
   # Variance
   print("Standard deviation/variance of measured 2D points: " + str(np.std(two_points)))
   print("Standard deviation/variance of re-projected 2D points: " + str(np.std(final_points)))
   # Maximum distance
   print("Maximum distance between the two matrices: " + str(np.abs(np.max(dist))))
   # Minimum distance
   print("Minimum distance between the two matrices: " + str(np.abs(np.min(dist))))

# Assign camera matrix P to the output of the camera calibration function.
P = calibrateCamera3D(data)
# Plot the original data on a graph (in red) vs the re-projected points
# (in blue).
visualiseCameraCalibration3D(data, P)
# Mean, variance, maximum, and minimum distances between the two matrices.
evaluateCameraCalibration3D(data, P)

'''Visualises the data file for cs410 camera calibration assignment
To run: %run LoadCalibData.py
'''
# import numpy as np
# import matplotlib.pyplot as plt
# from mpl_toolkits.mplot3d import axes3d
# # from numpy import li as ls
#
# #data = np.loadtxt('X:/4thYear/4th-Year-Modules/Computer-Vision/HW1/data.txt')
#
# #fig = plt.figure()
# #ax = fig.gca(projection="3d")
# #ax.plot(data[:,0], data[:,1], data[:,2],'k.')
#
# #fig = plt.figure()
# #ax = fig.gca()
# #ax.plot(data[:,3], data[:,4],'r.')
#
# #plt.show()

# def linefit():
#     # Paramneters for the line
#     lineparams = np.array([3, 2, 8])
#     # Create an array of 11 equally sspaced values from 0 to 1
#     # These will be our x values from which we will compute
#     xpts = np.linspace(0, 10, 20)
#     # Compute the corresponding ground truth y values i.e. ....
#     # print(-(lineparams[2] + lineparams[0]*xpts))
#     # print(lineparams)
#     # quit()
#     ypts = (-(lineparams[2] + lineparams[0]*xpts) / lineparams[1])
#
#     # Add noise to the ground truth values
#     yptsn = ypts + np.random.normal(0,1,np.size(ypts))
#
#     # Create the A matrix for the system
#     A = np.zeros((np.size(yptsn),3))
#     print(A)
#     quit()
#     A[0:,0] = xpts.transpose()
#     A[0:,1] = yptsn.transpose()
#     A[0:,2] = 1
#
#     print(A)
#     print()
#     print()
#
#     print(np.linalg.eig(A.transpose().dot(A)))
#     print()
#     print()
#     # Compute the eigenvalues and eigen vectors of A'A
#     # The eigne vecotrs are not necessaraly in order...
#     # We will need to use argmin below to find the index of the...
#     # eigenvalue
#     D,V = np.linalg.eig(A.transpose().dot(A))
#     print(D)
#     print()
#     print()
#     print(V)
#     # print(A)
#     quit()
#
#     # plot the noisey values in green
#     # plt.ion() # set interactive plot
#     # plt.cla()
#     # plt.show()
#     plt.plot(xpts, yptsn, 'g*')
#
#     # extract the stimated line parameters as the..
#     # to the smallest eigenvalue. In this case the...
#     #vector of V indexed using the index of the ...
#     estlp = V[:,np.argmin(D)]
#
#     # Now compute the estimated y values for each...
#     # the estimated line parameters and plot the ...
#     ypts_est = (-(estlp[2] + estlp[0]*xpts) / estlp[1])
#     plt.plot(xpts, ypts_est, '-r.')
#     # plt.ion()  # set interactive plot
#     # plt.cla()
#     plt.show()
#
#
# linefit()