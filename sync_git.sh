#!/bin/bash

# Ambil path file yang dikirim oleh Nodemon
FILE=$1

# Validasi jika Nodemon mengirim string kosong agar tidak psql error
if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
    echo "⚠️ File tidak valid atau kosong, menunggu perubahan berikutnya..."
    exit 0
fi

echo "--------------------------------------------------"
echo "⚡ Terdeteksi perubahan pada file: $FILE"
echo "--------------------------------------------------"

# 1. Jalankan script SQL langsung ke PostgreSQL lokal Anda (Menggunakan tanda kutip yang aman)
/opt/homebrew/bin/psql "postgres://mac@127.0.0.1:5432/db_postgrest" -f "./$FILE"

if [ $? -eq 0 ]; then
    echo "✅ 1. Sukses terinstal di PostgreSQL (Cek pgAdmin Anda!)"
    
    # 2. Kirim sinyal reload schema ke PostgREST agar cache ter-update otomatis
    /opt/homebrew/bin/psql "postgres://mac@127.0.0.1:5432/db_postgrest" -c "NOTIFY pgrst, 'reload schema';"
    echo "🔄 2. PostgREST schema reloaded."
    
    # 3. Masukkan file ke Git, commit, dan push otomatis ke GitHub
    git add "$FILE"
    COMMIT_MSG="sync: $(basename "$FILE")"
    git commit -m "$COMMIT_MSG"
    
    echo "🚀 3. Memulai push ke GitHub (alsyah07/postgrest)..."
    git push origin main
    
    echo "🎉 SINKRONISASI SUKSES!"
else
    echo "❌ Gagal menerapkan ke database. Periksa kembali sintaks SQL Anda."
fi
echo "--------------------------------------------------"