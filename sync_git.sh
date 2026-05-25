#!/bin/bash

# Ambil path file yang dikirim oleh Nodemon
FILE=$1

# JIKA NODEMON BARU START PERTAMA KALI (FILE MASIH KOSONG)
if [ -z "$FILE" ]; then
    echo "📨 [Watcher] Nodemon siap memantau folder functions... Silakan edit & save file SQL Anda."
    exit 0 # Menggunakan exit 0 agar nodemon tidak mengira aplikasi crashed
fi

echo "--------------------------------------------------"
echo "⚡ Terdeteksi perubahan pada file: $FILE"
echo "--------------------------------------------------"

# 1. Jalankan script SQL langsung ke PostgreSQL lokal Anda
psql "postgres://mac@127.0.0.1:5432/db_postgrest" -f "$FILE"

if [ $? -eq 0 ]; then
    echo "✅ Sukses diterapkan ke database local PostgreSQL."
    
    # 2. Kirim sinyal reload schema ke PostgREST agar cache ter-update otomatis
    psql "postgres://mac@127.0.0.1:5432/db_postgrest" -c "NOTIFY pgrst, 'reload schema';"
    echo "🔄 PostgREST schema cache reloaded."
    
    # 3. Masukkan file ke Git, commit, dan push otomatis ke GitHub
    git add "$FILE"
    # Mengambil nama file sebagai pesan commit (misal: "sync: ubah_produk.sql")
    COMMIT_MSG="sync: $(basename "$FILE")"
    git commit -m "$COMMIT_MSG"
    
    echo "🚀 Memulai push ke GitHub (alsyah07/postgrest)..."
    git push origin main
    
    echo "🎉 Selesai! Kode di Database dan GitHub sudah sinkron."
else
    echo "❌ Gagal menerapkan ke database. Periksa kembali sintaks SQL Anda."
fi
echo "--------------------------------------------------"