/*
===============================================================================
Data Quality Checks - Bronze Layer
===============================================================================
Script Purpose:
    This script identifies data quality issues within the raw data stored in the
    'bronze' layer before transformation and loading into the Silver Layer.

    The checks focus on:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency issues.
    - Invalid date values and date relationships.
    - Missing or invalid business values.
    - Preliminary validation of relationships between source datasets.

    The findings from these checks are used to define cleansing and
    transformation rules applied during the Bronze-to-Silver ETL process.

Usage Notes:
    - Execute these checks before building Silver Layer transformations.
    - Review all returned records and identify required cleansing actions.
    - Results may contain expected data quality issues that will be addressed
      during transformation.
===============================================================================
*/

-- ====================================================================
-- Checking 'bronze.crm_cust_info'
-- ====================================================================

-- Preview Raw Data
SELECT TOP 100 * FROM bronze.crm_cust_info

-- Check for NULLs or Duplicates in Primary Key
SELECT
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for Unwanted Spaces in First Name
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Check for Unwanted Spaces in Last Name
SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Review Gender Values for Standardization
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

-- Review Marital Status Values for Standardization
SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info

-- Compare Customer Keys Across Source Systems
SELECT cst_key FROM bronze.crm_cust_info
SELECT cid FROM bronze.erp_loc_a101
SELECT cid FROM bronze.erp_cust_az12

-- ====================================================================
-- Checking 'bronze.crm_prd_info'
-- ====================================================================

-- Preview Raw Data
SELECT TOP 100 * FROM bronze.crm_prd_info

-- Check for NULLs or Duplicates in Primary Key
SELECT
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for Unwanted Spaces in Product Name
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for NULL or Negative Product Cost Values
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Review Product Line Values for Standardization
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Check for Invalid Product Date Ranges
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- Compare Product Keys with Category Reference Table
SELECT prd_key FROM bronze.crm_prd_info
SELECT id FROM bronze.erp_px_cat_g1v2

-- ====================================================================
-- Checking 'bronze.crm_sales_details'
-- ====================================================================

-- Preview Raw Data
SELECT TOP 100 * FROM bronze.crm_sales_details

-- Check for Invalid Date Values
SELECT
    sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR LEN(sls_due_dt) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

-- Check for Invalid Date Relationships
SELECT
    *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales = Quantity * Price
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- Compare Sales Customer IDs with Customer Master Data
SELECT sls_cust_id FROM bronze.crm_sales_details
SELECT cst_id FROM bronze.crm_cust_info

-- Compare Sales Product Keys with Product Master Data
SELECT sls_prd_key FROM bronze.crm_sales_details
SELECT prd_key FROM bronze.crm_prd_info

-- ====================================================================
-- Checking 'bronze.erp_cust_az12'
-- ====================================================================

-- Preview Raw Data
SELECT TOP 100 * FROM bronze.erp_cust_az12

-- Identify Out-of-Range Birth Dates
SELECT DISTINCT
    bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- Review Gender Values for Standardization
SELECT DISTINCT
    gen
FROM bronze.erp_cust_az12;

-- ====================================================================
-- Checking 'bronze.erp_loc_a101'
-- ====================================================================

-- Preview Raw Data
SELECT TOP 100 * FROM bronze.erp_loc_a101

-- Review Country Values for Standardization
SELECT DISTINCT
    cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Checking 'bronze.erp_px_cat_g1v2'
-- ====================================================================

-- Preview Raw Data
SELECT TOP 100 * FROM bronze.erp_px_cat_g1v2

-- Check for Unwanted Spaces
SELECT
    *
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- Review Category Values for Standardization
SELECT DISTINCT
    cat
    --subcat
    --maintenance
FROM bronze.erp_px_cat_g1v2;