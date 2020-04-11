# 15468498
# Alan Lyne

from sklearn import preprocessing
import numpy as np
import pandas as pd


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

