import pandas as pd
import os

RAW_PATH = os.path.join(os.path.dirname(__file__), '../data/raw')

def extract_master():
    file_path = os.path.join(RAW_PATH, 'City Indonesia.xlsx')
    df_master = pd.read_excel(file_path)
    return df_master

def extract_asset():
    file_path = os.path.join(RAW_PATH, 'Assessment Data Asset Dummy.xlsx')
    df_asset = pd.read_excel(file_path)
    return df_asset
