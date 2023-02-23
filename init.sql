--- DATABASE

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Steam')
  CREATE DATABASE Steam
GO

USE Steam;

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

IF OBJECT_ID('Users', 'U') IS NOT NULL
  DROP TABLE Users
GO

-- 1
CREATE TABLE Users (
  UserId INT PRIMARY KEY IDENTITY(1,1),
  Username VARCHAR(255) NOT NULL,
  Email VARCHAR(255) NOT NULL UNIQUE,
  Password VARCHAR(255) NOT NULL
);
GO

-- 2
CREATE TABLE Games (
  GameId INT PRIMARY KEY IDENTITY(1,1),
  Title VARCHAR(255) NOT NULL,
  LastUpdatedDate DATE NOT NULL,
  Description TEXT,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0)
);
GO

-- 3
CREATE TABLE GameGenres (
  GameGenreId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  Genre VARCHAR(255) NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 4
CREATE TABLE Platforms (
  PlatformId INT PRIMARY KEY IDENTITY(1,1),
  Name VARCHAR(255) NOT NULL
);
GO


-- 5
CREATE TABLE GamePlatforms (
  GamePlatformId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  PlatformId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PlatformId) REFERENCES Platforms (PlatformId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 6
CREATE TABLE UpcomingGames (
  UpcomingGameId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  TrailerUrl VARCHAR(255),
  ExpectedDeliveryDate DATE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 7
CREATE TABLE PreOrderGames (
  PreOrderGameId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  PreOrderBonus VARCHAR(255),
  PreOrderDiscount DECIMAL(2),
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 8
CREATE TABLE BetaGames (
  BetaGameId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  BetaStartDate DATE NOT NULL,
  BetaEndDate DATE NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 9
CREATE TABLE ReleasedGames (
  ReleasedGameId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  ReleaseDate DATE NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 10
CREATE TABLE Score (
  ScoreId INT PRIMARY KEY IDENTITY(1,1),
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Score INT NOT NULL CHECK (Score BETWEEN 1 AND 10),
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 11
CREATE TABLE Reviews (
  ReviewId INT PRIMARY KEY IDENTITY(1,1),
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Review TEXT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 12
CREATE TABLE GameAwards (
  GameAwardsId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  AwardName VARCHAR(255) NOT NULL,
  Year INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 13
CREATE TABLE Developers (
  DeveloperId INT PRIMARY KEY IDENTITY(1,1),
  Name VARCHAR(255) NOT NULL,
  Description TEXT,
  Website VARCHAR(255)
);
GO


-- 14
CREATE TABLE GameDevelopers (
  GameDeveloperId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  DeveloperId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DeveloperId) REFERENCES Developers (DeveloperId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 15
CREATE TABLE Publishers (
  PublisherId INT PRIMARY KEY IDENTITY(1,1),
  Name VARCHAR(255) NOT NULL,
  Description TEXT,
  Website VARCHAR(255)
);
GO


-- 16
CREATE TABLE GamePublishers (
  GamePublisherId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  PublisherId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PublisherId) REFERENCES Publishers (PublisherId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 17
CREATE TABLE Wishlist (
  WishlistId INT PRIMARY KEY IDENTITY(1,1),
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 18
CREATE TABLE Cart (
  CartId INT PRIMARY KEY IDENTITY(1,1),
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Quantity INT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 19
CREATE TABLE Orders (
  OrderId INT PRIMARY KEY IDENTITY(1,1),
  UserId INT NOT NULL,
  OrderDate DATE NOT NULL,

  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 20
CREATE TABLE OrderItems (
  OrderItemId INT PRIMARY KEY IDENTITY(1,1),
  OrderId INT NOT NULL,
  GameId INT NOT NULL,
  Quantity INT NOT NULL,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0),
  FOREIGN KEY (OrderId) REFERENCES Orders (OrderId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

--21 
CREATE TABLE ExchangeRate (
  ExchangeRateId INT PRIMARY KEY IDENTITY(1,1),
  Currency NVARCHAR(3) NOT NULL,
  [Equal 1 USD] MONEY NOT NULL CHECK ([Equal 1 USD] >= 0)
);
GO

--- VIEWS











-- 1
IF OBJECT_ID('GameGenresView', 'V') IS NOT NULL
  DROP VIEW GameGenresView
GO

CREATE VIEW GameGenresView AS
  SELECT GameId, CONVERT(NVARCHAR(MAX), (
    SELECT Genre + ', '
    FROM GameGenres
    WHERE GameId = G.GameId
    FOR XML PATH('')
  ), 1) AS Genres
  FROM GameGenres G
  GROUP BY GameId;
GO

-- 2
IF OBJECT_ID('GameDevelopersAndPublishers', 'V') IS NOT NULL
  DROP VIEW GameDevelopersAndPublishers;
GO

CREATE VIEW GameDevelopersAndPublishers AS
SELECT GameDevelopers.GameId, Developers.Name AS Developers, Publishers.Name AS Publishers
FROM GameDevelopers
JOIN Developers ON GameDevelopers.DeveloperId = Developers.DeveloperId
JOIN GamePublishers ON GameDevelopers.GameId = GamePublishers.GameId
JOIN Publishers ON GamePublishers.PublisherId = Publishers.PublisherId
GROUP BY GameDevelopers.GameId, Developers.Name, Publishers.Name;
GO

-- 3
IF OBJECT_ID('ReleasedGamesWithPublishers', 'V') IS NOT NULL
  DROP VIEW ReleasedGamesWithPublishers
GO

CREATE VIEW ReleasedGamesWithPublishers AS
SELECT R.GameId, G.Title AS GameTitle, P.Name AS PublisherName, R.ReleaseDate
FROM ReleasedGames R
JOIN Games G ON R.GameId = G.GameId
JOIN GamePublishers GP ON G.GameId = GP.GameId
JOIN Publishers P ON GP.PublisherId = P.PublisherId;
GO

-- 4
IF OBJECT_ID('TopRatedGames', 'V') IS NOT NULL
  DROP VIEW TopRatedGames
GO
CREATE VIEW TopRatedGames AS
  SELECT TOP 100 PERCENT G.GameID, G.Title, AVG(S.Score) AS [Average Score], COUNT(R.GameId) AS [Number of Reviews]
  FROM Games AS G
  LEFT JOIN Score AS S 
  ON G.GameID = S.GameID
  LEFT JOIN Reviews AS R
  ON G.GameID = R.GameID
  GROUP BY 
    G.GameId, 
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
SELECT TOP 100 PERCENT G.GameId, G.Title, SUM(OI.[Price in USD] * OI.Quantity) AS TotalRevenue
FROM Games G
JOIN OrderItems OI ON G.GameId = OI.GameId
GROUP BY G.GameId, G.Title
ORDER BY TotalRevenue DESC;
GO

-- 6
IF OBJECT_ID('MostReviewingUsers', 'V') IS NOT NULL
  DROP VIEW MostReviewingUsers
GO
CREATE VIEW MostReviewingUsers AS
SELECT TOP 100 PERCENT U.Username, COUNT(*) AS NumberOfReviews
FROM Users U
JOIN Reviews R ON U.UserId = R.UserId
GROUP BY U.Username
ORDER BY NumberOfReviews DESC;
GO

--- FUNCTIONS

-- 1
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
  SELECT G.*
  FROM Games G
  JOIN GameGenres GG ON G.GameId = GG.GameId
  WHERE GG.Genre = @Genre
);
GO

-- 2
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
  JOIN GamePlatforms GP ON G.GameId = GP.GameId
  JOIN Platforms P ON GP.PlatformId = P.PlatformId
  WHERE P.Name = @Platform
);
GO

-- 3
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
  SELECT GameDevelopers.GameId, Games.Title
  FROM Developers
  JOIN GameDevelopers ON Developers.DeveloperId = GameDevelopers.DeveloperID
  JOIN Games ON Games.GameId = GameDevelopers.GameId
  WHERE Developers.Name = @Name
  RETURN
END;
GO

-- 4
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
  SELECT GamePublishers.GameId, Games.Title
  FROM Publishers
  JOIN GamePublishers ON Publishers.PublisherId = GamePublishers.PublisherId
  JOIN Games ON Games.GameId = GamePublishers.GameId
  WHERE Publishers.Name = @Name
  RETURN
END;
GO

IF OBJECT_ID('CalculateTotalPrice', 'FN') IS NOT NULL
  DROP FUNCTION CalculateTotalPrice
GO

CREATE FUNCTION CalculateTotalPrice
(
  @UserId INT
)
RETURNS MONEY
AS
BEGIN
    DECLARE @TotalPrice MONEY;
    SELECT @TotalPrice = SUM(C.Quantity * G.[Price in USD])
    FROM Cart C
    JOIN Games G ON C.GameId = G.GameId
    WHERE C.UserId = @UserId;
    RETURN @TotalPrice;
END;
GO

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
  LEFT JOIN Games G ON OI.GameId = G.GameId
  LEFT JOIN Orders O ON OI.OrderId = O.OrderId
  WHERE O.OrderDate IS NOT NULL
  
  RETURN @TotalRevenue
END;
GO

IF OBJECT_ID('HowMuch', 'FN') IS NOT NULL
  DROP FUNCTION HowMuch
GO

CREATE FUNCTION HowMuch
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

-- 5

-- Sample data
INSERT INTO Users (Username, Email, Password)
VALUES
  ('john_doe', 'john_doe@example.com', 'password1'),
  ('jane_doe', 'jane_doe@example.com', 'password2'),
  ('jim_smith', 'jim_smith@example.com', 'password3'),
  ('sara_lee', 'sara_lee@example.com', 'password4'),
  ('tom_jones', 'tom_jones@example.com', 'password5'),
  ('jimmy_johns', 'big_jimmy@example.com', 'password6');
  
INSERT INTO Games (Title, LastUpdatedDate, Description, [Price in USD])
VALUES
  ('The Last of Us Part II', '2023-03-15', 'Survive and explore a post-apocalyptic world filled with danger and complex characters.', 59.99),
  ('Red Dead Redemption 2', '2022-09-25', 'Live the life of an outlaw in a stunning open world filled with memorable characters and tough choices.', 59.99),
  ('God of War', '2022-10-01', 'Journey with Kratos and his son Atreus through Norse mythology in this epic adventure.', 39.99),
  ('Halo 5: Guardians', '2022-06-15', 'Join Master Chief and Spartan Locke in a battle to save the galaxy from a new threat.', 59.99),
  ('Minecraft', '2022-11-30', 'Unleash your creativity and build anything you can imagine in a blocky, procedurally generated world.', 26.95),
  ('Cyberpunk 2077', '2022-01-15', 'Experience the gritty world of Night City in this action-packed RPG.', 49.99);

INSERT INTO GameGenres (GameId, Genre)
VALUES
  (1, 'Multiplayer'),
  (1, 'Open-World'),
  (2, 'First-Person'),
  (2, 'Shooter'),
  (3, 'Adventure');
INSERT INTO Platforms (Name) 
VALUES 
  ('PlayStation 4'),
  ('Xbox One'),
  ('Nintendo Switch'),
  ('PC'),
  ('Mobile');
INSERT INTO GamePlatforms (GameId, PlatformId) 
VALUES 
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);
INSERT INTO UpcomingGames (GameId, TrailerUrl, ExpectedDeliveryDate)
VALUES
  (1, 'https://www.youtube.com/watch?v=btmN-bWwv0A', '2019-12-01'),
  (3, 'https://www.youtube.com/watch?v=K0u_kAWLJOA', '2018-04-20'),
  (5, 'https://www.youtube.com/watch?v=MmB9b5njVbA', '2011-11-18'),
  (4, 'https://www.youtube.com/watch?v=Rh_NXwqFvHc', '2015-06-13'),
  (2, 'https://www.youtube.com/watch?v=gmA6MrX81z4', '2017-10-18');
INSERT INTO PreOrderGames (GameId, PreOrderBonus, PreOrderDiscount)
VALUES
  (1, 'Bonus skin pack', 5.00),
  (4, 'Bonus weapon pack', 10.00),
  (2, 'Bonus story mission', 5.00),
  (3, 'Exclusive in-game item', 5.00),
  (5, 'Bonus skin pack', 5.00);
INSERT INTO BetaGames (GameId, BetaStartDate, BetaEndDate)
VALUES
  (1, '2020-05-19', '2020-06-19'),
  (2, '2018-06-01', '2018-07-01'),
  (3, '2018-02-01', '2018-03-15'),
  (4, '2015-08-01', '2015-10-27'),
  (5, '2011-10-01', '2011-11-18');
INSERT INTO ReleasedGames (GameId, ReleaseDate)
VALUES
  (1, '2020-06-19'),
  (3, '2018-04-20'),
  (4, '2015-10-27'),
  (5, '2011-11-18'),
  (2, '2018-10-26');
INSERT INTO Score (UserId, GameId, Score) 
VALUES 
  (1, 1, 9),
  (2, 1, 8),
  (3, 2, 7),
  (4, 3, 10),
  (5, 4, 8),
  (4, 3, 6),
  (5, 4, 9);

INSERT INTO Reviews (UserId, GameId, Review) 
VALUES 
  (1, 1, 'Great game with fantastic graphics and gameplay!'),
  (2, 1, 'Loved the storyline and the character development.'),
  (3, 2, 'Not the best game I have played, but it is still fun.'),
  (4, 3, 'The graphics are impressive, but the gameplay is a bit repetitive.'),
  (5, 4, 'I would recommend this game to anyone looking for a challenging experience.');

INSERT INTO GameAwards (GameId, AwardName, Year) 
VALUES 
  (1, 'Best Game of the Year', 2020),
  (2, 'Best RPG of the Year', 2019),
  (3, 'Best Adventure Game of the Year', 2019),
  (4, 'Best Shooter of the Year', 2016),
  (5, 'Best Multiplayer Game of the Year', 2011);

INSERT INTO Developers (Name, Description, Website)
VALUES
  ('Naughty Dog', 'A first-party video game developer based in Santa Monica, California', 'naughtydog.com'),
  ('Rockstar Studios', 'A subsidiary of Rockstar Games based in Edinburgh, Scotland', 'rockstargames.com'),
  ('Santa Monica Studio', 'A first-party video game developer based in Santa Monica, California', 'sms.playstation.com'),
  ('343 Industries', 'An American video game development studio located in Redmond, Washington', '343industries.com'),
  ('Mojang Studios', 'A video game development studio based in Stockholm, Sweden', 'mojang.com');

INSERT INTO GameDevelopers (GameId, DeveloperId) 
VALUES 
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);

INSERT INTO Publishers (Name, Description, Website) 
VALUES 
  ('Electronic Arts', 'Electronic Arts (EA) is a leading publisher and developer of interactive entertainment and video games.', 'ea.com'),
  ('Activision Blizzard', 'Activision Blizzard is a leading publisher of interactive entertainment and video games.', 'activisionblizzard.com'),
  ('Ubisoft', 'Ubisoft is a leading publisher and developer of video games and interactive entertainment.', 'ubisoft.com'),
  ('Take-Two Interactive', 'Take-Two Interactive is a leading publisher of interactive entertainment and video games.', 'take2games.com'),
  ('Microsoft', 'Microsoft is a leading technology company that is also involved in the publishing of video games and interactive entertainment.', 'microsoft.com');
GO


INSERT INTO GamePublishers (GameId, PublisherId) 
VALUES 
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5);

INSERT INTO Wishlist (UserId, GameId) 
VALUES 
  (1, 2),
  (2, 3),
  (3, 4),
  (4, 5),
  (5, 1);
INSERT INTO Cart (UserId, GameId, Quantity) 
VALUES 
  (1, 2, 1),
  (2, 3, 2),
  (3, 4, 3),
  (4, 5, 4),
  (5, 1, 5);

INSERT INTO Orders (UserId, OrderDate) 
VALUES 
  (1, '2023-01-07'),
  (2, '2022-12-30'),
  (3, '2022-12-03'),
  (4, '2022-09-15'),
  (5, '2022-08-01'),
  (6, '2022-07-15');

INSERT INTO OrderItems (OrderId, GameId, Quantity, [Price in USD]) 
VALUES 
  (1, 1, 2, 29.99),
  (1, 2, 1, 9.99),
  (1, 3, 3, 44.97),
  (1, 4, 1, 19.99),
  (1, 5, 2, 29.98),
  (2, 2, 1, 9.99),
  (2, 3, 2, 29.98),
  (2, 5, 1, 14.99),
  (3, 1, 1, 14.99),
  (3, 2, 1, 9.99),
  (3, 3, 1, 14.99),
  (3, 4, 2, 39.98),
  (3, 5, 1, 14.99),
  (4, 1, 1, 14.99),
  (4, 3, 1, 14.99),
  (4, 4, 1, 19.99),
  (4, 5, 1, 14.99),
  (5, 1, 2, 29.98),
  (5, 2, 1, 9.99),
  (5, 4, 2, 39.98),
  (5, 6, 1, 49.99);
  

INSERT INTO ExchangeRate (Currency, [Equal 1 USD]) 
VALUES 
  ('USD', 1.00),
  ('EUR', 0.93),
  ('GBP', 0.83),
  ('JPY', 134.15),
  ('PLN', 4.45);
GO












IF OBJECT_ID('GetRecommendedGames', 'P') IS NOT NULL
  DROP PROCEDURE GetRecommendedGames
GO
CREATE PROCEDURE GetRecommendedGames (@UserId INT)
  AS
  BEGIN
  WITH UserOrders AS (
    SELECT OrderId
    FROM Orders
    WHERE UserId = @UserId
  ),
  UserGames AS (
    SELECT DISTINCT GameId
    FROM OrderItems
    WHERE OrderId IN (SELECT OrderId FROM UserOrders)
  ),
  MatchingUsers AS (
    SELECT 
      UserId, 
      COUNT(DISTINCT GameId) AS [Matching Games Num]
    FROM OrderItems AS OI
    JOIN Orders AS O
    ON OI.OrderId = O.OrderId
    WHERE 
      GameId IN (SELECT GameId FROM UserGames)
      AND UserId <> @UserId
    GROUP BY UserId
  ), 
  MatchingGames AS (
  SELECT 
      G.GameID,
      G.Title,
      U.[Matching Games Num] ,
      ROW_NUMBER() OVER (PARTITION BY G.Title ORDER BY U.[Matching Games Num] DESC) AS RowNum
    FROM MatchingUsers U
    JOIN Orders AS O ON U.UserId = O.UserId
    JOIN OrderItems AS OI ON O.OrderId = OI.OrderId
    JOIN Games AS G ON OI.GameId = G.GameId
    WHERE U.[Matching Games Num] >= 1
    GROUP BY G.GameId, G.Title, U.[Matching Games Num], U.UserId
  )
  SELECT GameId, Title
  FROM MatchingGames
  WHERE RowNum = 1
  ORDER BY [Matching Games Num] DESC
END;
GO

-- EXEC GetRecommendedGames 4
IF OBJECT_ID('CalculateTotalSales', 'P') IS NOT NULL
  DROP PROCEDURE CalculateTotalSales
GO

CREATE PROCEDURE CalculateTotalSales 
  @StartDate DATE = NULL, 
  @EndDate DATE = NULL, 
  @GameId INT = NULL
AS
BEGIN
  SELECT 
    G.Title AS GameTitle, 
    SUM(OI.Quantity * OI.[Price in USD]) AS TotalSales
  FROM 
    OrderItems OI 
    LEFT JOIN Games G ON OI.GameId = G.GameId
    LEFT JOIN Orders O ON OI.OrderId = O.OrderId
  WHERE 
    (@StartDate IS NULL OR O.OrderDate >= @StartDate)
    AND (@EndDate IS NULL OR O.OrderDate <= @EndDate)
    AND (@GameId IS NULL OR G.GameId = @GameId)
  GROUP BY 
    G.Title
  ORDER BY 
    TotalSales DESC;
END;
GO
-- EXEC GetTopRatedGames 10
-- GO

-- EXEC CalculateTotalSales 
-- GO

-- SELECT dbo.CalculateTotalRevenue()
-- GO

IF OBJECT_ID('SearchUsers', 'P') IS NOT NULL
  DROP PROCEDURE SearchUsers
GO
CREATE PROCEDURE SearchUsers
  @Username VARCHAR(255)
AS
  SELECT UserID, Username 
  FROM Users
  WHERE Username LIKE '%'+@Username+'%'
GO
-- EXEC SearchUsers 'jo'
-- GO
IF OBJECT_ID('GetBiggestConsumers', 'P') IS NOT NULL
  DROP PROCEDURE GetBiggestConsumers
GO
CREATE PROCEDURE GetBiggestConsumers
  @StartDate DATE = NULL,
  @EndDate DATE = NULL,
  @OrderBy VARCHAR(20) = 'TotalSpent' -- Default to sorting by TotalSpent in descending order
AS
BEGIN
  WITH UserPurchaseInfo AS (
    SELECT
      O.UserId,
      COUNT(DISTINCT OI.GameID) AS GamesBoughtNum,
      SUM(OI.[Price in USD] * OI.Quantity) AS TotalSpent
    FROM
      Orders O
      JOIN OrderItems OI ON O.OrderId = OI.OrderId
    WHERE
      (@StartDate IS NULL OR O.OrderDate >= @StartDate)
      AND (@EndDate IS NULL OR O.OrderDate <= @EndDate)
    GROUP BY
      O.UserId
  )
  SELECT
    U.UserId,
    PI.GamesBoughtNum,
    PI.TotalSpent
  FROM
    UserPurchaseInfo PI
    JOIN Users U ON PI.UserId = U.UserId
  ORDER BY
    CASE
      WHEN @OrderBy = 'TotalSpent' THEN PI.TotalSpent
      WHEN @OrderBy = 'GamesBought' THEN PI.GamesBoughtNum
    END DESC;
END;
GO

-- EXEC GetBiggestConsumers '2022-12-01', '2022-12-31', 'GamesBought';
-- GO

