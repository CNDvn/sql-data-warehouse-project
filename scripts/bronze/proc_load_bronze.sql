/*
=============================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=============================================================
Script Purpose:
      This stored procedure loads data into `Bronze` schema from external CSV files. 
      It performs the following actions:
      - Truncates the bronze Tables before loading data.
      - Uses the `BULK INSERT` command to load data from csv Files to bronze tables. 

Parameters:
      None. 
      This stored procedure does not accept any parameters or return any values. 

Usage Example:
      CALL bronze.load_bronze();
=============================================================
 */
create or replace procedure bronze.load_bronze() 
language  plpgsql
as $$
declare 
	start_time timestamp;
	batch_start_time timestamp;
begin
	batch_start_time := NOW();
	
	raise notice '========================================';
	raise notice '========= Loading Bronze Layer ========='; 
	raise notice '========================================';
	
	raise notice '----------------------------------------';
	raise notice '--------- Loading CRM Tables ---------'; 
	raise notice '----------------------------------------';
	
	-- crm
	start_time := NOW();
	raise notice '>> TruncatingTable: bronze.crm_cust_info';
	truncate bronze.crm_cust_info;
	
	raise notice '>> Inserting Data Into: bronze.crm_cust_info';
	COPY bronze.crm_cust_info(
	    cst_id,
	    cst_key,
	    cst_firstname,
	    cst_lastname,
	    cst_material_status,
	    cst_gndr,
	    cst_create_date
	)
	FROM
	    '/var/lib/postgresql/data/datasets/source_crm/cust_info.csv'WITH(
	        FORMAT CSV,
	        HEADER TRUE,
	        delimiter ','
	    );
	raise notice '>> Load Duration: % seconds', now() - start_time;
	raise notice '----------------------------------------';
	
	start_time := NOW();
	raise notice '>> TruncatingTable: bronze.crm_prd_info';
	truncate bronze.crm_prd_info;
	
	raise notice '>> Inserting Data Into: bronze.crm_prd_info';
	COPY bronze.crm_prd_info(
	    prd_id,
	    prd_key,
	    prd_nm,
	    prd_cost,
	    prd_line,
	    prd_start_dt,
	    prd_end_dt
	)
	FROM
	    '/var/lib/postgresql/data/datasets/source_crm/prd_info.csv'WITH(
	        FORMAT CSV,
	        HEADER TRUE,
	        delimiter ','
	    );
	raise notice '>> Load Duration: % seconds', now() - start_time;
	raise notice '----------------------------------------';
	
	start_time := NOW();
	raise notice '>> TruncatingTable: bronze.crm_sales_details';
	truncate bronze.crm_sales_details;
	
	raise notice '>> Inserting Data Into: bronze.crm_sales_details';
	COPY bronze.crm_sales_details(sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price)
	FROM
	    '/var/lib/postgresql/data/datasets/source_crm/sales_details.csv'WITH(
	        FORMAT CSV,
	        HEADER TRUE,
	        delimiter ','
	    );
	raise notice '>> Load Duration: % seconds', now() - start_time;
	raise notice '----------------------------------------';
	
	-- erp
	raise notice '----------------------------------------';
	raise notice '--------- Loading ERP Tables ---------'; 
	raise notice '----------------------------------------';
	
	start_time := NOW();
	raise notice '>> TruncatingTable: bronze.erp_cust_az12';
	truncate bronze.erp_cust_az12;
	
	raise notice '>> Inserting Data Into: bronze.erp_cust_az12';
	COPY bronze.erp_cust_az12(
	    cid,
	    bdate,
	    gen
	)
	FROM
	    '/var/lib/postgresql/data/datasets/source_erp/CUST_AZ12.csv'WITH(
	        FORMAT CSV,
	        HEADER TRUE,
	        delimiter ','
	    );
	raise notice '>> Load Duration: % seconds', now() - start_time;
	raise notice '----------------------------------------';
	
	start_time := NOW();
	raise notice '>> TruncatingTable: bronze.erp_loc_a101';
	truncate bronze.erp_loc_a101;
	
	raise notice '>> Inserting Data Into: bronze.erp_loc_a101';
	copy bronze.erp_loc_a101(
	    cid,
	    cntry
	)
	from
	    '/var/lib/postgresql/data/datasets/source_erp/LOC_A101.csv' with(
	        FORMAT csv,
	        header true,
	        delimiter ','
	    );
	raise notice '>> Load Duration: % seconds', now() - start_time;
	raise notice '----------------------------------------';
	
	start_time := NOW();
	raise notice '>> TruncatingTable: bronze.px_cat_g1v2';
	truncate bronze.px_cat_g1v2;
	
	raise notice '>> Inserting Data Into: bronze.px_cat_g1v2';
	COPY bronze.px_cat_g1v2(
	    id,
	    cat,
	    subcat,
	    maintenance
	)
	FROM
	    '/var/lib/postgresql/data/datasets/source_erp/PX_CAT_G1V2.csv'WITH(
	        FORMAT CSV,
	        HEADER TRUE,
	        delimiter ','
	    );
	raise notice '>> Load Duration: % seconds', now() - start_time;
	raise notice '----------------------------------------';
	
	RAISE NOTICE '===========================================';
	RAISE NOTICE 'Loading Broze Layer is Completed';
	RAISE NOTICE '		- Total Load Duration: %', NOW() - batch_start_time;
	RAISE NOTICE '===========================================';
	 
EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE '===========================================';
		RAISE NOTICE 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		RAISE NOTICE 'Error Message: % (%)', SQLERRM, SQLSTATE;
		RAISE NOTICE '===========================================';
end;
$$;
