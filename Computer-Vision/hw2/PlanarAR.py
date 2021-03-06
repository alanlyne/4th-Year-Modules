""" Example of using OpenCV API to detect and draw checkerboard pattern"""
import numpy as np
import cv2

# These two imports are for the signal handler
import signal
import sys

from itertools import product

#### Some helper functions #####
def reallyDestroyWindow(windowName) :
    ''' Bug in OpenCV's destroyWindow method, so... '''
    ''' This fix is from http://stackoverflow.com/questions/6116564/ '''
    cv2.destroyWindow(windowName)
    for i in range (1,5):
        cv2.waitKey(1)

def shutdown():
        ''' Call to shutdown camera and windows '''
        global cap
        cap.release()
        reallyDestroyWindow('img')

def signal_handler(signal, frame):
        ''' Signal handler for handling ctrl-c '''
        shutdown()
        sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)


############## calibration of plane to plane 3x3 projection matrix

def compute_homography(fp,tp):
    ''' Compute homography that takes fp to tp.
    fp and tp should be (N,3) '''

    if fp.shape != tp.shape:
        raise RuntimeError('number of points do not match')

    # create matrix for linear method, 2 rows for each correspondence pair
    num_corners = fp.shape[0]

    # construct constraint matrix
    A = np.zeros((num_corners*2,9));
    A[0::2,0:3] = fp
    A[1::2,3:6] = fp
    A[0::2,6:9] = fp * -np.repeat(np.expand_dims(tp[:,0],axis=1),3,axis=1)
    A[1::2,6:9] = fp * -np.repeat(np.expand_dims(tp[:,1],axis=1),3,axis=1)

    # solve using *naive* eigenvalue approach
    D,V = np.linalg.eig(A.transpose().dot(A))

    H = V[:,np.argmin(D)].reshape((3,3))

    # normalise and return
    return H

# termination criteria
criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 30, 0.001)

# YOU SHOULD SET THESE VALUES TO REFLECT THE SETUP
# OF YOUR CHECKERBOARD
WIDTH = 9
HEIGHT = 6

# prepare object points, like (0,0,0), (1,0,0), (2,0,0) ....,(6,5,0)
objp = np.zeros((WIDTH*HEIGHT,3), np.float32)
objp[:,:2] = np.mgrid[0:HEIGHT,0:WIDTH].T.reshape(-1,2)

cap = cv2.VideoCapture(0)

## Step 0: Load the image you wish to overlay
image = cv2.imread(r'C:\Users\Alan\Documents\Programming\cv.png')

x = np.linspace(640,0,9)
y = np.linspace(0,480,6)
tp = np.c_[np.asarray(list(product(x, y))),np.ones(54)]

while True:
    #capture a frame
    ret, img = cap.read()

    ## IF YOU WISH TO UNDISTORT YOUR IMAGE YOU SHOULD DO IT HERE

    # Our operations on the frame come here
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Find the chess board corners
    ret, corners = cv2.findChessboardCorners(gray, (HEIGHT,WIDTH),None)
    #print corners
    #print corners.shape[0]

    # If found, add object points, image points (after refining them)
    if ret == True:
        cv2.cornerSubPix(gray,corners,(11,11),(-1,-1),criteria)
        #cv2.drawChessboardCorners(img, (HEIGHT,WIDTH), corners,ret)
        ## Step 1a: Compute fp -- an Nx3 array of the 2D homogeneous coordinates of the
        ## detected checkerboard corners
        corners = np.asmatrix(corners)
        fp = np.asarray(np.c_[corners,np.ones(corners.shape[0])])

        ## Step 1b: Compute tp -- an Nx3 array of the 2D homogeneous coordinates of the
        ## samples of the image coordinates
        ## Note: this could be done outside of the loop either!

        tp = np.asarray(tp)

        ## Step 2: Compute the homography from tp to fp
        Homography = compute_homography(tp,fp)

        ## Step 3: Compute warped mask image
        tp = np.asmatrix(tp)

        image[:,2] = 0
        Homography = np.asarray(Homography)
        wpImage = cv2.warpPerspective(image, Homography, dsize=(640,480))

        ## Step 4: Compute warped overlay image
        rows, columns = wpImage.shape[0], wpImage.shape[1]
        imageR = img[0:rows,0:columns]
        #convert it to gray scale
        graysrc = cv2.cvtColor(wpImage,cv2.COLOR_BGR2GRAY)
        #creating the mask, and the it's inverse
        ret,mask = cv2.threshold(graysrc, 10, 255 , cv2.THRESH_BINARY)
        mask_inv = cv2.bitwise_not(mask)
        #black out the area in imageR, this is where the imposed image would go
        image1_bg  = cv2.bitwise_and(imageR, imageR, mask = mask_inv)
        #take only the region of our image
        image2_fg = cv2.bitwise_and(wpImage, wpImage, mask=mask)
        #put the two together and the modify the main image
        distance = cv2.add(image1_bg,image2_fg)
        img[0:rows,0:columns] = distance
    
        ## Step 5: Compute final image by combining the warped frame with the captured frame

    cv2.imshow('og',img)

    if cv2.waitKey(1) & 0xFF == ord('q'):
       break

# release everything
shutdown()