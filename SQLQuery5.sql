drop table dbo.Invoices
CREATE TABLE dbo.Invoices ( [InvoiceCode]
varchar(20), [ParentInvoiceCode] varchar(20),
[InvoiceDate] date )
INSERT INTO dbo.Invoices
VALUES
( 'INV-001', 'INV-001', N'2015-01-01 01:00:00.000' ),
( 'INV-002', 'INV-001', N'2016-01-01 02:00:00.000' ),
( 'INV-003', 'INV-001', N'2017-01-01 03:00:00.000' ),
( 'INV-004', 'INV-004', N'2018-01-01 04:00:00.000' ),
( 'INV-005', 'INV-005', N'2019-01-01 05:00:00.000' ),
( 'INV-006', 'INV-006', N'2020-01-01 06:00:00.000' ),
( 'INV-007', 'INV-007', N'2021-01-01 07:00:00.000' ),
( 'INV-008', 'INV-007', N'2022-01-01 08:00:00.000' ),
( 'INV-009', 'INV-007', N'2023-01-01 09:00:00.000' ),
( 'INV-010', 'INV-007', N'2024-01-01 10:00:00.000' )

with no_parent as (
select i1.InvoiceCode , i2.ParentInvoiceCode from  dbo.Invoices i1
left join dbo.Invoices i2 
on i1.ParentInvoiceCode = i2.InvoiceCode and i1.InvoiceCode != i2.InvoiceCode
where i2.InvoiceCode is null

),
no_child as (
select i1.InvoiceCode , i2.ParentInvoiceCode from  dbo.Invoices i1
left join dbo.Invoices i2 
on i1.InvoiceCode = i2.ParentInvoiceCode and i1.InvoiceCode != i2.InvoiceCode
where i2.InvoiceCode is null

)
select * from no_parent np join no_child nc on nc.InvoiceCode = np.InvoiceCode



CREATE TABLE dbo.DimInvoices
(
    InvoiceKey INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceParentKey INT NULL,
    InvoiceCode VARCHAR(20),
    ParentInvoiceCode VARCHAR(20)
);
insert into dbo.DimInvoices (
InvoiceCode,ParentInvoiceCode) 
select InvoiceCode , ParentInvoiceCode from dbo.Invoices


select * from dbo.DimInvoices

update dbo.DimInvoices
set InvoiceParentKey = (
SELECT parent.InvoiceKey
    FROM dbo.DimInvoices AS parent
    WHERE parent.InvoiceCode = DimInvoices.ParentInvoiceCode)