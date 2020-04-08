from sklearn import preprocessing
import numpy as np
import pandas as pd
import csv

  
def stand(df):
    names = df.columns

    # Create the Scaler object
    scaler = preprocessing.StandardScaler()

    # Fit data on the scaler object
    scaled_df = scaler.fit_transform(df)
    scaled_df = pd.DataFrame(scaled_df, columns=names)

    #print(scaled_df)

    return scaled_df

def noise(df):
    df = pd.DataFrame([[1,2],[3,4]], columns=list('AB'), dtype=float)
    mu = 0
    sigma = 0.1
    noise = np.random.normal(mu, sigma, [2,2])
    signal = df + noise

    return signal

if __name__ == "__main__":
    # Get dataset
    df = pd.read_csv("Advanced Concepts\\Data Privacy\\CASCrefmicrodata.csv") 
    scaled_df = stand(df)
    signal = noise(df)

    print(scaled_df)
    print(signal) #NEEDS WORK
