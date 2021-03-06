
GO
/****** Object:  StoredProcedure [dbo].[AddContactsTemporary]    Script Date: 23/09/2014 9:25:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddContactsTemporary]
    @FirstName			VARCHAR(50),
	@LastName			VARCHAR(50),
	@Email				VARCHAR(150),
	@Newsletter			INT
AS
  DECLARE @Exist INT

  select @Exist=COUNT(*) from ContactsTemporary where Email = @Email 

  if @Exist = 0
  BEGIN
    INSERT INTO ContactsTemporary(FirstName, LastName, Email, Newsletter) Values (@FirstName, @LastName, @Email, @Newsletter)
  END

GO
/****** Object:  StoredProcedure [dbo].[AddDownloadInteractionContact]    Script Date: 23/09/2014 9:25:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddDownloadInteractionContact]
@Email			VARCHAR(150),
@Subject			TEXT,
@Notes				TEXT

AS

DECLARE @ContactID INT

SELECT @ContactID = ContactID FROM Contacts WHERE Email = @Email

INSERT INTO Interactions(ContactID, DateTime, InteractionType, Subject, Respondant, Notes) 
	VALUES (@ContactID, getdate(), 1, @Subject, 'Web Download', @Notes)

GO
/****** Object:  StoredProcedure [dbo].[CommitContact]    Script Date: 23/09/2014 9:25:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CommitContact]
	@Email				VARCHAR(150)
AS
  DECLARE @Exist INT, @FirstName varchar(50), @LastName varchar (50), @Newsletter INT, @ContactID INT

		-- Check temporary contact
  select @Exist=COUNT(*), @FirstName=FirstName, @LastName=LastName, @Newsletter=Newsletter from ContactsTemporary where Email = @Email Group by FirstName, LastName, Newsletter

  if @Exist = 1
  BEGIN
		-- Is not a contact
	select @Exist=COUNT(*) from Contacts where Email = @Email 
	if @Exist = 0
	begin
			-- Add Contacts
        Begin Transaction  ADD_CONTACT
			INSERT INTO Contacts(FirstName, LastName, Email) Values (@FirstName, @LastName, @Email)
		Commit Transaction ADD_CONTACT
			-- If register newsletter, add it to answer
		if @Newsletter = 1
		begin
			DECLARE @AnswerID INT
			select @AnswerID =isnull (max(AnswerID + 1), 1) from Answers
			select @ContactID=ContactID from Contacts where Email = @Email
			INSERT INTO Answers(AnswerID, ContactID, QuestionID, Notes, DateTime) Values ( @AnswerID, @ContactID, 11, 'Register Newsletter', getDate())
		end

		DELETE FROM ContactsTemporary WHERE Email = @Email
    end 
		
  END



GO
/****** Object:  StoredProcedure [dbo].[GetContactFromEmail]    Script Date: 23/09/2014 9:25:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetContactFromEmail]
	@EMail VARCHAR(100)

AS

SELECT Contacts.FirstName, Contacts.LastName
FROM Contacts
WHERE EMail = @EMail
GO
/****** Object:  StoredProcedure [dbo].[GetDownloadExpirationTokenAge]    Script Date: 23/09/2014 9:25:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetDownloadExpirationTokenAge]
    @Email				VARCHAR(150),
	@Token              VARCHAR(50)
AS
  DECLARE @Exist INT


  select @Exist=COUNT(*) from DownloadExpiration where Token = @Token

  if @Exist = 1
  BEGIN
       select DATEDIFF(DAY,CreatedDate,getdate()) from DownloadExpiration where Token = @Token 
  END
  IF @Exist = 0
  begin
	   Select -1  
  end 
GO
/****** Object:  StoredProcedure [dbo].[InitializeDownload]    Script Date: 23/09/2014 9:25:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InitializeDownload]
	-- Add the parameters for the stored procedure here
	@Email	            VARCHAR(150), 
	@Token              VARCHAR(50),
	@Platform           VARCHAR(50),
	@Company            VARCHAR(100),
	@FirstName			VARCHAR(240),
	@LastName			VARCHAR(240)

	
AS
DECLARE @ContactID INT
DECLARE @Exist INT = 0

SELECT @ContactID = ContactID, @Exist= ContactID FROM Contacts WHERE Email = @Email

IF @Exist = 0
BEGIN
	SELECT @ContactID = ContactID FROM ContactsTemporary WHERE Email = @Email	
END

INSERT INTO DownloadExpiration(ContactID, Email, Token, Platform, Company, FirstName, LastName, CreatedDate) 
	VALUES (@ContactID, @Email,  @Token, @Platform,  @Company, @FirstName, @LastName, getdate())



GO
/****** Object:  StoredProcedure [dbo].[RemoveDownloadExpiration]    Script Date: 23/09/2014 9:25:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RemoveDownloadExpiration]
	-- Add the parameters for the stored procedure here
	@Email	            VARCHAR(150), 
	@Token              VARCHAR(50)
	
AS

DELETE FROM DownloadExpiration WHERE Email = @Email and Token = @Token;


GO


CREATE PROCEDURE [dbo].[RegisterNewsletter]
    @Email				VARCHAR(150)

AS
  DECLARE @ContactID INT
  DECLARE @QuestionID INT 
  DECLARE @Exist INT

  SET @ContactID = 0
  SET @QuestionID = 11 

  select @ContactID = ContactID from Contacts where Email = @Email 

  if @ContactID > 0
  BEGIN transaction register_newsletter
	select @Exist= Count(*) from Answers where ContactID = @ContactID
	if @Exist = 0
	  begin
	    DECLARE @AnswerID INT
		select @AnswerID=isnull (max(AnswerID + 1), 1) from Answers
	    INSERT INTO Answers(AnswerID, ContactID, QuestionID, Notes, DateTime) Values (@AnswerID, @ContactID, 11, 'Register Newsletter', getDate())
	  end
  commit transaction register_newsletter
GO
