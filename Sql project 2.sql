select * from [dbo].[Nashville Housing]




--Standardize Date Format

select SaleDateConverted, CONVERT(date, SaleDate) As SaleDate2
from [dbo].[Nashville Housing]

update [dbo].[Nashville Housing]
set SaleDate = CONVERT(date, SaleDate)

Alter table [dbo].[Nashville Housing]
add SaleDateConverted Date;

update [dbo].[Nashville Housing]
set SaleDateConverted = CONVERT(date, SaleDate)

------------------------------------------------------------------------------------------------------------------------------------------



--Populate Property Address Data


select PropertyAddress
from [dbo].[Nashville Housing]
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.propertyaddress, b.parcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from [dbo].[Nashville Housing] a
join [dbo].[Nashville Housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from [dbo].[Nashville Housing] a
join [dbo].[Nashville Housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Select * from [dbo].[Nashville Housing]

-------------------------------------------------------------------------------------------------------------------------
--Breaking out Address Into Columns (Address, City, State)

Select SUBSTRING(propertyaddress, 1, charindex(',',propertyaddress) -1) as Address,
SUBSTRING(propertyaddress, charindex(',',propertyaddress) +1, LEN(PropertyAddress)) as Address
 from [dbo].[Nashville Housing]


 Alter Table [dbo].[Nashville Housing]
 add PropertySplitAddress Nvarchar(255);

 Update [dbo].[Nashville Housing]
 set PropertySplitAddress = SUBSTRING(propertyaddress, 1, charindex(',',propertyaddress) -1)


 Alter Table [dbo].[Nashville Housing]
 add PropertySplitCity Nvarchar(255);

 update [dbo].[Nashville Housing]
 set PropertySplitCity = SUBSTRING(propertyaddress, charindex(',',propertyaddress) +1, LEN(PropertyAddress))


 select * from [dbo].[Nashville Housing]



Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from [dbo].[Nashville Housing]



Alter Table [dbo].[Nashville Housing]
 add OwnerSplitAddress Nvarchar(255);

 Update [dbo].[Nashville Housing]
 set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)



 Alter Table [dbo].[Nashville Housing]
 add OwnerSplitCity Nvarchar(255);

 Update [dbo].[Nashville Housing]
 set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)





Alter Table [dbo].[Nashville Housing]
 add OwnerSplitState Nvarchar(255);

 Update [dbo].[Nashville Housing]
 set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



 select * from [dbo].[Nashville Housing]

 --------------------------------------------------------------------------------------------------------------------------------

 --Change Y and N to Yes and No in "SoldAsVacant" filed


 select distinct(soldasvacant)
 from [dbo].[Nashville Housing]



 select soldasvacant,
 case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end
 from [dbo].[Nashville Housing]


update [dbo].[Nashville Housing]
set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end 

--------------------------------------------------------------------------------------------------------------------------------------



--Removing Duplicates

with RowNumCTE as(
select *, 
ROW_NUMBER() over (
partition by parcelID,
             PropertyAddress,
             SaleDate,
			 SalePrice,
			 LegalReference
			 order by UniqueID
			 ) row_num
from [dbo].[Nashville Housing]
)
select *
from RowNumCTE
where row_num > 1 
--order by PropertyAddress

select *
from [dbo].[Nashville Housing]

-----------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns


select *
from [dbo].[Nashville Housing]

Alter Table [dbo].[Nashville Housing]
drop column SaleDate
