# SQL Assessment Project
## Deskripsi Proyek
Proyek ini merupakan SQL Assessment untuk menganalisis data retail, meliputi cabang toko, staf, produk, inventori, dan transaksi penjualan. Tujuan assessment adalah untuk menguji kemampuan menulis query SQL, analisis data, dan interpretasi hasil untuk pengambilan keputusan bisnis.
```
/sql-assessment
│
├─ README.md                # Dokumentasi proyek
├─ queries/                 # Folder berisi query untuk assessment
│   ├─ basic_queries.sql
│   ├─ insert_mock_data.sql
│   └─ intermediate_queries.sql
│
├─ result/
   ├─ output query Analyze staff performance and sales.csv
   ├─ output query Calculate inventory turnover metrics per branch.csv
   ├─ output query Customer Purchase Patterns
   ├─ Data Visualization
---
```
## Task Assessment
1. Calculate Inventory Turnover Metrics per Branch Query untuk menghitung **inventory turnover** per caban
2. Analyze Staff Performance and Sales
3. Customer Purchase Pattern

## Database
Database yang digunakan: **db_retail**

### Tabel Utama

1. **branch_details**  
   Informasi cabang toko:
   - `branch_code` (VARCHAR, PK)  
   - `branch_name` (VARCHAR)  
   - `region_id` (INT)  
   - `operation_start_date` (DATE)  
   - `is_active` (BOOLEAN)  
   - `max_capacity` (INT)  
   - `last_renovation_date` (DATE)  

2. **staff_records**  
   Data staf cabang:
   - `staff_id` (VARCHAR, PK)  
   - `branch_code` (VARCHAR, FK)  
   - `join_date` (DATE)  
   - `role_code` (VARCHAR)  
   - `base_salary` (DECIMAL)  
   - `supervisor_id` (VARCHAR)  
   - `resignation_date` (DATE)  
   - `performance_score` (DECIMAL)  

3. **product_hierarchy**  
   Informasi produk dan kategori:
   - `product_code` (VARCHAR, PK)  
   - `product_name` (VARCHAR)  
   - `category_l1` (VARCHAR)  
   - `category_l2` (VARCHAR)  
   - `category_l3` (VARCHAR)  
   - `unit_cost` (DECIMAL)  
   - `unit_price` (DECIMAL)  
   - `supplier_id` (VARCHAR)  
   - `minimum_stock` (INT)  
   - `is_perishable` (BOOLEAN)  

4. **inventory_movements**  
   Pergerakan inventori:
   - `movement_id` (BIGINT, PK)  
   - `product_code` (VARCHAR, FK)  
   - `branch_code` (VARCHAR, FK)  
   - `transaction_type` (CHAR)  
   - `quantity` (INT)  
   - `transaction_date` (DATE)  
   - `batch_number` (VARCHAR)  
   - `expiry_date` (DATE)  
   - `unit_cost_at_time` (DECIMAL)  

5. **sales_transactions**  
   Data transaksi penjualan:
   - `transaction_id` (VARCHAR, PK)  
   - `branch_code` (VARCHAR, FK)  
   - `transaction_date` (TIMESTAMP)  
   - `staff_id` (VARCHAR, FK)  
   - `payment_method` (VARCHAR)  
   - `total_amount` (DECIMAL)  
   - `discount_amount` (DECIMAL)  
   - `loyalty_points_earned` (INT)  
   - `loyalty_points_redeemed` (INT)  
   - `customer_id` (VARCHAR)  

6. **sales_line_items**  
   Detail item per transaksi:
   - `transaction_id` (VARCHAR, FK)  
   - `line_number` (INT)  
   - `product_code` (VARCHAR, FK)  
   - `quantity` (INT)  
   - `unit_price_at_time` (DECIMAL)  
   - `discount_percentage` (DECIMAL)  
   - `total_line_amount` (DECIMAL)  
   - PRIMARY KEY (`transaction_id`, `line_number`)  

---
# Dasbor Performa Eksekutif
Dokumen ini menjelaskan rancangan dan tujuan dari Dasbor Performa Eksekutif yang dibuat untuk analisis bisnis.

# Tujuan dan Target Audiens
Tujuan utama dari dasbor ini adalah untuk menyajikan informasi paling krusial mengenai kesehatan bisnis dalam format yang ringkas dan mudah dicerna. Dasbor ini dirancang untuk para pengambil keputusan tingkat atas, seperti manajer, direktur, atau C-level, yang memerlukan akses cepat ke data performa tanpa harus menganalisis laporan yang kompleks dan terperinci.

# Komponen Kunci Dasbor
Dasbor ini dibangun dari beberapa komponen visual strategis yang saling melengkapi:

1. Indikator Kinerja Utama (KPIs)
Bagian ini menampilkan metrik paling vital secara sekilas untuk memberikan gambaran instan mengenai kondisi bisnis.

- Total Penjualan
- Jumlah Transaksi
- Nilai Stok Tersisa
- Jumlah Staf
- Jumlah Cabang

2. Analisis Penjualan
- Menunjukkan tren penjualan dari waktu ke waktu.
- Menampilkan Top 5 Cabang dan Top 5 Produk dengan performa terbaik.
3. Monitor Kesehatan Operasional
Komponen ini berfokus pada analisis inventaris dan efisiensi operasional.
- Treemap: Digunakan untuk melihat komposisi stok secara visual, memudahkan identifikasi produk yang dominan.

4. Filter Interaktif
Untuk memungkinkan analisis mandiri oleh pengguna, dasbor dilengkapi dengan slicer.
- Filter berdasarkan Bulan.
- Filter berdasarkan Cabang.

# Nilai untuk Pengambilan Keputusan
Dasbor Performa Eksekutif ini secara langsung mendukung pengambilan keputusan dengan cara:
- Memberikan Visibilitas Cepat
- Menyoroti Anomali
- Memfasilitasi Analisis Mandiri
