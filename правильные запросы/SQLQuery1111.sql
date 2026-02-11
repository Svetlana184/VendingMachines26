declare @json varbinary(max);
declare @jsonText nvarchar(max);

select @json = BulkColumn from 
openrowset(bulk 'C:\jsons\user_f9e38a01-137d-454e-93fe-6a736fcb06e5.json', single_blob) as j;

declare @xml xml;
set @xml = cast(@json as xml);
set @jsonText = cast(@xml as nvarchar(max));

insert into Users 
(user_id, email, full_name, is_manager, is_engineer, phone, is_operator, role)
select 
json_value(@jsonText, '$.id'),
json_value(@jsonText, '$.email'),
json_value(@jsonText, '$.full_name'),
case when json_value(@jsonText, '$.is_manager') = 'true' then 1 else 0 end,
case when json_value(@jsonText, '$.is_engineer') = 'true' then 1 else 0 end,
json_value(@jsonText, '$.phone'),
case when json_value(@jsonText, '$.is_operator') = 'true' then 1 else 0 end,
json_value(@jsonText, '$.role')
;

	