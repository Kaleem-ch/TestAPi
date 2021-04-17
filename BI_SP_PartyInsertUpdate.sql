GO
CREATE PROCEDURE [dbo].[BI_SP_PartyInsertUpdate]
	@SNo INT,
	@Name NVARCHAR(200),
	@AccountNo NVARCHAR(100),
	@PartyGroup VARCHAR(100),
	@ReportType NVARCHAR(100),
	@Type NVARCHAR(100),
	@SchoolID INT,
	@MorningSchoolID INT,
	@EveningSchoolID INT,
	@ContactNo NVARCHAR(100),
	@Address NVARCHAR(200),
	@IsActive BIT
AS
BEGIN
	DECLARE @Result VARCHAR(100)
	SET @Result = ''

	IF @SNo = 0 AND @Name <> '' AND EXISTS(SELECT TOP 1 SNo FROM BI_Parties WHERE Name = @Name) 
	BEGIN
		SET @Result = 'Name already exists.';
	END

	IF @SNo <> 0 AND @Name <> '' AND EXISTS(SELECT TOP 1 SNo FROM BI_Parties WHERE Name = @Name AND SNo <> @SNo) 
	BEGIN
		SET @Result = 'Name already exists.';
	END

	IF @SNo = 0 AND @Result = ''
	BEGIN
		SELECT @SNo = IsNull(MAX(SNo), 0) + 1 FROM BI_Parties
		INSERT INTO BI_Parties(
		SNo,
		Name,
		Account_ID,
		PartyGroup,
		ReportType,
		Type,
		SchoolID,
		MorningSchoolID,
		EveningSchoolID,
		Phone,
		Address,
		isActive)
		VALUES(
		@SNo,
		@Name,
		@AccountNo,
		@PartyGroup,
		@ReportType,
		@Type,
		@SchoolID,
		@MorningSchoolID,
		@EveningSchoolID,
		@ContactNo,
		@Address,
		@IsActive)

		SET @Result = 'Record is saved successfully.';
	END

	IF @SNo <> 0 AND @Result = ''
	BEGIN
		UPDATE BI_Parties SET 
		Name = @Name,
		Account_ID = @AccountNo,
		PartyGroup = @PartyGroup,
		ReportType = @ReportType,
		Type = @Type,
		SchoolID = @SchoolID,
		MorningSchoolID = @MorningSchoolID,
		EveningSchoolID = @EveningSchoolID,
		Address = @Address,
		Phone = @ContactNo,
		isActive = @IsActive
		WHERE SNo = @SNo

		SET @Result = 'Record is saved successfully.';
	END

	SELECT @Result;
END