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
def noise(original, k):
    mu = 0
    sigma = 1
    variance = original.var()
    print(variance)

    noise = np.random.normal(mu, sigma, original.shape)
    noise = original + noise

    noise = noise * sqrt(variance * k)

    return noise


# Calculate the Disclosure Risk (Euclidean Distance) between the original and masked dataset
def euclidean(df, signal):
    #euclideanDist = np.linalg.norm(df-signal)
    #return euclideanDist
    #print("The calculated Disclosure Risk is: ", euclideanDist)
    #return pd.Series(np.linalg.norm(df.to_numpy()-signal.to_numpy(), axis=0), index=df.columns)
    return sqrt(sum((df-signal) * (df-signal)))


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
        #print(i)
    print(reindentified)
    return reindentified


# Calculate the information lossed between the masked and prginal set using mean square error
def infoLoss(original, masked):
    #informationLoss = (mean_squared_error(df, signal))
    #print("The calculated information loss is: ", informationLoss)
    #return pd.Series(np.square(np.subtract(df, signal)).mean())
    original = original.to_numpy()
    masked = masked.to_numpy()
    return np.square(np.subtract(original, masked)).mean()


if __name__ == "__main__":
    # Get dataset
    df = pd.read_csv(r"Advanced Concepts\\Data Privacy\\CASCrefmicrodata.csv")
    #print(df)

    # Normalise/Standardise the data
    normData = stand(df)
    #print(normData)

    # Masking Method (Gaussian Noise)
    noise1 = noise(normData, 0.01) 
    noise2 = noise(normData, 0.1) 
    noise3 = noise(normData, 0.2) 
    noise4 = noise(normData, 0.4) 
    noise5 = noise(normData, 0.8) 
    noise6 = noise(normData, 2)
    #print(noise1, "\n", noise2, "\n", noise3, "\n", noise4, "\n", noise5, "\n", noise6)

    # dbrl1 = dbrl(normData, noise1)
    # dbrl2 = dbrl(normData, noise2)
    # dbrl3 = dbrl(normData, noise3)
    # dbrl4 = dbrl(normData, noise4)
    # dbrl5 = dbrl(normData, noise5)
    # dbrl6 = dbrl(normData, noise6)

    # #print("Euclidean distance between two said series: ", euclideanDist)

    # infoLoss1 = infoLoss(normData, noise1)
    # infoLoss2 = infoLoss(normData, noise2)
    # infoLoss3 = infoLoss(normData, noise3)
    # infoLoss4 = infoLoss(normData, noise4)
    # infoLoss5 = infoLoss(normData, noise5)
    # infoLoss6 = infoLoss(normData, noise6)

    # print("Gaussian Noise")
    # print("Noise: 0.01 - Disclosure Risk:", dbrl1 ,"- Information Loss:",infoLoss1)
    # print("Noise: 0.1 - Disclosure Risk:", dbrl2 ,"- Information Loss:",infoLoss2)
    # print("Noise: 0.2 - Disclosure Risk:", dbrl3 ,"- Information Loss:",infoLoss3)
    # print("Noise: 0.4 - Disclosure Risk:", dbrl4 ,"- Information Loss:",infoLoss4)
    # print("Noise: 0.8 - Disclosure Risk:", dbrl5 ,"- Information Loss:",infoLoss5)
    # print("Noise: 2 - Disclosure Risk:", dbrl6 ,"- Information Loss:",infoLoss6)

    #informationLoss.plot(style = '.')
    #euclideanDist.plot(style = '.')

    #plt.plot(informationLoss, euclideanDist, 'o', color='black')
    #plt.scatter(euclideanDist)

    plt.title("Microaggregation individual ranking dRisk(k)")
    plt.xlabel("dRisk")
    plt.ylabel("dUtility")
    #plt.show()