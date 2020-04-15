# 15468498
# Alan Lyne

from sklearn import preprocessing
from sklearn.metrics import mean_squared_error
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from math import sqrt

# Normalise/Standardise the dataset
def stand(df):
    names = df.columns

    # Create the Scaler object
    scaler = preprocessing.StandardScaler()

    # Fit data on the scaler object
    scaled_df = scaler.fit_transform(df)
    scaled_df = pd.DataFrame(scaled_df, columns=names)

    return scaled_df


# Using Guassian Noise for making data
def noise(original, sigma):
    mu = 0
    #sigma = 1
    #variance = original.var()

    noise = np.random.normal(mu, sigma, original.shape)
    noise = original + noise

   # noise = noise * sqrt(variance * k)
    return noise


# Calculate the Euclidean Distance between the original and masked dataset
def euclidean(df, signal):
    return sqrt(sum((df-signal) * (df-signal)))


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
    return np.square(np.subtract(original, masked)).mean()


if __name__ == "__main__":
    # Get dataset
    df = pd.read_csv(r"Advanced Concepts\\Data Privacy\\CASCrefmicrodata.csv")

    # Normalise/Standardise the data
    normData = stand(df)

    # Masking Method (Gaussian Noise)
    noise1 = noise(normData, 0.01) 
    noise2 = noise(normData, 0.1) 
    noise3 = noise(normData, 0.2)
    noise4 = noise(normData, 0.3) 
    noise5 = noise(normData, 0.4)
    noise6 = noise(normData, 0.5)
    noise7 = noise(normData, 0.6)
    noise8 = noise(normData, 0.7) 
    noise9 = noise(normData, 0.8)
    noise10 = noise(normData, 0.9)
    noise11 = noise(normData, 1.0)
    noise12 = noise(normData, 1.5) 
    noise13 = noise(normData, 2.0)


    # Calculate Dislosure Risk
    dbrl1 = dbrl(normData, noise1)
    dbrl2 = dbrl(normData, noise2)
    dbrl3 = dbrl(normData, noise3)
    dbrl4 = dbrl(normData, noise4)
    dbrl5 = dbrl(normData, noise5)
    dbrl6 = dbrl(normData, noise6)
    dbrl7 = dbrl(normData, noise7)
    dbrl8 = dbrl(normData, noise8)
    dbrl9 = dbrl(normData, noise9)
    dbrl10 = dbrl(normData, noise10)
    dbrl11 = dbrl(normData, noise11)
    dbrl12 = dbrl(normData, noise12)
    dbrl13 = dbrl(normData, noise13)


    # Calculate Information Loss
    infoLoss1 = infoLoss(normData, noise1)
    infoLoss2 = infoLoss(normData, noise2)
    infoLoss3 = infoLoss(normData, noise3)
    infoLoss4 = infoLoss(normData, noise4)
    infoLoss5 = infoLoss(normData, noise5)
    infoLoss6 = infoLoss(normData, noise6)
    infoLoss7 = infoLoss(normData, noise7)
    infoLoss8 = infoLoss(normData, noise8)
    infoLoss9 = infoLoss(normData, noise9)
    infoLoss10 = infoLoss(normData, noise10)
    infoLoss11 = infoLoss(normData, noise11)
    infoLoss12 = infoLoss(normData, noise12)
    infoLoss13 = infoLoss(normData, noise13)

    print("Gaussian Noise Method")
    print("Noise: 0.01 - Disclosure Risk:", dbrl1,"% - Information Loss:",infoLoss1,"%")
    print("Noise: 0.1 - Disclosure Risk:", dbrl2,"% - Information Loss:",infoLoss2,"%")
    print("Noise: 0.2 - Disclosure Risk:", dbrl3,"% - Information Loss:",infoLoss3,"%")
    print("Noise: 0.3 - Disclosure Risk:", dbrl4,"% - Information Loss:",infoLoss4,"%")
    print("Noise: 0.4 - Disclosure Risk:", dbrl5,"% - Information Loss:",infoLoss5,"%")
    print("Noise: 0.5 - Disclosure Risk:", dbrl6,"% - Information Loss:",infoLoss6,"%")
    print("Noise: 0.6 - Disclosure Risk:", dbrl7,"% - Information Loss:",infoLoss7,"%")
    print("Noise: 0.7 - Disclosure Risk:", dbrl8,"% - Information Loss:",infoLoss8,"%")
    print("Noise: 0.8 - Disclosure Risk:", dbrl9,"% - Information Loss:",infoLoss9,"%")
    print("Noise: 0.9 - Disclosure Risk:", dbrl10,"% - Information Loss:",infoLoss10,"%")
    print("Noise: 1.0 - Disclosure Risk:", dbrl11,"% - Information Loss:",infoLoss11,"%")
    print("Noise: 1.5 - Disclosure Risk:", dbrl12,"% - Information Loss:",infoLoss12,"%")
    print("Noise: 2.0 - Disclosure Risk:", dbrl13,"% - Information Loss:",infoLoss13,"%")

    plt.scatter([infoLoss1, infoLoss2, infoLoss3, infoLoss4, infoLoss5, infoLoss6, infoLoss7, infoLoss7, infoLoss9, infoLoss10, infoLoss11, infoLoss12, infoLoss13 ],[dbrl1, dbrl2, dbrl3, dbrl4, dbrl5, dbrl6, dbrl7, dbrl8, dbrl9, dbrl10, dbrl11, dbrl12, dbrl13])


    plt.title("Gaussian Noise individual ranking dRisk(k)")
    plt.ylabel("dRisk")
    plt.xlabel("dUtility")
    plt.show()