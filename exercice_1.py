# /// script
# dependencies = [
#   "google-cloud-storage",
# ]
# ///

# Dans un bucket (Cloud Storage) dédié créez un dossier par jour de l’année 2026.
# Améliorez en rangeant par mois.

from datetime import datetime, timedelta
from google.cloud import storage

# Création du bucket
bucket_name = "christophe-2026"
client = storage.Client(project="ensai-2026")
bucket = client.bucket(bucket_name)

# Création du dossier par jour de l'année 2026
start = datetime(2026, 1, 1)

while start < datetime(2026, 12, 31):
    folder_name = start.strftime("year=%Y/month=%m/day=%d")
    bucket.blob(folder_name).upload_from_string("")
    start += timedelta(days=1)
