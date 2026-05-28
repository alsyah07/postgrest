#!/bin/bash
echo "▶ Menjalankan semua migration..."
for f in $(dirname "$0")/../migrations/*.sql; do
  echo "   → $f"
  psql -d db_postgrest -f "$f"
done
echo "✅ Selesai."
