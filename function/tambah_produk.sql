CREATE OR REPLACE FUNCTION public.tambah_produk(
    nama TEXT, 
    jumlah INT, 
    harga_baru NUMERIC
)
RETURNS SETOF public.produk AS $$
BEGIN
    RETURN QUERY
    INSERT INTO produk (nama_barang, stok, harga)
    VALUES (nama, jumlah, harga_baru)
    RETURNING *; -- Memaksa PostgreSQL mengembalikan data yang baru dibuat
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Berikan izin akses ke web_anon agar bisa diakses langsung via Postman tanpa token
GRANT EXECUTE ON FUNCTION public.tambah_produk(TEXT, INT, NUMERIC) TO web_anon; 