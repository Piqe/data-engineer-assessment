import pandas as pd
import re

ALIASES = {
    "Pangkajene": "Pangkajene Kepulauan",
    "Oku Selatan": "Ogan Komering Ulu Selatan",
    "Oku Timur": "Ogan Komering Ulu Timur",
    "Solo": "Surakarta"
}

def normalize_text_for_merge(s):
    s = str(s).lower().strip()

    # Expand singkatan
    s = re.sub(r'^kab(\.| )', 'kabupaten ', s)
    s = re.sub(r'\(.*?\)', '', s)   
    s = re.sub(r'^(kabupaten|kota( adm\.?)?)\s+', '', s)
    s = re.sub(r',?\s*(kota|kabupaten|adm\.?)$', '', s)

    # Standarisasi spasi & tanda hubung
    s = re.sub(r'\s+', ' ', s)
    s = re.sub(r'\buna una\b', 'una-una', s)
    s = re.sub(r'\boku\b', 'ogan komering ulu', s)

    s = s.title().strip()

    # Alias substitution
    if s in ALIASES:
        s = ALIASES[s]

    # Khusus Jakarta
    jakarta_districts = ["Timur", "Barat", "Utara", "Selatan", "Pusat"]
    for d in jakarta_districts:
        if s == f"Jakarta {d}":
            s = f"Kota Adm. Jakarta {d}"
            break

    return s

def normalize_for_merge(df_asset):
    df_asset['Alamat4_clean'] = df_asset['Alamat4'].apply(normalize_text_for_merge)
    # print("[DEBUG] normalize_for_merge hasil:")
    # print(df_asset[['Alamat4','Alamat4_clean']].head(10))
    return df_asset

def normalize_master(df_master):
    df_master['City_clean'] = df_master['City'].apply(normalize_text_for_merge)
    # print("[DEBUG] normalize_master hasil:")
    # print(df_master[['City','City_clean']].head(10))
    return df_master

# 1. DATA VALIDATION

def validate_required_fields(df_asset):
    required = ['Funcloc', 'Alamat4']
    missing = df_asset[required].isnull() | (df_asset[required] == '')
    invalid_rows = df_asset[missing.any(axis=1)].copy()
    if not invalid_rows.empty:
        invalid_rows['error_message'] = 'Required field kosong'
    valid_rows = df_asset[~missing.any(axis=1)].copy()
    return valid_rows, invalid_rows

def validate_numeric_columns(df, numeric_cols):
    invalid_rows = pd.DataFrame()
    for col in numeric_cols:
        if col in df.columns:
            mask = ~df[col].apply(lambda x: str(x).isdigit() if pd.notna(x) else False)
            temp_invalid = df[mask].copy()
            if not temp_invalid.empty:
                temp_invalid['error_message'] = f'Kolom {col} tidak numeric'
                invalid_rows = pd.concat([invalid_rows, temp_invalid], ignore_index=True)
    valid_rows = df.drop(index=invalid_rows.index)
    return valid_rows, invalid_rows

# 2. CLEANING & MERGE

def clean_and_merge(df_asset, df_master):
    # # 0. Map Jakarta terlebih dahulu
    # df_asset = map_jakarta_asset(df_asset)

    # 1. Required fields
    df_asset, df_invalid_req = validate_required_fields(df_asset)

    # 2. Numeric validation
    numeric_cols = ['RegionalCode']
    df_asset, df_invalid_num = validate_numeric_columns(df_asset, numeric_cols)

    # 3. Normalisasi
    df_asset = normalize_for_merge(df_asset)
    df_master = normalize_master(df_master)

    # 4. Merge
    df_merged = df_asset.merge(
        df_master,
        left_on='Alamat4_clean',
        right_on='City_clean',
        how='left',
        suffixes=('', '_master')
    )

    # Data valid: match master
    df_valid = df_merged[df_merged['CityCode'].notna()].copy()
    df_valid['Alamat4'] = df_valid['City']  # gunakan nama master

    # Data invalid: required + numeric + tidak match master
    df_invalid_master = df_merged[df_merged['CityCode'].isna()].copy()
    if not df_invalid_master.empty:
        df_invalid_master['error_message'] = 'Alamat4 tidak ada di master'

    df_invalid = pd.concat([df_invalid_req, df_invalid_num, df_invalid_master], ignore_index=True)

    return df_valid, df_invalid

# 3. DATA TRANSFORMATION

def normalize_funcloc(df):
    df['Funcloc'] = df['Funcloc'].astype(str).str.upper().str.strip()
    df['Funcloc'] = df['Funcloc'].str.replace(r'[^A-Z0-9\-_]', '', regex=True)
    return df

def generate_internal_site_id(df_valid):
    df_valid = normalize_funcloc(df_valid)
    df_valid = df_valid.sort_values(['CityCode','Funcloc']).reset_index(drop=True)

    # Generate CCC per CityCode
    df_valid['CCC'] = df_valid.groupby('CityCode').cumcount() + 1
    df_valid['CCC'] = df_valid['CCC'].apply(lambda x: str(x).zfill(3))

    # RegionalCode 2 digit
    df_valid['BB'] = df_valid['RegionalCode'].astype(int).apply(lambda x: str(x).zfill(2))

    # Internal Site ID = AAA-BB-CCC
    df_valid['Internal Site ID'] = df_valid['CityCode'].astype(str) + '-' + df_valid['BB'] + '-' + df_valid['CCC']

    return df_valid[['Internal Site ID','Alamat4','Funcloc']]

# 4. LOGGING

def log_invalid_records(df_invalid, filepath='logs/invalid_records.csv'):
    if not df_invalid.empty:
        df_invalid.to_csv(filepath, index=False)
