--exec sp_addlinkedserver 'old_link','','SQLOLEDB','128.1.3.69'
--exec sp_addlinkedsrvlogin 'old_link','false',null,'sa','p@ssw0rd'



--select * from old_link.WAP_WSMP_FS.dbo.Health_Monitor

--delete from old_link.WAP_WSMP_FS.dbo.Health_Monitor where LOG_TYPE='error'




-- ===========================================================================

--EXEC master.dbo.sp_addlinkedserver

--@server = N'TEST3' , @srvproduct = N'MSDASQL' , @provider = N'MSDASQL' , @datasrc = N'69';

--exec sp_addlinkedsrvlogin 'TEST3','false',null,'sa','gci'


--SELECT * from TEST3.WAP_WSMP_WZ.dbo.Health_Monitor

-- ===========================================================================

-- --创建存储过程
-- if (exists (select * from sys.objects where name = 'proc_test'))
--     drop proc proc_test
-- go
-- create proc proc_test
-- as
--     select top 2000 * from old_link.WAP_WSMP_WZ.dbo.Health_Monitor;

-- --调用、执行存储过程
-- exec proc_test;

-- ===========================================================================

-- --创建存储过程
-- if (exists (select *
-- from sys.objects
-- where name = 'proc_export_data'))
--     drop proc proc_export_data
-- go
-- create proc proc_export_data
--     @TableName [nvarchar](500)
-- as
-- exec( 'select top 2000 * from' + @TableName)--old_link.WAP_WSMP_WZ.dbo.Health_Monitor;
-- ===========================================================================

-- --调用、执行存储过程
-- exec proc_export_data;

-- -- 查询shuju_b表中的数据
-- select TOP 5000
--     *
-- from test.newscada.dbo.sysobjects
-- where name like 'shuju_b2017%'
-- order by name
-- ===========================================================================
-- 获取符合条件的所有表名
if (exists (select *
from sys.objects
where name = 'proc_select_tables'))
    drop proc proc_select_tables
go
--存储过程
create proc proc_select_tables
    --'shuju_b2017%'
    @TablePrefix [nvarchar](500)
as
begin
    DECLARE @db_prefix VARCHAR(100)
    DECLARE @linked_db VARCHAR(100)
    DECLARE @target_table VARCHAR(100)
    set @db_prefix ='test.newscada.dbo.'
    set @linked_db =@db_prefix +'sysobjects'
    set @target_table = SUBSTRING( @TablePrefix,0,Len(@TablePrefix))
    --创建零时表
    CREATE TABLE #tmp
    (
        table_name [varchar](300)
    ) ON [PRIMARY]
    insert into #tmp
    exec('select name from '+ @linked_db +' where name like '''+@TablePrefix+''' order by name')
    -- 声明临时变量
    DECLARE @t_table_name VARCHAR(50)
    DECLARE @full_table_name VARCHAR(100)
    -- 声明游标
    DECLARE c_table_name Cursor FAST_FORWARD FOR
    select table_name
    from #tmp;
    OPEN c_table_name;
    FETCH NEXT FROM c_table_name INTO @t_table_name;
    WHILE @@fetch_status<>-1
    begin
        print @t_table_name
        set @full_table_name = @db_prefix+@t_table_name
        print @full_table_name
--         exec('USE [DataExport]
-- /****** Object:  Table   Script Date: 2017/12/20 17:21:45 ******/

-- CREATE TABLE [dbo].['+@target_table+'](
-- 	[id] [int] IDENTITY(1,1) NOT NULL,
-- 	[TAGNAME] [varchar](50) NOT NULL,
-- 	[TIME] [datetime] NOT NULL,
-- 	[value] [float] NULL,
--  CONSTRAINT [PK_d'+@target_table+'] PRIMARY KEY CLUSTERED 
-- (
-- 	[TAGNAME] ASC,
-- 	[TIME] ASC
-- )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
-- ) ON [PRIMARY]

-- SET ANSI_PADDING OFF')

    --     exec('insert into '+@target_table+'(
    --   [TAGNAME]
    --   ,[TIME]
    --   ,[value]) select 
    --   [TAGNAME]
    --   ,[TIME]
    --   ,[value] from '+@full_table_name)

    -- exec('select 
    --     [TAGNAME]
    -- ,[TIME]
    -- ,[value] into table1 from '+@t_table_name+'
    -- ')

        --         exec('select * into '+@t_table_name+' from '+@full_table_name+' as t1 where t1.tagname in (
        --             -- 石湾
        -- ''btag000387'',
        -- ''btag000388'',
        -- ''btag000389'',
        -- ''btag000390'',
        -- ''btag000391'',
        -- ''btag000392'',
        -- ''btag000102'',
        -- ''btag000103'',
        -- ''btag000104'',
        -- ''btag000105'',
        -- ''btag000106'',
        -- ''btag000107'',
        -- ''btag000156'',
        -- ''btag000157'',
        -- ''btag000159'',
        -- ''btag000160'',
        -- ''btag000161'',
        -- --沙口
        -- ''btag000170'',
        -- ''btag000171'',
        -- ''btag000172'',
        -- ''btag000173'',
        -- ''btag000174'',
        -- ''btag000175'',
        -- ''btag000231'',
        -- ''btag000232'',
        -- ''btag000233'',
        -- -- 南庄
        -- ''btag000238'',
        -- ''btag000239'',
        -- ''btag000240'',
        -- ''btag000242'',
        -- ''btag000243'',
        -- ''btag000244''

        -- )')
        -- 拿到表名,开始查数据
        -- select *
        -- into @t_table_name
        -- from ('test.newscada.dbo'+@t_table_name)
        FETCH NEXT FROM c_table_name INTO @t_table_name;
    END
    --print #tmp.table_name
    CLOSE c_table_name;
    -- 释放游标.
    DEALLOCATE c_table_name;
    drop table #tmp
end

