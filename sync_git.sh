#!/bin/bash

# Ambil path file yang dikirim oleh Nodemon
FILE=$1

# Jika nodemon baru start pertama kali, standby
if [ -z "$FILE" ]; then
    echo "📨 [Watcher] Nodemon standby... Silakan edit & save file SQL Anda."
    exit 0
fi

echo "--------------------------------------------------"
echo "⚡ Terdeteksi perubahan pada file: $FILE"
echo "--------------------------------------------------"

# 1. Jalankan ke PostgreSQL menggunakan path absolut Homebrew Mac M3
/opt/homebrew/bin/psql "postgres://mac@127.0.0.1:5432/db_postgrest" -f "$FILE"

if [ $? -eq 0 ]; then
    echo "✅ 1. Sukses terinstal di PostgreSQL (Cek pgAdmin Anda!)"
    
    # 2. Reload schema cache PostgREST
    /opt/homebrew/bin/psql "postgres://mac@127.0.0.1:5432/db_postgrest" -c "NOTIFY pgrst, 'reload schema';"
    echo "🔄 2. PostgREST schema reloaded."
    
    # 3. Dorong otomatis ke GitHub
    git add "$FILE"
    COMMIT_MSG="sync: $(basename "$FILE")"
    git commit -m "$COMMIT_MSG"
    
    echo "🚀 3. Memulai push ke GitHub..."
    git push origin main
    
    echo "🎉 SINKRONISASI SUKSES!"
else
    echo "❌ Gagal menerapkan ke database. Periksa sintaks SQL Anda."
fi
echo "--------------------------------------------------"