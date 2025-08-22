import os

PROCESSED_PATH = os.path.join(os.path.dirname(__file__), '../data/processed')

def load_to_csv(df, filename='processed_asset.csv'):
    file_path = os.path.join(PROCESSED_PATH, filename)
    df.to_csv(file_path, index=False)
