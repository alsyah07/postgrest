-- 1. Hapus fungsi lama jika ada struktur parameter yang sempat menggantung
DROP FUNCTION IF EXISTS public.tambah_produk(TEXT, INT, NUMERIC);

-- 2. Buat ulang fungsi dengan variabel yang sudah konsisten (namas)
CREATE OR REPLACE FUNCTION public.tambah_produk(
    namas TEXT, 
    jumlah INT, 
    harga_baru NUMERIC
)
RETURNS SETOF public.produk AS $$
BEGIN
    RETURN QUERY
    INSERT INTO public.produk (nama_barang, stok, harga)
    VALUES (namas, jumlah, harga_baru)
    RETURNING *;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Berikan hak akses eksekusi ke role PostgREST anonim Anda
GRANT EXECUTE ON FUNCTION public.tambah_produk(TEXT, INT, NUMERIC) TO web_anon;

-- 4. Paksa PostgREST untuk menyegarkan cache skemanya secara instan
NOTIFY pgrst, 'reload schema';