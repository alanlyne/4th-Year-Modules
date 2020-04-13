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
def noise(df):
    mu = 0
    sigma = 0.1

    # Creating noise the same size as the dataset
    noise = np.random.normal(mu, sigma, df.shape)
    signal = df + noise

    return signal


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
            #print(j)
        if minRecord == i:
            reindentified +=1
        i += 1
        print(i)
    return reindentified


# Calculate the information lossed between the masked and prginal set using mean square error
def infoLoss(df, signal):
    #informationLoss = (mean_squared_error(df, signal))
    #print("The calculated information loss is: ", informationLoss)
    return pd.Series(np.square(np.subtract(df, signal)).mean())


if __name__ == "__main__":
    # Get dataset
    df = pd.read_csv(r"Advanced Concepts\\Data Privacy\\CASCrefmicrodata.csv")
    print(df)

    # Normalise/Standardise the data
    scaled_df = stand(df)
    print(scaled_df)

    # Masking Method (Gaussian Noise)
    signal = noise(scaled_df)
    print(signal)

    euclideanDist = dbrl(df, signal)
    print("Euclidean distance between two said series: ", euclideanDist)

    informationLoss = infoLoss(df, signal)
    print("The calculated information loss is: ", informationLoss)
 

    #informationLoss.plot(style = '.')
    #euclideanDist.plot(style = '.')

    plt.plot(informationLoss, euclideanDist, 'o', color='black')
    #plt.scatter(euclideanDist)

    plt.title("Microaggregation individual ranking dRisk(k)")
    plt.xlabel("dRisk")
    plt.ylabel("dUtility")
    plt.show()