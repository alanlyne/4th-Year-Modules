# 15468498
# Alan Lyne

from sklearn import preprocessing
from sklearn.metrics import mean_squared_error
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


def stand(df):
    names = df.columns

    # Create the Scaler object
    scaler = preprocessing.StandardScaler()

    # Fit data on the scaler object
    scaled_df = scaler.fit_transform(df)
    scaled_df = pd.DataFrame(scaled_df, columns=names)

    # print(scaled_df)

    return scaled_df


def noise(df):
    mu = 0
    sigma = 0.1

    # Creating noise the same size as the dataset
    noise = np.random.normal(mu, sigma, df.shape)
    signal = df + noise

    return signal


# Calculate the Eucliane Distance between the original and masked dataset
def euclidean(df, signal):
    return (np.linalg.norm(df-signal))


# Calculate the information lossed between the masked and prginal set using mean square error
def infoLoss(df, signal):
    return np.sqrt(mean_squared_error(df, signal))


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

    euclideanDist = euclidean(df, signal)
    print("Euclidean distance between two said series: ", euclideanDist)

    informationLoss = infoLoss(df, signal)
    print("The calculated information loss is: ", informationLoss)

    # fig=plt.figure()
    # ax=fig.add_axes([0,0,1,1])
    # ax.scatter(10,euclideanDist, color = 'r')
    # ax.scatter(10,informationLoss, color = 'b')
    # plt.show()


