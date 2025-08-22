import os
from rapidfuzz import process

LOG_PATH = os.path.join(os.path.dirname(__file__), 'logs')
os.makedirs(LOG_PATH, exist_ok=True)

def suggest_city(asset_name, master_list, limit=1):
    # Cari kota paling mirip dengan similarity >= 80
    match = process.extractOne(asset_name, master_list, score_cutoff=80)
    if match:
        return match[0]  # nama kota master terdekat
    return None

def log_invalid_with_suggestion(df_invalid, df_master, filename="invalid_records.csv"):
    if df_invalid.empty:
        print("[LOG] Tidak ada record invalid yang disimpan.")
        return

    master_cities = df_master['City_clean'].tolist()

    # Tambahkan kolom suggestion berdasarkan kemiripan string
    df_invalid['suggestion'] = df_invalid['Alamat4_clean'].apply(
        lambda x: suggest_city(x, master_cities)
    )

    file_path = os.path.join(LOG_PATH, filename)
    df_invalid.to_csv(file_path, index=False)
    print(f"[LOG] Invalid records tersimpan di {file_path} (dengan suggestion)")
