# Data Engineer Technical Assessment

## Overview
**Nama:** Thaufiq Saputra Zulty  
**Posisi:** Data Engineer  

Assessment ini mencakup tiga bagian utama: SQL, ETL, dan Data Visualization menggunakan dataset koperasi dan asset Indonesia.

## Project Structure
```
data-engineer-assessment/
├── data/
│   ├── raw/
│   │   ├── Data Koperasi Indonesia.xlsx
│   │   ├── Assessment Data Asset Dummy.xlsx
│   │   ├── City Indonesia.xlsx
│   │   └── Data Raw Funcloc 1.xlsx
│   └── processed/
├── etl/
│   ├── extract.py
│   ├── transform.py
│   ├── load.py
│   └── asset_etl.py
├── sql/
│   ├── create_tables.sql
│   ├── data_analysis.sql
│   └── queries/
├── dashboard/
│   └── Koperasi_Dashboard.pbix
├── logs/
└── README.md
```

## Tools 
- **Python 3.11** – ETL scripting, data transformation, dan validation
- **PostgreSQL 15** – Database untuk staging dan data storage
- **Power BI Desktop 2023** – Data visualization dan dashboard interaktif
- **VSCode 1.95** – Development environment

### Python Libraries
```python﻿asttokens==3.0.0
colorama==0.4.6
comm==0.2.3
debugpy==1.8.16
decorator==5.2.1
et_xmlfile==2.0.0
executing==2.2.0
ipykernel==6.30.1
ipython==9.4.0
ipython_pygments_lexers==1.1.1
jedi==0.19.2
jupyter_client==8.6.3
jupyter_core==5.8.1
matplotlib-inline==0.1.7
nest-asyncio==1.6.0
numpy==2.3.2
openpyxl==3.1.5
packaging==25.0
pandas==2.3.1
parso==0.8.4
platformdirs==4.3.8
prompt_toolkit==3.0.51
psutil==7.0.0
pure_eval==0.2.3
Pygments==2.19.2
python-dateutil==2.9.0.post0
pytz==2025.2
pywin32==311
pyzmq==27.0.2
RapidFuzz==3.13.0
six==1.17.0
stack-data==0.6.3
tornado==6.5.2
traitlets==5.14.3
tzdata==2025.2
wcwidth==0.2.13
```

## Setup Instructions

# Create virtual environment
python -m venv venv
venv\Scripts\activate    

# Install dependencies
pip install -r requirements.txt
```
### 2. Database Setup
```bash
# Connect to PostgreSQL
psql -U postgres -h localhost

# Create database
CREATE DATABASE retail_db;

# Run table creation scripts
\c retail_db
\i sql/create_tables.sql
```

### 3. ETL Pipeline Execution
```bash
python src/extract.py
python src/transform.py
python src/load.py

python src/main_etl.py
```

### 4. Dashboard Setup
1. Buka Power BI Desktop
2. Get Data → Excel → Pilih file data koperasi
3. Import file `dashboard/Koperasi_Dashboard.pbix`
4. Refresh data connections

## Time Spent

| Section | Time Spent |
|---------|------------|
| Data Understanding  | 2 jam |
| SQL Assessment | 4 jam |
| ETL Assessment | 8 jam |
| Data Visualization Assessment | 3 jam |
| Documentation  | 1 jam |
| **Total** | **18 jam** |
