# 15468498
# Alan Lyne

from sklearn import preprocessing
from sklearn.metrics import mean_squared_error
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from math import sqrt
import random

# Normalise/Standardise the dataset
def stand(original):
    names = original.columns
    # Create the Scaler object
    scaler = preprocessing.StandardScaler()
    # Fit data on the scaler object
    scaled_original = scaler.fit_transform(original)
    scaled_original = pd.DataFrame(scaled_original, columns=names)

    return scaled_original


# Using Guassian Noise for making data
def noise(original, sigma):
    mu = 0
    noise = np.random.normal(mu, sigma, original.shape)
    noise = original + noise

    return noise


# Calculate the Euclidean Distance between the original and masked dataset
def euclidean(original, signal):
    return sqrt(sum((original-signal) * (original-signal)))


# Calculate the Disclosure Based Record Linkage between the original and masked dataset
def dbrl(original, masked):
    original = original.to_numpy()
    masked = masked.to_numpy()

    i = 1
    reindentified = 0
    while i < len(original):
        j = 1
        minDist = 100000
        minRecord = -1
        while j < len(masked):
            if euclidean(original[i,], masked[j,]) < minDist:
                minDist = euclidean(original[i,], masked[j,])
                minRecord = j
            j += 1
        if minRecord == i:
            reindentified += 1
        i += 1
    return reindentified / 1080 * 100


# Calculate the information lossed between the masked and prginal set using mean square error
def infoLoss(original, masked):
    original = original.to_numpy()
    masked = masked.to_numpy()
    return 100-(np.square(np.subtract(original, masked)).mean())


if __name__ == "__main__":
    # Get dataset
    original = pd.read_csv(r"Advanced Concepts\Data Privacy\CASCrefmicrodata.csv")

    # Normalise/Standardise the data
    normData = stand(original)

    noiseData=[]
    infoLossD=[]
    dbrlD=[]
    a = 0
    for i in np.arange(0.1, 2.1, 0.1):
        # Create our new dataset
        noiseData.append(noise(normData, i))
        # Calculate the Disclosure Based Record Linkage 
        dbrlD.append(dbrl(normData, noiseData[a]))
        # Calculate the Inforamtion Loss
        infoLossD.append(infoLoss(normData, noiseData[a]))

        # Print out our results
        print("Noise: ", round(i, 1), " - Disclosure Risk:", dbrlD[a],"% - Information Loss:",infoLossD[a],"%")

        # Plot our data points
        plt.scatter([infoLossD[a]],[dbrlD[a]])
        a = a + 1

    plt.title("Gaussian Noise individual ranking dRisk(k)")
    plt.ylabel("dRisk")
    plt.xlabel("dUtility")
    plt.show()