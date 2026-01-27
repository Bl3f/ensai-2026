# /// script
# dependencies = [
#   "pandas",
#   "pyarrow",
#   "pandas-gbq",
#   "google-cloud-storage",
# ]
# ///

import pandas as pd
import pandas_gbq
from google.cloud import storage

# Create a Parquet file
df = pd.DataFrame(
    {
        "name": ["apple", "banana", "cherry"],
        "price": [1.0, 2.0, 3.0],
    },
)

df.to_parquet("exercice_3.parquet")

# Copy in BigQuery
pandas_gbq.to_gbq(
    df,
    "christophe.fruits_2",
    project_id="ensai-2026",
    if_exists="replace",
)

client = storage.Client(project="ensai-2026")
bucket = client.bucket("christophe-2026")
blob = bucket.blob("exercice_3.parquet")
blob.upload_from_filename("exercice_3.parquet")
