/*
===============================================================
DDL Script: Create Bronze Tables
=============================================================== 
Script Purpose:
      This script creates tables in the `Bronze` schema, dropping exixting TABLE
      if they already exist. 
      Run this script to re-define the DDL structure of `bronze` Tables
 */

-- crm
CREATE TABLE bronze.crm_cust_info(
    cst_id INT,
    cst_keyVARCHAR(50),
    cst_firstnameVARCHAR(50),
    cst_lastnameVARCHAR(50),
    cst_material_statusVARCHAR(50),
    cst_gndrVARCHAR(50),
    cst_create_date DATE
);
CREATE TABLE bronze.crm_prd_info(
    prd_id INT,
    prd_keyVARCHAR(50),
    prd_nmVARCHAR(50),
    prd_cost INT,
    prd_lineVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);
CREATE TABLE bronze.crm_sales_details(
    sls_ord_numVARCHAR(50),
    sls_prd_keyVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);
-- erp
CREATE TABLE bronze.erp_cust_az12(
    cidVARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);
CREATE TABLE bronze.erp_loc_a101(cidVARCHAR(50),
cntryVARCHAR(50));
CREATE TABLE bronze.px_cat_g1v2(idVARCHAR(50),
catVARCHAR(50),
subcatVARCHAR(50),
maintenanceVARCHAR(50));

