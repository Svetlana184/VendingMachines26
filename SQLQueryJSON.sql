DECLARE @json VARBINARY(MAX);
DECLARE @jsonText NVARCHAR(MAX);


SELECT @json = BulkColumn
FROM OPENROWSET(BULK 'C:\jsons\user_f9e38a01-137d-454e-93fe-6a736fcb06e5.json', SINGLE_BLOB) as j;
DECLARE @xml XML;
SET @xml = CAST(@json AS XML);
SET @jsonText = CAST(@xml AS NVARCHAR(MAX));

INSERT INTO Users (
        Email,
        FullName,
        IsManager,
        IsEngineer,
        Phone,
        IdUser,
        IsOperator,
        Role,
        Image
    ) 
    SELECT 
        JSON_VALUE(@jsonText, '$.email'),
        JSON_VALUE(@jsonText, '$.full_name'),
        CASE WHEN JSON_VALUE(@jsonText, '$.is_manager') = 'true' THEN 1 ELSE 0 END,
        CASE WHEN JSON_VALUE(@jsonText, '$.is_engineer') = 'true' THEN 1 ELSE 0 END,
        JSON_VALUE(@jsonText, '$.phone'),
        JSON_VALUE(@jsonText, '$.id'),
        CASE WHEN JSON_VALUE(@jsonText, '$.is_operator') = 'true' THEN 1 ELSE 0 END,
        JSON_VALUE(@jsonText, '$.role'),
        JSON_VALUE(@jsonText, '$.image');