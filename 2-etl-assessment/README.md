# Dokumentasi Proyek ETL

## Ringkasan
Pipeline ETL ini mengekstrak data asset, melakukan transformasi agar sesuai dengan data master kota, dan menghasilkan **Internal Site ID** yang terstandarisasi untuk penggunaan selanjutnya. Pipeline ini menangani format yang tidak konsisten, nilai yang hilang, serta validasi numerik, sekaligus mencatat baris data yang tidak valid.

## Struktur Proyek
```
data/
├── raw/ # File input mentah
├── processed/ # Output data valid yang sudah diproses
src/
├── extract.py # Script untuk ekstraksi data
├── transform.py # Transformasi dan validasi data
├── load.py # Load data yang sudah diproses ke CSV/PostgreSQL
├── log.py # Logging data tidak valid
├── main_etl.py # Orkestrasi ETL utama
logs/
├── invalid_records/ # CSV log untuk data tidak valid
```

## Sumber Data

1. **Master City Data (`City Indonesia.xlsx`)**
   - Kolom: `City`, `CityCode`, `Province`, `Region`, `RegionalCode`
   - Berisi kode resmi kota dan regional serta nama yang baku.

2. **Data Asset Raw (`Assessment Data Asset Dummy.xlsx`)**
   - Kolom: `Funcloc`, `Alamat1`, `Alamat2`, `Alamat3`, `Alamat4`, `SiteName`
   - `Funcloc`: Kode lokasi fungsional internal
   - `Alamat4`: Kabupaten/Kota yang akan dicocokkan dengan master

---

## Proses ETL

### 1. Extract
- Membaca file CSV/Excel dari direktori `data/raw/`.
- Mengekstrak dataset **master** dan **asset**.

### 2. Transform

**2.1 Validasi Data**
- Kolom wajib (`Funcloc`, `Alamat4`) tidak boleh kosong.
- Kolom numerik (`RegionalCode`) divalidasi.
- Baris yang tidak valid dicatat untuk log.

**2.2 Normalisasi**
- Ubah teks menjadi huruf kecil dan hilangkan spasi berlebih.
- Hapus prefix: `"Kabupaten"`, `"Kota"`, `"Kota Adm."`
- Hapus suffix: `", Kota"` atau `", Kabupaten"`
- Ubah spasi ganda menjadi satu spasi agar matching konsisten.

**2.3 Integritas Referensial**
- Merge `df_asset` dengan `df_master` menggunakan nama kota yang sudah dinormalisasi (`Alamat4_clean` ↔ `City_clean`).
- Baris yang tidak cocok dengan master dicatat sebagai invalid.

**2.4 Pembuatan Internal Site ID**
- Format: `AAA-BB-CCC`
  - `AAA` → `CityCode`
  - `BB` → `RegionalCode` (2 digit)
  - `CCC` → urutan per kota
- Kode `Funcloc` dinormalisasi: huruf besar, di-strip, karakter non-alfanumerik dihapus.

---

### 3. Load
- Data valid disimpan ke `data/processed/processed_asset.csv`.
- Baris tidak valid disimpan ke `logs/invalid_records_<timestamp>.csv` untuk audit.

---

## Penanganan Error
- Kolom wajib kosong → dicatat sebagai "Required field kosong"
- `RegionalCode` bukan numerik → dicatat sebagai "Kolom RegionalCode tidak numeric"
- Kota tidak ada di master → dicatat sebagai "Alamat4 tidak ada di master"
- Semua baris invalid dicatat untuk review.

---
## Cara Menjalankan
Letakkan file data mentah di data/raw/.
Jalankan ETL:
   python main_etl.py

