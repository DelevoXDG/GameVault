--- DATABASE

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'GameVault')
  CREATE DATABASE GameVault
GO

USE GameVault;

--- TABLES

IF OBJECT_ID('ExchangeRate', 'U') IS NOT NULL
  DROP TABLE ExchangeRate
GO

IF OBJECT_ID('OrderItems', 'U') IS NOT NULL
  DROP TABLE OrderItems
GO

IF OBJECT_ID('Orders', 'U') IS NOT NULL
  DROP TABLE Orders
GO

IF OBJECT_ID('Cart', 'U') IS NOT NULL
  DROP TABLE Cart
GO

IF OBJECT_ID('Wishlist', 'U') IS NOT NULL
  DROP TABLE Wishlist
GO

IF OBJECT_ID('GamePublishers', 'U') IS NOT NULL
  DROP TABLE GamePublishers
GO

IF OBJECT_ID('Publishers', 'U') IS NOT NULL
  DROP TABLE Publishers
GO

IF OBJECT_ID('GameDevelopers', 'U') IS NOT NULL
  DROP TABLE GameDevelopers
GO

IF OBJECT_ID('Developers', 'U') IS NOT NULL
  DROP TABLE Developers
GO

IF OBJECT_ID('GameAwards', 'U') IS NOT NULL
  DROP TABLE GameAwards
GO

IF OBJECT_ID('Reviews', 'U') IS NOT NULL
  DROP TABLE Reviews
GO

IF OBJECT_ID('Score', 'U') IS NOT NULL
  DROP TABLE Score
GO

IF OBJECT_ID('ReleasedGames', 'U') IS NOT NULL
  DROP TABLE ReleasedGames
GO

IF OBJECT_ID('BetaGames', 'U') IS NOT NULL
  DROP TABLE BetaGames
GO

IF OBJECT_ID('PreOrderGames', 'U') IS NOT NULL
  DROP TABLE PreOrderGames
GO

IF OBJECT_ID('UpcomingGames', 'U') IS NOT NULL
  DROP TABLE UpcomingGames
GO

IF OBJECT_ID('GamePlatforms', 'U') IS NOT NULL
  DROP TABLE GamePlatforms
GO

IF OBJECT_ID('Platforms', 'U') IS NOT NULL
  DROP TABLE Platforms
GO

IF OBJECT_ID('GameGenres', 'U') IS NOT NULL
  DROP TABLE GameGenres
GO

IF OBJECT_ID('Games', 'U') IS NOT NULL
  DROP TABLE Games
GO

IF OBJECT_ID('UserBans', 'U') IS NOT NULL
  DROP TABLE UserBans

IF OBJECT_ID('LoginAttempts', 'U') IS NOT NULL
  DROP TABLE LoginAttempts
GO

IF OBJECT_ID('Users', 'U') IS NOT NULL
  DROP TABLE Users
GO



-- 1
CREATE TABLE Users (
  UserID INT PRIMARY KEY IDENTITY(1,1),
  Username NVARCHAR(255) NOT NULL,
  Email NVARCHAR(255) NOT NULL UNIQUE CHECK (Email LIKE '%[@]%'),
  Password NVARCHAR(255) NOT NULL
);
GO

-- 2
CREATE TABLE LoginAttempts (
  LoginAttemptID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  Time DATETIME NOT NULL,
  Success BIT NOT NULL DEFAULT 0,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 3
CREATE TABLE UserBans (
  BanID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  BanStart DATETIME NOT NULL,
  BanEnd DATETIME NOT NULL
);
GO

-- 4
CREATE TABLE Games (
  GameID INT PRIMARY KEY IDENTITY(1,1),
  Title NVARCHAR(255) NOT NULL,
  LastUpdatedDate DATE NOT NULL,
  Description TEXT,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0)
);
GO

-- 5
CREATE TABLE GameGenres (
  GameGenreID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  Genre NVARCHAR(255) NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 6
CREATE TABLE Platforms (
  PlatformID INT PRIMARY KEY IDENTITY(1,1),
  Name NVARCHAR(255) NOT NULL UNIQUE
);
GO

-- 7
CREATE TABLE GamePlatforms (
  GamePlatformID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  PlatformID INT NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PlatformID) REFERENCES Platforms (PlatformID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 8
CREATE TABLE UpcomingGames (
  UpcomingGameID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  TrailerUrl NVARCHAR(255),
  ExpectedDeliveryDate DATE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 9
CREATE TABLE PreOrderGames (
  PreOrderGameID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  PreOrderBonus NVARCHAR(255),
  PreOrderDiscount DECIMAL(2),
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 10
CREATE TABLE BetaGames (
  BetaGameID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  BetaStartDate DATE NOT NULL,
  BetaEndDate DATE NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 11
CREATE TABLE ReleasedGames (
  ReleasedGameID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  ReleaseDate DATE NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 12
CREATE TABLE Score (
  ScoreID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  GameID INT NOT NULL,
  Score INT NOT NULL CHECK (Score BETWEEN 1 AND 10),
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 13
CREATE TABLE Reviews (
  ReviewID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  GameID INT NOT NULL,
  Review TEXT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 14
CREATE TABLE GameAwards (
  GameAwardsID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  AwardName NVARCHAR(255) NOT NULL,
  Year INT NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 15
CREATE TABLE Developers (
  DeveloperID INT PRIMARY KEY IDENTITY(1,1),
  Name NVARCHAR(255) NOT NULL,
  Description TEXT,
  Website NVARCHAR(255)
);
GO

-- 16
CREATE TABLE GameDevelopers (
  GameDeveloperID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  DeveloperID INT NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DeveloperID) REFERENCES Developers (DeveloperID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 17
CREATE TABLE Publishers (
  PublisherID INT PRIMARY KEY IDENTITY(1,1),
  Name NVARCHAR(255) NOT NULL,
  Description TEXT,
  Website NVARCHAR(255)
);
GO

-- 18
CREATE TABLE GamePublishers (
  GamePublisherID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  PublisherID INT NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PublisherID) REFERENCES Publishers (PublisherID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 19
CREATE TABLE Wishlist (
  WishlistID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  GameID INT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 20
CREATE TABLE Cart (
  CartID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  GameID INT NOT NULL,
  Quantity INT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 21
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  OrderDate DATE NOT NULL,

  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE,
);
GO

-- 22
CREATE TABLE OrderItems (
  OrderItemID INT PRIMARY KEY IDENTITY(1,1),
  OrderID INT NOT NULL,
  GameID INT NOT NULL,
  Quantity INT NOT NULL,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0),
  FOREIGN KEY (OrderID) REFERENCES Orders (OrderID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE --- might need to change this
);
GO

--23
CREATE TABLE ExchangeRate (
  ExchangeRateID INT PRIMARY KEY IDENTITY(1,1),
  Currency NVARCHAR(3) NOT NULL UNIQUE,
  [Equal 1 USD] MONEY NOT NULL CHECK ([Equal 1 USD] >= 0)
);
GO

-- TRIGGERS

-- 1
IF OBJECT_ID('Tr_EncryptPasswordsTrigger', 'TR') IS NOT NULL
  DROP TRIGGER Tr_EncryptPasswordsTrigger
GO
CREATE TRIGGER Tr_EncryptPasswordsTrigger 
ON users
INSTEAD OF INSERT
AS
	INSERT INTO users
	SELECT I.username, I.email, CONVERT(NVARCHAR,HASHBYTES('SHA',I.password),2)
  FROM inserted AS I
GO

-- 2
IF OBJECT_ID('Tr_UserBanTrigger', 'TR') IS NOT NULL
  DROP TRIGGER Tr_UserBanTrigger
GO
CREATE TRIGGER Tr_UserBanTrigger 
ON LoginAttempts
AFTER INSERT
AS
BEGIN
  DECLARE @UserID INT, @FailedLoginAttempts INT, @LastFailedLogin DATETIME, @BanStart DATETIME, @BanEnd DATETIME;

  SELECT @UserID = UserID, @FailedLoginAttempts = COUNT(*) FROM LoginAttempts
  WHERE UserID = (SELECT UserID FROM inserted)
  AND Success = 0
  AND Time BETWEEN DATEADD(MINUTE, -5, GETDATE()) AND GETDATE()
  GROUP BY UserID;

  DECLARE @ActiveBans INT
  SELECT @ActiveBans = COUNT(*) FROM UserBans WHERE UserID = @userID AND BanEnd >= GETDATE()

  IF @FailedLoginAttempts >= 5 AND @ActiveBans = 0 
  BEGIN
    SELECT TOP 1 @LastFailedLogin = Time 
    FROM LoginAttempts
    WHERE UserID = @UserID
    AND Success = 0
    ORDER BY Time DESC;

    SET @BanStart = @LastFailedLogin;
    SET @BanEnd = DATEADD(MINUTE, 5, @BanStart);

    INSERT INTO UserBans (UserID, BanStart, BanEnd)
    VALUES (@UserID, @BanStart, @BanEnd);
  END
END;
GO

-- 3
IF OBJECT_ID('Tr_RemoveFromCartAndWishlist', 'TR') IS NOT NULL
  DROP TRIGGER Tr_RemoveFromCartAndWishlist
GO
CREATE TRIGGER Tr_RemoveFromCartAndWishlist
ON OrderItems
AFTER INSERT
AS
BEGIN
    DECLARE @gameID INT, @userID INT
    SELECT @gameID = i.GameID, @userID = o.UserID
    FROM inserted i
    JOIN Orders o ON i.OrderID = o.OrderID
    
    DELETE FROM Cart
    WHERE UserID = @userID AND GameID = @gameID
    
    DELETE FROM Wishlist
    WHERE UserID = @userID AND GameID = @gameID
END
GO
-- 4
IF OBJECT_ID('Tr_AutoGameAwards', 'TR') IS NOT NULL
  DROP TRIGGER Tr_AutoGameAwards
GO
CREATE TRIGGER Tr_AutoGameAwards
ON OrderItems
AFTER INSERT
AS
BEGIN
  DECLARE @GameID INT, @Count INT;

  SELECT @GameID = i.GameID
  FROM inserted i;
  
  DECLARE @AWARD_1_NAME NVARCHAR(255);
  DECLARE @AWARD_1_USER_TRESHOLD INT;
  SET @AWARD_1_NAME= 'Community''s Favorite'
  SET @AWARD_1_USER_TRESHOLD= 10;
  IF @AWARD_1_NAME NOT IN (SELECT AwardName FROM GameAwards WHERE GameID = @GameID)
    BEGIN
    SELECT @Count = COUNT(DISTINCT o.UserID)
    FROM OrderItems oi
    JOIN Orders o ON oi.OrderID = o.OrderID
    WHERE oi.GameID = @GameID;
    
    
    IF @Count >= @AWARD_1_USER_TRESHOLD
    BEGIN
      INSERT INTO GameAwards (GameID, AwardName, Year)
      VALUES (@GameID, @AWARD_1_NAME, YEAR(GETDATE()));
    END
  END
END;
GO
--5
IF OBJECT_ID('Tr_DeleteAwardsOnGenreDelete', 'TR') IS NOT NULL
  DROP TRIGGER Tr_DeleteAwardsOnGenreDelete
GO
CREATE TRIGGER Tr_DeleteAwardsOnGenreDelete
ON GameGenres
AFTER DELETE
AS
BEGIN
  DELETE ga
  FROM GameAwards ga
  JOIN deleted d ON CHARINDEX(d.Genre, ga.AwardName) > 0;
END

GO
-- SAMPLE DATA
INSERT INTO Users (Username, Email, Password)
VALUES
  (N'john_doe', N'john_doe@example.com', N'12345678'),
  (N'jane_doe', N'jane_doe@example.com', N'qwerty'),
  (N'jim_smith', N'jim_smith@example.com', N'passw0rd'),
  (N'sara_lee', N'sara_lee@example.com', N'letmein'),
  (N'tom_jones', N'tom_jones@example.com', N'abc123'),
  (N'jimmy_johns', N'big_jimmy@example.com', N'admin');
-- SELECT * FROM USERS
-- GO;
INSERT INTO Games (Title, LastUpdatedDate, Description, [Price in USD])
VALUES
  (N'The Last of Us Part II', '2023-03-15', 'Survive and explore a post-apocalyptic world filled with danger and complex characters.', 59.99),
  (N'Red Dead Redemption 2', '2022-09-25', 'Live the life of an outlaw in a stunning open world filled with memorable characters and tough choices.', 59.99),
  (N'God of War', '2022-10-01', 'Journey with Kratos and his son Atreus through Norse mythology in this epic adventure.', 39.99),
  (N'Halo 5: Guardians', '2022-06-15', 'Join Master Chief and Spartan Locke in a battle to save the galaxy from a new threat.', 59.99),
  (N'Minecraft', '2022-11-30', 'Unleash your creativity and build anything you can imagine in a blocky, procedurally generated world.', 26.95),
  (N'Cyberpunk 2077', '2022-01-15', 'Experience the gritty world of Night City in this action-packed RPG.', 49.99);
INSERT INTO GameGenres (GameID, Genre)
VALUES
  (1, N'Multiplayer'),
  (1, N'Open-World'),
  (2, N'First-Person'),
  (2, N'Shooter'),
  (3, N'Adventure');
GO

-- 4
INSERT INTO Platforms (Name) 
VALUES 
  (N'PlayStation 4'),
  (N'Xbox One'),
  (N'Nintendo Switch'),
  (N'PC'),
  (N'Mobile');
GO

-- 5
INSERT INTO GamePlatforms (GameID, PlatformID) 
VALUES 
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);
GO

-- 6
INSERT INTO UpcomingGames (GameID, TrailerUrl, ExpectedDeliveryDate)
VALUES
  (1, N'https://www.youtube.com/watch?v=btmN-bWwv0A', '2019-12-01'),
  (3, N'https://www.youtube.com/watch?v=K0u_kAWLJOA', '2018-04-20'),
  (5, N'https://www.youtube.com/watch?v=MmB9b5njVbA', '2011-11-18'),
  (4, N'https://www.youtube.com/watch?v=Rh_NXwqFvHc', '2015-06-13'),
  (2, N'https://www.youtube.com/watch?v=gmA6MrX81z4', '2017-10-18');
GO

-- 7
INSERT INTO PreOrderGames (GameID, PreOrderBonus, PreOrderDiscount)
VALUES
  (1, N'Bonus skin pack', 5.00),
  (4, N'Bonus weapon pack', 10.00),
  (2, N'Bonus story mission', 5.00),
  (3, N'Exclusive in-game item', 5.00),
  (5, N'Bonus skin pack', 5.00);
GO

-- 8
INSERT INTO BetaGames (GameID, BetaStartDate, BetaEndDate)
VALUES
  (1, '2020-05-19', '2020-06-19'),
  (2, '2018-06-01', '2018-07-01'),
  (3, '2018-02-01', '2018-03-15'),
  (4, '2015-08-01', '2015-10-27'),
  (5, '2011-10-01', '2011-11-18');
GO

-- 9
INSERT INTO ReleasedGames (GameID, ReleaseDate)
VALUES
  (1, '2020-06-19'),
  (3, '2018-04-20'),
  (4, '2015-10-27'),
  (5, '2011-11-18'),
  (2, '2018-10-26');
GO

-- 10
INSERT INTO Score (UserID, GameID, Score) 
VALUES 
  (1, 1, 9),
  (2, 1, 8),
  (3, 2, 7),
  (4, 3, 10),
  (5, 4, 8),
  (4, 3, 6),
  (5, 4, 9);
GO

-- 11
INSERT INTO Reviews (UserID, GameID, Review) 
VALUES 
  (1, 1, 'Great game with fantastic graphics and gameplay!'),
  (2, 1, 'Loved the storyline and the character development.'),
  (3, 2, 'Not the best game I have played, but it is still fun.'),
  (4, 3, 'The graphics are impressive, but the gameplay is a bit repetitive.'),
  (5, 4, 'I would recommend this game to anyone looking for a challenging experience.');
GO

-- 12
INSERT INTO GameAwards (GameID, AwardName, Year) 
VALUES 
  (1, N'Best Game of the Year', 2020),
  (2, N'Best RPG of the Year', 2019),
  (3, N'Best Adventure Game of the Year', 2019),
  (4, N'Best Shooter of the Year', 2016),
  (5, N'Best Multiplayer Game of the Year', 2011);

-- 13
INSERT INTO Developers (Name, Description, Website)
VALUES
  (N'Naughty Dog', 'A first-party vIDeo game developer based in Santa Monica, California', N'naughtydog.com'),
  (N'Rockstar Studios', 'A subsIDiary of Rockstar Games based in Edinburgh, Scotland', N'rockstargames.com'),
  (N'Santa Monica Studio', 'A first-party vIDeo game developer based in Santa Monica, California', N'sms.playstation.com'),
  (N'343 Industries', 'An American vIDeo game development studio located in Redmond, Washington', N'343industries.com'),
  (N'Mojang Studios', 'A vIDeo game development studio based in Stockholm, Sweden', N'mojang.com');
GO

-- 14
INSERT INTO GameDevelopers (GameID, DeveloperID) 
VALUES 
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);
GO

-- 15
INSERT INTO Publishers (Name, Description, Website) 
VALUES 
  (N'Electronic Arts', 'Electronic Arts (EA) is a leading publisher and developer of interactive entertainment and vIDeo games.', N'ea.com'),
  (N'Activision Blizzard', 'Activision Blizzard is a leading publisher of interactive entertainment and vIDeo games.', N'activisionblizzard.com'),
  (N'Ubisoft', 'Ubisoft is a leading publisher and developer of vIDeo games and interactive entertainment.', N'ubisoft.com'),
  (N'Take-Two Interactive', 'Take-Two Interactive is a leading publisher of interactive entertainment and vIDeo games.', N'take2games.com'),
  (N'Microsoft', 'Microsoft is a leading technology company that is also involved in the publishing of vIDeo games and interactive entertainment.', N'microsoft.com');
GO

-- 16
INSERT INTO GamePublishers (GameID, PublisherID) 
VALUES 
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);
GO

-- 17
INSERT INTO Wishlist (UserID, GameID) 
VALUES 
  (1, 2),
  (2, 3),
  (3, 4),
  (4, 5),
  (5, 1);
GO

-- 18
INSERT INTO Cart (UserID, GameID, Quantity) 
VALUES 
  (1, 2, 1),
  (2, 3, 2),
  (3, 4, 3),
  (4, 5, 4),
  (5, 1, 5);
GO

-- 19
INSERT INTO Orders (UserID, OrderDate) 
VALUES 
  (6, '2022-07-15'),
  (5, '2022-08-01'),
  (4, '2022-09-15'),
  (3, '2022-12-03'),
  (2, '2022-12-30'),
  (1, '2023-01-07'),
  (2, '2023-02-02');

INSERT INTO OrderItems (OrderID, GameID, Quantity, [Price in USD]) 
VALUES 
  (1, 1, 2, 29.99),
  (1, 2, 1, 59.99),
  (1, 3, 3, 44.97),
  (1, 4, 1, 19.99),
  (1, 5, 2, 29.98),
  (2, 2, 1, 59.99),
  (2, 3, 2, 29.98),
  (2, 5, 1, 14.99),
  (3, 1, 1, 14.99),
  (3, 2, 1, 59.99),
  (3, 3, 1, 14.99),
  (3, 4, 2, 39.98),
  (3, 5, 1, 14.99),
  (4, 1, 1, 14.99),
  (4, 3, 1, 14.99),
  (4, 4, 1, 19.99),
  (4, 5, 1, 14.99),
  (5, 5, 2, 29.98),
  (5, 2, 1, 59.99),
  (5, 4, 2, 39.98),
  (5, 6, 1, 49.99),
  (6, 1, 1, 29.99),
  (7, 1, 1, 29.99),
  (7, 3, 1, 14.99);
  

-- 21
INSERT INTO ExchangeRate (Currency, [Equal 1 USD]) 
VALUES 
  (N'USD', 1.00),
  (N'EUR', 0.95),
  (N'GBP', 0.83),
  (N'JPY', 135.58),
  (N'PLN', 4.47);
GO

--- PROCEDURES

-- 1
IF OBJECT_ID('GetRecommendedGames', 'P') IS NOT NULL
  DROP PROCEDURE GetRecommendedGames
GO
CREATE PROCEDURE GetRecommendedGames (@UserID INT)
  AS
  BEGIN
  WITH UserOrders AS (
    SELECT OrderID
    FROM Orders
    WHERE UserID = @UserID
  ),
  UserGames AS (
    SELECT DISTINCT GameID
    FROM OrderItems
    WHERE OrderID IN (SELECT OrderID FROM UserOrders)
  ),
  MatchingUsers AS (
    SELECT 
      UserID, 
      COUNT(DISTINCT GameID) AS [Matching Games Num]
    FROM OrderItems AS OI
    JOIN Orders AS O
    ON OI.OrderID = O.OrderID
    WHERE 
      GameID IN (SELECT GameID FROM UserGames)
      AND UserID <> @UserID
    GROUP BY UserID
  ), 
  MatchingGames AS (
  SELECT 
      G.GameID,
      G.Title,
      U.[Matching Games Num] ,
      ROW_NUMBER() OVER (PARTITION BY G.Title ORDER BY U.[Matching Games Num] DESC) AS RowNum
    FROM MatchingUsers U
    JOIN Orders AS O ON U.UserID = O.UserID
    JOIN OrderItems AS OI ON O.OrderID = OI.OrderID
    JOIN Games AS G ON OI.GameID = G.GameID
    WHERE U.[Matching Games Num] >= 1
    GROUP BY G.GameID, G.Title, U.[Matching Games Num], U.UserID
  )
  SELECT GameID, Title
  FROM MatchingGames
  WHERE RowNum = 1
  ORDER BY [Matching Games Num] DESC
END;
GO

-- EXEC GetRecommendedGames 4
IF OBJECT_ID('CalculateTotalSales', 'P') IS NOT NULL
  DROP PROCEDURE CalculateTotalSales
GO

-- 2
IF OBJECT_ID('userLogin', 'P') IS NOT NULL
  DROP PROCEDURE userLogin
GO
CREATE PROCEDURE userLogin 
	@userName NVARCHAR(255), 
	@password NVARCHAR(255)
AS
BEGIN
	DECLARE @isAuthenticated BIT = 0
  DECLARE @userID INT
  SELECT @userID = UserID FROM Users WHERE UserName = @userName
  DECLARE @ActiveBans INT
  SELECT @ActiveBans = COUNT(*) FROM UserBans WHERE UserID = @userID AND BanEnd >= GETDATE()
	IF @ActiveBans <> 0
    BEGIN
      SET @isAuthenticated = 0
      DECLARE @BanExpiration DATETIME
      SELECT @BanExpiration = MAX(BanEnd) FROM UserBans WHERE UserID = @userID AND BanEnd >= GETDATE()
      PRINT 'USER ID' + CONVERT(NVARCHAR, @userID) + ' IS BANNED UNTIL ' + CONVERT(NVARCHAR, @BanExpiration)
    END
  ELSE
    BEGIN
      IF EXISTS (SELECT password FROM Users WHERE UserID = @userID)
        BEGIN
          IF (SELECT password FROM Users WHERE UserID = @userID) = CONVERT(NVARCHAR,HASHBYTES('SHA',@password),2)
          BEGIN
            SET @isAuthenticated = 1
        END
    END
  END
	PRINT 'USER ID' + CONVERT(NVARCHAR, @userID) + ' ATTEMPTED TO LOGIN AND THE LOGIN ' + CASE WHEN @isAuthenticated = 1 THEN 'WAS SUCCESSFUL' ELSE 'FAILED' END
	IF @userID IS NOT NULL
    BEGIN
    INSERT INTO LoginAttempts(UserID, Time, Success) 
	VALUES (@userID, GETDATE(), @isAuthenticated)
    END
	RETURN @isAuthenticated
END
GO

-- BEGIN
--   DECLARE @ok BIT
--   EXEC @ok = dbo.userLogin 'jim_smith', 'passw0rd'
--   SELECT IIF (@ok = 1, 'SUCCESSFUL', 'FAILED') AS [Login Attempt]
--   EXEC @ok = dbo.userLogin 'jim_smith', '000000'
--   SELECT IIF (@ok = 1, 'SUCCESSFUL', 'FAILED') AS [Login Attempt]
--   EXEC @ok = dbo.userLogin 'jim_smith', '000000'
--   EXEC @ok = dbo.userLogin 'jim_smith', '000000'
--   EXEC @ok = dbo.userLogin 'jim_smith', '000000'
--   EXEC @ok = dbo.userLogin 'jim_smith', '000000'
--   EXEC @ok = dbo.userLogin 'jim_smith', 'passw0rd'
--   SELECT IIF (@ok = 1, 'SUCCESSFUL', 'FAILED') AS [Login Attempt]
-- SELECT * FROM UserBans
-- END
-- GO

-- 3
CREATE PROCEDURE CalculateTotalSales 
  @StartDate DATE = NULL, 
  @EndDate DATE = NULL, 
  @GameID INT = NULL
AS
BEGIN
  SELECT 
    G.Title AS GameTitle, 
    SUM(OI.Quantity * OI.[Price in USD]) AS TotalSales
  FROM 
    OrderItems OI 
    LEFT JOIN Games G ON OI.GameID = G.GameID
    LEFT JOIN Orders O ON OI.OrderID = O.OrderID
  WHERE 
    (@StartDate IS NULL OR O.OrderDate >= @StartDate)
    AND (@EndDate IS NULL OR O.OrderDate <= @EndDate)
    AND (@GameID IS NULL OR G.GameID = @GameID)
  GROUP BY 
    G.Title
  ORDER BY 
    TotalSales DESC;
END;
GO

-- 4
IF OBJECT_ID('SearchUsers', 'P') IS NOT NULL
  DROP PROCEDURE SearchUsers
GO
CREATE PROCEDURE SearchUsers
  @Username NVARCHAR(255)
AS
  SELECT UserID, Username 
  FROM Users
  WHERE Username LIKE '%' + @Username + '%'
GO

-- EXEC SearchUsers 'jo'
-- GO

-- 5
IF OBJECT_ID('GetBiggestConsumers', 'P') IS NOT NULL
  DROP PROCEDURE GetBiggestConsumers
GO
CREATE PROCEDURE GetBiggestConsumers
  @StartDate DATE = NULL,
  @EndDate DATE = NULL,
  @OrderBy NVARCHAR(20) = 'TotalSpent' -- Sorting by TotalSpent by default
AS
BEGIN
  WITH UserPurchaseInfo AS (
    SELECT
      O.UserID,
      COUNT(DISTINCT OI.GameID) AS GamesBoughtNum,
      SUM(OI.[Price in USD] * OI.Quantity) AS TotalSpent
    FROM
      Orders O
      JOIN OrderItems OI ON O.OrderID = OI.OrderID
    WHERE
      (@StartDate IS NULL OR O.OrderDate >= @StartDate)
      AND (@EndDate IS NULL OR O.OrderDate <= @EndDate)
    GROUP BY
      O.UserID
  )
  SELECT
    U.UserID,
    PI.GamesBoughtNum,
    PI.TotalSpent
  FROM
    UserPurchaseInfo PI
    JOIN Users U ON PI.UserID = U.UserID
  ORDER BY
    CASE
      WHEN @OrderBy = 'TotalSpent' THEN PI.TotalSpent
      WHEN @OrderBy = 'GamesBought' THEN PI.GamesBoughtNum
      ELSE PI.TotalSpent
    END DESC;
END;
GO
-- EXEC GetBiggestConsumers '2022-12-01', '2022-12-31', 'GamesBought';
-- GO

-- 6
IF OBJECT_ID('GetUserPurchaseHistory', 'P') IS NOT NULL
  DROP PROCEDURE GetUserPurchaseHistory
GO
CREATE PROCEDURE GetUserPurchaseHistory
  @UserID INT
AS
BEGIN
  SELECT
    O.OrderID,
    O.OrderDate,
    G.Title,
    OI.[Price in USD] * OI.Quantity AS TotalPrice
  FROM
    Orders O
    JOIN OrderItems OI ON O.OrderID = OI.OrderID
    JOIN Games G ON OI.GameID = G.GameID
  WHERE
    O.UserID = @UserID
  ORDER BY
    O.OrderDate ASC, O.OrderID ASC;
END;
GO

-- EXEC GetUserPurchaseHistory 2
-- GO

--- VIEWS

-- 1
IF OBJECT_ID('GameGenresView', 'V') IS NOT NULL
  DROP VIEW GameGenresView
GO

CREATE VIEW GameGenresView AS
  SELECT GameID, CONVERT(NVARCHAR(MAX), (
    SELECT Genre + ', '
    FROM GameGenres
    WHERE GameID = G.GameID
    FOR XML PATH('')
  ), 1) AS Genres
  FROM GameGenres G
  GROUP BY GameID;
GO

-- 2
IF OBJECT_ID('GameDevelopersAndPublishers', 'V') IS NOT NULL
  DROP VIEW GameDevelopersAndPublishers;
GO

CREATE VIEW GameDevelopersAndPublishers AS
SELECT GameDevelopers.GameID, Developers.Name AS Developers, Publishers.Name AS Publishers
FROM GameDevelopers
JOIN Developers ON GameDevelopers.DeveloperID = Developers.DeveloperID
JOIN GamePublishers ON GameDevelopers.GameID = GamePublishers.GameID
JOIN Publishers ON GamePublishers.PublisherID = Publishers.PublisherID
GROUP BY GameDevelopers.GameID, Developers.Name, Publishers.Name;
GO

-- 3
IF OBJECT_ID('ReleasedGamesWithPublishers', 'V') IS NOT NULL
  DROP VIEW ReleasedGamesWithPublishers
GO

CREATE VIEW ReleasedGamesWithPublishers AS
SELECT R.GameID, G.Title AS GameTitle, P.Name AS PublisherName, R.ReleaseDate
FROM ReleasedGames R
JOIN Games G ON R.GameID = G.GameID
JOIN GamePublishers GP ON G.GameID = GP.GameID
JOIN Publishers P ON GP.PublisherID = P.PublisherID;
GO

-- 4
IF OBJECT_ID('TopRatedGames', 'V') IS NOT NULL
  DROP VIEW TopRatedGames
GO
CREATE VIEW TopRatedGames AS
  SELECT TOP 100 PERCENT G.GameID, G.Title, AVG(S.Score) AS [Average Score], COUNT(R.GameID) AS [Number of Reviews]
  FROM Games AS G
  LEFT JOIN Score AS S 
  ON G.GameID = S.GameID
  LEFT JOIN Reviews AS R
  ON G.GameID = R.GameID
  GROUP BY 
    G.GameID, 
    G.Title
  ORDER BY 
    [Average Score] DESC,
    [Number of Reviews] DESC; 
GO


-- 5
IF OBJECT_ID('TopSellingGames', 'V') IS NOT NULL
  DROP VIEW TopSellingGames
GO
CREATE VIEW TopSellingGames AS
SELECT TOP 100 PERCENT G.GameID, G.Title, SUM(OI.[Price in USD] * OI.Quantity) AS TotalRevenue
FROM Games G
JOIN OrderItems OI ON G.GameID = OI.GameID
GROUP BY G.GameID, G.Title
ORDER BY TotalRevenue DESC;
GO

-- 6
IF OBJECT_ID('MostReviewingUsers', 'V') IS NOT NULL
  DROP VIEW MostReviewingUsers
GO
CREATE VIEW MostReviewingUsers AS
SELECT TOP 100 PERCENT U.Username, COUNT(*) AS NumberOfReviews
FROM Users U
JOIN Reviews R ON U.UserID = R.UserID
GROUP BY U.Username
ORDER BY NumberOfReviews DESC;
GO

--- FUNCTIONS

-- 1

-- 2
IF OBJECT_ID('GetGamesByGenre', 'IF') IS NOT NULL
  DROP FUNCTION GetGamesByGenre
GO

CREATE FUNCTION GetGamesByGenre
(
  @Genre NVARCHAR(255)
)
RETURNS TABLE
AS 
RETURN (
  SELECT G.GameID, G.Title, GG.Genre
  FROM Games G
  JOIN GameGenres GG ON G.GameID = GG.GameID
  WHERE GG.Genre = @Genre
);
GO

-- SELECT * FROM dbo.GetGamesByGenre(N'First-Person')
-- GO

-- 3
IF OBJECT_ID('GetGamesByPlatform', 'IF') IS NOT NULL
  DROP FUNCTION GetGamesByPlatform
GO

CREATE FUNCTION GetGamesByPlatform
(
  @Platform NVARCHAR(255)
)
RETURNS TABLE
AS
RETURN (
  SELECT G.*
  FROM Games G
  JOIN GamePlatforms GP ON G.GameID = GP.GameID
  JOIN Platforms P ON GP.PlatformID = P.PlatformID
  WHERE P.Name = @Platform
);
GO

-- 4
IF OBJECT_ID('DeveloperGames', 'TF') IS NOT NULL
  DROP FUNCTION DeveloperGames
GO

CREATE FUNCTION DeveloperGames
(
  @Name NVARCHAR(255)
)
RETURNS @Games TABLE (GameID INT, Title NVARCHAR(255))
AS
BEGIN
  INSERT INTO @Games
  SELECT GameDevelopers.GameID, Games.Title
  FROM Developers
  JOIN GameDevelopers ON Developers.DeveloperID = GameDevelopers.DeveloperID
  JOIN Games ON Games.GameID = GameDevelopers.GameID
  WHERE Developers.Name = @Name
  RETURN
END;
GO

-- 5
IF OBJECT_ID('PublisherGames', 'TF') IS NOT NULL
  DROP FUNCTION PublisherGames
GO

CREATE FUNCTION PublisherGames
(
  @Name NVARCHAR(255)
)
RETURNS @Games TABLE (GameID INT, Title NVARCHAR(255))
AS
BEGIN
  INSERT INTO @Games
  SELECT GamePublishers.GameID, Games.Title
  FROM Publishers
  JOIN GamePublishers ON Publishers.PublisherID = GamePublishers.PublisherID
  JOIN Games ON Games.GameID = GamePublishers.GameID
  WHERE Publishers.Name = @Name
  RETURN
END;
GO
-- 6
IF OBJECT_ID('CalculateTotalPrice', 'FN') IS NOT NULL
  DROP FUNCTION CalculateTotalPrice
GO

CREATE FUNCTION CalculateTotalPrice
(
  @UserID INT
)
RETURNS MONEY
AS
BEGIN
    DECLARE @TotalPrice MONEY;
    SELECT @TotalPrice = SUM(C.Quantity * G.[Price in USD])
    FROM Cart C
    JOIN Games G ON C.GameID = G.GameID
    WHERE C.UserID = @UserID;
    RETURN @TotalPrice;
END;
GO
-- 7
IF OBJECT_ID('CalculateTotalRevenue', 'FN') IS NOT NULL
  DROP FUNCTION CalculateTotalRevenue
GO

CREATE FUNCTION CalculateTotalRevenue ()
RETURNS MONEY
AS
BEGIN
  DECLARE @TotalRevenue MONEY
  SELECT @TotalRevenue = SUM(OI.Quantity * OI.[Price in USD])
  FROM OrderItems OI
  LEFT JOIN Games G ON OI.GameID = G.GameID
  LEFT JOIN Orders O ON OI.OrderID = O.OrderID
  WHERE O.OrderDate IS NOT NULL
  
  RETURN @TotalRevenue
END;
GO
-- SELECT dbo.CalculateTotalRevenue()
-- GO

-- 8
IF OBJECT_ID('ConvertPrice', 'FN') IS NOT NULL
  DROP FUNCTION ConvertPrice
GO

CREATE FUNCTION ConvertPrice
(
  @GameID INT,
  @Currency CHAR(3)
)
RETURNS MONEY
AS
BEGIN
  DECLARE @Price MONEY = 0
  DECLARE @ExchangeRate MONEY = 0
  SET @Price = (SELECT [Price in USD] FROM Games WHERE @GameID = GameID)
		SET @ExchangeRate = (SELECT [Equal 1 USD] FROM [ExchangeRate] WHERE @Currency = [Currency])
  RETURN ROUND((@Price * @ExchangeRate), 2)
END;
GO
-- SELECT dbo.ConvertPrice(1, 'PLN')
-- GO

-- TEST Tr_RemoveFromCartAndWishlist
-- BEGIN
-- INSERT OrderItems (OrderID, GameID, Quantity, [Price in USD]) 
-- VALUES (6, 2, 1, 1)
-- SELECT * FROM Wishlist WHERE UserID = 1
-- SELECT * FROM Cart WHERE UserID = 1
-- END
-- GO

-- END

-- TEST Tr_AutoGameAward
-- BEGIN
-- BEGIN
--   DELETE FROM Users WHERE 1=1;
--   DELETE FROM Orders WHERE 1=1;
--   DELETE FROM OrderItems WHERE 1=1;
-- END
-- INSERT INTO Users (Username, Email, Password)
-- VALUES 
-- ('user1', 'user1@example.com', 'password1'),
-- ('user2', 'user2@example.com', 'password2'),
-- ('user3', 'user3@example.com', 'password3'),
-- ('user4', 'user4@example.com', 'password4'),
-- ('user5', 'user5@example.com', 'password5'),
-- ('user6', 'user6@example.com', 'password6'),
-- ('user7', 'user7@example.com', 'password7'),
-- ('user8', 'user8@example.com', 'password8'),
-- ('user9', 'user9@example.com', 'password9'),
-- ('user10', 'user10@example.com', 'password10');
-- -- create orders for each user
-- BEGIN
--   INSERT INTO Orders (UserID, OrderDate) 
--   VALUES 
--     ((SELECT UserID FROM Users WHERE Username = 'user1'), '2023-01-20'),
--     ((SELECT UserID FROM Users WHERE Username = 'user2'), '2023-01-20'),
--     ((SELECT UserID FROM Users WHERE Username = 'user3'), '2023-01-20'),
--     ((SELECT UserID FROM Users WHERE Username = 'user4'), '2023-01-20'),
--     ((SELECT UserID FROM Users WHERE Username = 'user5'), '2023-01-20'),
--     ((SELECT UserID FROM Users WHERE Username = 'user6'), '2023-01-20'),
--     ((SELECT UserID FROM Users WHERE Username = 'user7'), '2023-01-20'),
--     ((SELECT UserID FROM Users WHERE Username = 'user8'), '2023-01-20'),
--     ((SELECT UserID FROM Users WHERE Username = 'user9'), '2023-01-20'),
--     ((SELECT UserID FROM Users WHERE Username = 'user10'), '2023-01-20')
-- END
-- BEGIN
--   INSERT INTO OrderItems (OrderID, GameID, Quantity, [Price in USD])
-- SELECT O.OrderID, 5, 1, G.[Price in USD]
-- FROM Orders O
-- JOIN Users u ON O.UserID = u.UserID
-- JOIN Games G ON G.GameID = 5
-- END

-- -- SELECT * FROM OrderItems WHERE GameID = 5
-- SELECT G. Title, GA.AwardName, GA.[Year]
-- FROM GameAwards GA
-- JOIN Games G ON g.GameID = GA.GameID
-- WHERE GA.GameID = 5

-- END
GO

-- TEST Tr_Tr_DeleteAwardsOnGenreDelete
-- BEGIN
--   SELECT AwardName FROM GameAwards
--   BEGIN
--     DELETE FROM GameGenres 
--     WHERE Genre IN ('Shooter', 'Adventure')
--   END
--   SELECT AwardName FROM GameAwards
-- END
