/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs data quality validation checks across all tables in the
    'silver' layer. The checks focus on:
    - Primary key uniqueness and null validation.
    - Detection of unwanted spaces in text fields.
    - Data standardization and consistency validation.
    - Referential integrity between related tables.
    - Validation of date ranges and date relationships.
    - Verification of business rules and calculated values.

Usage Notes:
    - Execute these checks after loading data into the Silver Layer.
    - Any returned records should be reviewed and resolved.
    - Queries marked with expectations should return no results unless
      data quality issues exist.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================

-- Preview Data
SELECT TOP 100 * FROM silver.crm_cust_info

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for Unwanted Spaces in First Name
-- Expectation: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Check for Unwanted Spaces in Last Name
-- Expectation: No Results
SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

-- Data Standardization & Consistency
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

-- Referential Integrity Check
-- Verify all customers exist in ERP location table
-- Expectation: No Results
SELECT cst_key FROM silver.crm_cust_info
WHERE cst_key NOT IN (SELECT cid FROM silver.erp_loc_a101)

-- Referential Integrity Check
-- Verify all customers exist in ERP customer table
-- Expectation: No Results
SELECT cst_key FROM silver.crm_cust_info
WHERE cst_key NOT IN (SELECT cid FROM silver.erp_cust_az12)

-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================

-- Preview Data
SELECT TOP 100 * FROM silver.crm_prd_info

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for NULLs or Negative Values in Product Cost
-- Expectation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for Invalid Date Orders
-- Expectation: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- Referential Integrity Check
-- Verify all products are assigned to a valid category
-- Expectation: No Results
SELECT cat_id FROM silver.crm_prd_info
WHERE cat_id NOT IN
      (SELECT id FROM silver.erp_px_cat_g1v2)

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================

-- Preview Data
SELECT TOP 100 * FROM silver.crm_sales_details

-- Check for Invalid Dates
-- Expectation: No Results
SELECT 
    sls_due_dt
FROM silver.crm_sales_details
WHERE  sls_due_dt IS NULL 
    OR LEN(sls_due_dt) != 10 
    OR sls_due_dt > '2050-01-01' 
    OR sls_due_dt < '1900-01-01';

-- Check for Invalid Date Orders
-- Expectation: No Results
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales = Quantity * Price
-- Expectation: No Results
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- Referential Integrity Check
-- Verify all sales records reference a valid customer
-- Expectation: No Results
SELECT
sls_cust_id
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT DISTINCT cst_id FROM silver.crm_cust_info);

-- Referential Integrity Check
-- Verify all sales records reference a valid product
-- Expectation: No Results
SELECT
sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT DISTINCT prd_key FROM silver.crm_prd_info);

-- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================

-- Preview Data
SELECT TOP 100 * FROM silver.erp_cust_az12

-- Identify Out-of-Range Birth Dates
-- Expectation: Birthdates between 1924-01-01 and Today
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Data Standardization & Consistency
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================

-- Preview Data
SELECT TOP 100 * FROM silver.erp_loc_a101

-- Data Standardization & Consistency
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================

-- Preview Data
SELECT TOP 100 * FROM silver.erp_px_cat_g1v2

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
SELECT DISTINCT 
    --cat
    --subcat
    maintenance 
FROM silver.erp_px_cat_g1v2;
