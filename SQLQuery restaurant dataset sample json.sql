USE [TBD]
go
--select * from restaurants

if object_id ('restaurants','U') IS NOT NULL
drop table restaurants;

create table restaurants ([id] [varchar](50),
[name] [varchar](50) null,
[borough] [varchar](50) null,
[cuisine] [varchar](50) null,
[building] [varchar](10)  null,
[street] [varchar](50)  null,
[zipcode] [int] null);

SELECT * 
FROM OPENROWSET (BULK 'D:\restaurants.json', SINGLE_CLOB) as restaurants;

declare @json nvarchar(max);
SELECT @json = Bulkcolumn from openrowset (BULK 'D:\restaurants.json', SINGLE_CLOB) as restaurants;

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

insert into restaurants
SELECT * FROM OPENJSON(@json) WITH (
[id] [varchar](50) '$._id.oid',
[name] [varchar](50),
[borough] [varchar](50),
[cuisine] [varchar](50),
[building] [varchar](10)'$.address.building',
[street] [varchar](50)'$.address.street',
[zipcode] [int]'$.address.zipcode'
)


  




  