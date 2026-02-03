
DECLARE @json VARBINARY(MAX);
DECLARE @jsonText NVARCHAR(MAX);


SELECT @json = BulkColumn
FROM OPENROWSET(BULK 'C:\jsons\products.json', SINGLE_BLOB) as j;
DECLARE @xml XML;
SET @xml = CAST(@json AS XML);
SET @jsonText = CAST(@xml AS NVARCHAR(MAX));

INSERT INTO Products(
    IdProduct,
    Name,
    Price,
    MinStock,
    VendingMachineId,
    Description,
    QuantityAvaliable,
    SalesTrend
) 
SELECT 
    JSON_VALUE(value, '$.id'),
    JSON_VALUE(value, '$.name'),
    CAST(JSON_VALUE(value, '$.price') AS DECIMAL(10,2)),
    CAST(JSON_VALUE(value, '$.min_stock') AS INT),
    JSON_VALUE(value, '$.vending_machine_id'),
    JSON_VALUE(value, '$.description'),
    CAST(JSON_VALUE(value, '$.quantity_available') AS INT),
    JSON_VALUE(value, '$.sales_trend')
FROM OPENJSON(@jsonText);  -- Ключевое изменение: используем OPENJSON для массива