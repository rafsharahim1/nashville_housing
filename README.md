Nashville Housing Data Cleaning Project SQL
This project involves cleaning a dataset from the Nashville housing market found in the 'nashville_housing_data_2013_2016' table. The cleaned data will be stored in a staging table called 'NashvilleHousing_Staging'.

Steps and Procedures
Create Staging Table:

Create a staging table NashvilleHousing_Staging from nashville_housing_data_2013_2016.
Display the Dataset:

View the first 10 records of NashvilleHousing_Staging.
Change the Date Format for 'Sale Date':

Convert Sale Date to display only the date component.
Populate Data Where 'Property Address' is Null:

Update null Property Address values using corresponding values from other rows with the same Parcel ID.
Split 'Property Address' into 'Address' and 'City':

Separate Property Address into PropertySplitAddress and PropertySplitCity.
Split 'Owner Address' into 'Address', 'City', and 'State':

Separate Owner Address into OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState.
Replace 'Y' and 'N' Values with 'Yes' and 'No' for 'Sold As Vacant':

Update Sold As Vacant column to replace 'Y' and 'N' with 'Yes' and 'No' respectively.
Remove Duplicates:

Delete duplicate records based on specific columns.
Drop Unnecessary Columns:

Remove columns Property Address, Sale Date, Address, and Tax District from the staging table.
Final Check:

Verify the first 10 records of the cleaned NashvilleHousing_Staging table.
Tools Used
MySQL Server
MySQL Workbench or Command Line Tools