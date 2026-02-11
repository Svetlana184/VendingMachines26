declare @json varbinary(max);
declare @jsonText nvarchar(max);

select @json = BulkColumn from openrowset(bulk 'C:\jsons\products.json', single_blob) as j;
declare @xml xml;
set @xml = cast(@json as xml);
set @jsonText = cast(@xml as nvarchar(max));

insert into Products( 
	product_id, name, price, min_stock, vending_machine_id, description, quantity_available, sales_trend)
select
json_value(value, '$.id'),
json_value(value, '$.name'),
json_value(value, '$.price'),
json_value(value, '$.min_stock'),
json_value(value, '$.vending_machine_id'),
json_value(value, '$.description'),
json_value(value, '$.quantity_available'),
json_value(value, '$.sales_trend')
from openjson(@jsonText);