USE [TBD]
go
--select * from inspections

if object_id ('inspections','U') IS NOT NULL
drop table inspections;

create table inspections (
id varchar(50) null,
certificate_number varchar(50) null,
business_name varchar(50) null,
[date] date null,
result varchar(50) null,
sector varchar(50) null,
city varchar(50) null,
zip int null,
street varchar(50) null,
number varchar(20) null);

SELECT * 
FROM OPENROWSET (BULK 'D:\inspections.json', SINGLE_CLOB) as inspections;

declare @json nvarchar(max);
SELECT @json = Bulkcolumn from openrowset (BULK 'D:\inspections.json', SINGLE_CLOB) as inspections;

PRINT isjson(@json);

IF isjson(@json) = 1
BEGIN
	PRINT 'INI JSON';
END
ELSE
BEGIN
	PRINT 'BUKAN JSON';
END

SELECT * FROM openjson(@json);

insert into inspections
SELECT * FROM OPENJSON(@json) WITH (
id varchar(50),
certificate_number varchar(50),
business_name varchar(50),
[date] date,
result varchar(50),
sector varchar(50),
city varchar(50) '$.address.city',
zip int '$.address.zip',
street varchar(50) '$.address.street',
number varchar(20) '$.address.number'
)


  




  