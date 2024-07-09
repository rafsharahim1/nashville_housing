-- Create Staging Table
USE nashville_housing;
CREATE TABLE NashvilleHousing_Staging AS
SELECT *
FROM nashville_housing_data_2013_2016;
SET SQL_SAFE_UPDATES = 0;
-- Display the dataset
SELECT * 
FROM NashvilleHousing_Staging
LIMIT 10;

-- Changing the date format for 'Sale Date' to remove the time component
SELECT `Sale Date`, DATE(`Sale Date`) AS SaleDateConverted
FROM NashvilleHousing_Staging
LIMIT 10;

ALTER TABLE NashvilleHousing_Staging
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing_Staging
SET SaleDateConverted = DATE(`Sale Date`);

SELECT `Sale Date`, SaleDateConverted
FROM NashvilleHousing_Staging
LIMIT 10;

-- Populating data where 'Property Address' is null
SELECT *
FROM NashvilleHousing_Staging
WHERE `Property Address` IS NULL;

SELECT *
FROM NashvilleHousing_Staging
ORDER BY `Parcel ID`;

-- Populating data where 'Property Address' is null from the same Parcel ID
UPDATE NashvilleHousing_Staging a
JOIN NashvilleHousing_Staging b
ON a.`Parcel ID` = b.`Parcel ID`
AND a.`MyUnknownColumn` <> b.`MyUnknownColumn`
SET a.`Property Address` = IFNULL(a.`Property Address`, b.`Property Address`)
WHERE a.`Property Address` IS NULL;

-- Splitting 'Property Address' into 'Address' and 'City'
ALTER TABLE NashvilleHousing_Staging
ADD PropertySplitAddress VARCHAR(255);

UPDATE NashvilleHousing_Staging
SET PropertySplitAddress = TRIM(SUBSTRING_INDEX(`Property Address`, ',', 1));

ALTER TABLE NashvilleHousing_Staging
ADD PropertySplitCity VARCHAR(255);

UPDATE NashvilleHousing_Staging
SET PropertySplitCity = TRIM(SUBSTRING_INDEX(`Property Address`, ',', -1));

-- Splitting 'Owner Address' into 'Address', 'City', and 'State'
ALTER TABLE NashvilleHousing_Staging
ADD OwnerSplitAddress VARCHAR(255);

UPDATE NashvilleHousing_Staging
SET OwnerSplitAddress = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`Address`, ',', 1), ',', -1));

ALTER TABLE NashvilleHousing_Staging
ADD OwnerSplitCity VARCHAR(255);

UPDATE NashvilleHousing_Staging
SET OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`Address`, ',', 2), ',', -1));

ALTER TABLE NashvilleHousing_Staging
ADD OwnerSplitState VARCHAR(255);

UPDATE NashvilleHousing_Staging
SET OwnerSplitState = TRIM(SUBSTRING_INDEX(`Address`, ',', -1));

-- Replacing 'Y' and 'N' values with 'Yes' and 'No' respectively for 'Sold As Vacant'
SELECT DISTINCT(`Sold As Vacant`), COUNT(`Sold As Vacant`)
FROM NashvilleHousing_Staging
GROUP BY `Sold As Vacant`
ORDER BY 2;

SELECT `Sold As Vacant`,
       CASE 
            WHEN `Sold As Vacant` = 'Y' THEN 'Yes'
            WHEN `Sold As Vacant` = 'N' THEN 'No'
            ELSE `Sold As Vacant`
       END AS SoldAsVacantConverted
FROM NashvilleHousing_Staging;

UPDATE NashvilleHousing_Staging
SET `Sold As Vacant` = CASE 
                      WHEN `Sold As Vacant` = 'Y' THEN 'Yes'
                      WHEN `Sold As Vacant` = 'N' THEN 'No'
                      ELSE `Sold As Vacant`
                   END;

-- Removing duplicates
DELETE FROM NashvilleHousing_Staging
WHERE MyUnknownColumn NOT IN (
    SELECT * FROM (
        SELECT MIN(MyUnknownColumn)
        FROM NashvilleHousing_Staging
        GROUP BY `Parcel ID`, `Property Address`, `Sale Date`, `Sale Price`, `Legal Reference`
    ) AS temp
);

-- Dropping unnecessary columns
ALTER TABLE NashvilleHousing_Staging
DROP COLUMN `Property Address`,
DROP COLUMN `Sale Date`,
DROP COLUMN `Address`,
DROP COLUMN `Tax District`;

-- Final check
SELECT *
FROM NashvilleHousing_Staging
LIMIT 10;
