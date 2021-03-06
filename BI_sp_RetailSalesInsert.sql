USE [Unique]
GO
/****** Object:  StoredProcedure [dbo].[BI_sp_RetailSalesInsert]    Script Date: 2020-02-18 6:02:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[BI_sp_RetailSalesInsert] 
   @RSNO numeric(18, 0),
    @ItemCode numeric(18, 0),
    @ItemName nvarchar(100),
    @Qty int,
    @Rate numeric(10, 2),
    @Added_By nvarchar(100),
    @PartyCode INT,
	@UserInfo VARCHAR(max)='',
	@studentID int=0
    
    
AS 
BEGIN

	SET NOCOUNT ON 
	SET XACT_ABORT ON 
	
	
		

		/*
	DECLARE @is_unsaleable_at_retail int
	SET @is_unsaleable_at_retail = (SELECT ISNULL(is_unsaleable_at_retail,0) FROM dbo.BI_Items WHERE ItemCode=@ItemCode)
	IF (@is_unsaleable_at_retail=1)
		BEGIN
			declare @s1 varchar(500)='This Item is not for sale' 
						
						; throw 60000, @s1,1
        END
        
	
	if (@RSNO<=0)
		set @RSNO = (select isnull(max([RSNo]),0)+1 from BI_RetailSales)
	*/
	declare @PrintedPrice numeric (10,2),
	@FRanchisePrice numeric (10,2)
	declare @count int
	set @count =0
	select  @count = COUNT(*) from BI_RetailSales where RSNO = @RSNO and itemcode = @ItemCode  
	if (@count>0)
		begin
		 update [BI_RetailSales] set [Qty] = [Qty]+  @Qty where RSNO = @RSNO and itemcode = @ItemCode
		end
	else
		begin
			select @PrintedPrice= isnull(PrintedPrice,0), @FRanchisePrice=isnull(FrenchisePrice,0) from bi_items where itemcode=@ItemCode
			INSERT INTO [dbo].[BI_RetailSales] ([RSNO], [ItemCode], [ItemName], [RSDate], [Qty], [Rate], [Added_By],[PartyCode],
			userinfo,PrintedPrice,FRanchisePrice,StudentID)
			SELECT @RSNO, @ItemCode, @ItemName, GETDATE(), @Qty, @Rate, @Added_By,@PartyCode,@UserInfo,@PrintedPrice ,@FRanchisePrice,@studentID
		end	
	
	return @RSNO
end

