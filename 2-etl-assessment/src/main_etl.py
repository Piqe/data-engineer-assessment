from extract import extract_master, extract_asset
from transform import clean_and_merge, generate_internal_site_id
from load import load_to_csv
from log import log_invalid_with_suggestion

def main():
    print("Starting ETL process...")

    # Extract
    df_master = extract_master()
    # print("Kolom master:", df_master.columns.tolist())
    # print(df_master.head())
    df_asset = extract_asset()

    # Transform & Merge
    df_valid, df_invalid = clean_and_merge(df_asset, df_master)

    # Generate Internal Site ID
    df_processed = generate_internal_site_id(df_valid)

    # Load
    load_to_csv(df_processed)

    # Log invalid records with suggestion
    if not df_invalid.empty:
        log_invalid_with_suggestion(df_invalid, df_master)
        print(f"{len(df_invalid)} invalid records logged with suggestions.")
    else:
        print("No invalid records.")

    print("ETL process completed successfully!")

if __name__ == "__main__":
    main()
