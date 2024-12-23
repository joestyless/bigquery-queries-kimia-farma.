CREATE OR REPLACE TABLE kimia_farma.tabel_analisa AS
SELECT
    t.transaction_id, 
    t.date,           
    c.branch_id,      
    c.branch_name,    
    c.kota,           
    c.provinsi,       
    c.rating AS rating_cabang, 
    t.customer_name,  
    p.product_id,     
    p.product_name,   
    p.price AS actual_price,   
    t.discount_percentage, 
    CASE
        WHEN p.price <= 50000 THEN 10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 25
        ELSE 30
    END AS persentase_gross_laba, 
    (p.price - (p.price * t.discount_percentage / 100)) AS nett_sales, 
    ((p.price - (p.price * t.discount_percentage / 100)) * 
     CASE
         WHEN p.price <= 50000 THEN 0.1
         WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
         WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
         WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
         ELSE 0.3
     END) AS nett_profit, 
    t.rating AS rating_transaksi 
FROM
    kimia_farma.kf_final_transaction AS t
LEFT JOIN 
    kimia_farma.kf_kantor_cabang AS c
    ON t.branch_id = c.branch_id
LEFT JOIN 
    kimia_farma.kf_product AS p
    ON t.product_id = p.product_id;