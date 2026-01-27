# /// script
# dependencies = [
#   "pandas",
#   "pyarrow",
#   "google-cloud-storage",
#   "google-cloud-bigquery",
# ]
# ///

from google.cloud import storage
from google.cloud import bigquery

client = storage.Client(project="ensai-2026")
bucket = client.bucket("christophe-2026")
blob = bucket.blob("yellow_tripdata_2025-01.parquet")
blob.upload_from_filename("yellow_tripdata_2025-01.parquet")

client = bigquery.Client(project="ensai-2026")
sql = """
CREATE OR REPLACE EXTERNAL TABLE christophe.taxi
OPTIONS (
	format = 'PARQUET',
	uris = ['gs://christophe-2026/yellow_tripdata_2025-01.parquet']
);
"""

rows = client.query_and_wait(sql)
