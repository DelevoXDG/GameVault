--- DATABASE

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Steam')
BEGIN
  CREATE DATABASE Steam
END
GO

USE Steam;

--- TABLES

IF OBJECT_ID('ExchangeRate', 'U') IS NOT NULL
BEGIN
  DROP TABLE ExchangeRate
END
GO

IF OBJECT_ID('OrderItems', 'U') IS NOT NULL
BEGIN
  DROP TABLE OrderItems
END
GO

IF OBJECT_ID('Orders', 'U') IS NOT NULL
BEGIN
  DROP TABLE Orders
END
GO

IF OBJECT_ID('Cart', 'U') IS NOT NULL
BEGIN
  DROP TABLE Cart
END
GO

IF OBJECT_ID('Wishlist', 'U') IS NOT NULL
BEGIN
  DROP TABLE Wishlist
END
GO

IF OBJECT_ID('GamePublishers', 'U') IS NOT NULL
BEGIN
  DROP TABLE GamePublishers
END
GO

IF OBJECT_ID('Publishers', 'U') IS NOT NULL
BEGIN
  DROP TABLE Publishers
END
GO

IF OBJECT_ID('GameDevelopers', 'U') IS NOT NULL
BEGIN
  DROP TABLE GameDevelopers
END
GO

IF OBJECT_ID('Developers', 'U') IS NOT NULL
BEGIN
  DROP TABLE Developers
END
GO

IF OBJECT_ID('GameAwards', 'U') IS NOT NULL
BEGIN
  DROP TABLE GameAwards
END
GO

IF OBJECT_ID('Reviews', 'U') IS NOT NULL
BEGIN
  DROP TABLE Reviews
END
GO

IF OBJECT_ID('Score', 'U') IS NOT NULL
BEGIN
  DROP TABLE Score
END
GO

IF OBJECT_ID('ReleasedGames', 'U') IS NOT NULL
BEGIN
  DROP TABLE ReleasedGames
END
GO

IF OBJECT_ID('BetaGames', 'U') IS NOT NULL
BEGIN
  DROP TABLE BetaGames
END
GO

IF OBJECT_ID('PreOrderGames', 'U') IS NOT NULL
BEGIN
  DROP TABLE PreOrderGames
END
GO

IF OBJECT_ID('UpcomingGames', 'U') IS NOT NULL
BEGIN
  DROP TABLE UpcomingGames
END
GO

IF OBJECT_ID('GamePlatforms', 'U') IS NOT NULL
BEGIN
  DROP TABLE GamePlatforms
END
GO

IF OBJECT_ID('Platforms', 'U') IS NOT NULL
BEGIN
  DROP TABLE Platforms
END
GO

IF OBJECT_ID('GameGenres', 'U') IS NOT NULL
BEGIN
  DROP TABLE GameGenres
END
GO

IF OBJECT_ID('Games', 'U') IS NOT NULL
BEGIN
  DROP TABLE Games
END
GO

IF OBJECT_ID('Users', 'U') IS NOT NULL
BEGIN
  DROP TABLE Users
END
GO

-- 1
CREATE TABLE Users (
  UserId INT PRIMARY KEY,
  Username NVARCHAR(255) NOT NULL,
  Email NVARCHAR(255) NOT NULL UNIQUE,
  Password NVARCHAR(255) NOT NULL
);
GO

-- 2
CREATE TABLE Games (
  GameId INT PRIMARY KEY,
  Title NVARCHAR(255) NOT NULL,
  LastUpdatedDate DATE NOT NULL,
  Description TEXT,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0)
);
GO

-- 3
CREATE TABLE GameGenres (
  GameGenreId INT PRIMARY KEY,
  GameId INT NOT NULL,
  Genre NVARCHAR(255) NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 4
CREATE TABLE Platforms (
  PlatformId INT PRIMARY KEY,
  Name NVARCHAR(255) NOT NULL
);
GO

-- 5
CREATE TABLE GamePlatforms (
  GamePlatformId INT PRIMARY KEY,
  GameId INT NOT NULL,
  PlatformId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PlatformId) REFERENCES Platforms (PlatformId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 6
CREATE TABLE UpcomingGames (
  UpcomingGameId INT PRIMARY KEY,
  GameId INT NOT NULL,
  TrailerUrl NVARCHAR(255),
  ExpectedDeliveryDate DATE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 7
CREATE TABLE PreOrderGames (
  PreOrderGameId INT PRIMARY KEY,
  GameId INT NOT NULL,
  PreOrderBonus NVARCHAR(255),
  PreOrderDiscount DECIMAL(5,2),
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 8
CREATE TABLE BetaGames (
  BetaGameId INT PRIMARY KEY,
  GameId INT NOT NULL,
  BetaStartDate DATE NOT NULL,
  BetaEndDate DATE NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 9
CREATE TABLE ReleasedGames (
  ReleasedGameId INT PRIMARY KEY,
  GameId INT NOT NULL,
  ReleaseDate DATE NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 10
CREATE TABLE Score (
  ScoreId INT PRIMARY KEY,
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Score INT NOT NULL CHECK (Score BETWEEN 1 AND 10),
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 11
CREATE TABLE Reviews (
  ReviewId INT PRIMARY KEY,
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Review TEXT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 12
CREATE TABLE GameAwards (
  GameAwardsId INT PRIMARY KEY,
  GameId INT NOT NULL,
  AwardName NVARCHAR(255) NOT NULL,
  Year INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 13
CREATE TABLE Developers (
  DeveloperId INT PRIMARY KEY,
  Name NVARCHAR(255) NOT NULL,
  Description TEXT,
  Website NVARCHAR(255)
);
GO

-- 14
CREATE TABLE GameDevelopers (
  GameDeveloperId INT PRIMARY KEY,
  GameId INT NOT NULL,
  DeveloperId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DeveloperId) REFERENCES Developers (DeveloperId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 15
CREATE TABLE Publishers (
  PublisherId INT PRIMARY KEY,
  Name NVARCHAR(255) NOT NULL,
  Description TEXT,
  Website NVARCHAR(255)
);
GO

-- 16
CREATE TABLE GamePublishers (
  GamePublisherId INT PRIMARY KEY,
  GameId INT NOT NULL,
  PublisherId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PublisherId) REFERENCES Publishers (PublisherId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 17
CREATE TABLE Wishlist (
  WishlistId INT PRIMARY KEY,
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 18
CREATE TABLE Cart (
  CartId INT PRIMARY KEY,
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Quantity INT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 19
CREATE TABLE Orders (
  OrderId INT PRIMARY KEY,
  UserId INT NOT NULL,
  OrderDate DATE NOT NULL,
  [Total amount in USD] MONEY NOT NULL CHECK ([Total amount in USD] >= 0),
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 20
CREATE TABLE OrderItems (
  OrderItemId INT PRIMARY KEY,
  OrderId INT NOT NULL,
  GameId INT NOT NULL,
  Quantity INT NOT NULL,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0),
  FOREIGN KEY (OrderId) REFERENCES Orders (OrderId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 21
CREATE TABLE ExchangeRate (
  ExchangeRateId INT PRIMARY KEY,
  Currency NVARCHAR(3) NOT NULL,
  [Equal 1 USD] MONEY NOT NULL CHECK ([Equal 1 USD] >= 0)
);
GO

--- VIEWS

IF OBJECT_ID('GameGenresView', 'V') IS NOT NULL
BEGIN
  DROP VIEW GameGenresView
END
GO

IF OBJECT_ID('GameDevelopersAndPublishers', 'V') IS NOT NULL
BEGIN
  DROP VIEW GameDevelopersAndPublishers;
END
GO

IF OBJECT_ID('ReleasedGamesWithPublishers', 'V') IS NOT NULL
BEGIN
  DROP VIEW ReleasedGamesWithPublishers
END
GO

IF OBJECT_ID('TopRatedGames', 'V') IS NOT NULL
BEGIN
  DROP VIEW TopRatedGames
END
GO

IF OBJECT_ID('TopSellingGames', 'V') IS NOT NULL
BEGIN
  DROP VIEW TopSellingGames
END
GO

IF OBJECT_ID('MostActiveUsers', 'V') IS NOT NULL
BEGIN
  DROP VIEW MostActiveUsers
END
GO

-- 1
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
CREATE VIEW GameDevelopersAndPublishers AS
SELECT GameDevelopers.GameId, Developers.Name AS Developers, Publishers.Name AS Publishers
FROM GameDevelopers
JOIN Developers ON GameDevelopers.DeveloperId = Developers.DeveloperId
JOIN GamePublishers ON GameDevelopers.GameId = GamePublishers.GameId
JOIN Publishers ON GamePublishers.PublisherId = Publishers.PublisherId
GROUP BY GameDevelopers.GameId, Developers.Name, Publishers.Name;
GO

-- 3
CREATE VIEW ReleasedGamesWithPublishers AS
SELECT R.GameId, G.Title AS GameTitle, P.Name AS PublisherName, R.ReleaseDate
FROM ReleasedGames R
JOIN Games G ON R.GameId = G.GameId
JOIN GamePublishers GP ON G.GameId = GP.GameId
JOIN Publishers P ON GP.PublisherId = P.PublisherId;
GO

-- 4
CREATE VIEW TopRatedGames AS
SELECT TOP 10 G.GameID, G.Title, AVG(S.Score) AS AverageScore, COUNT(R.GameId) AS NumberOfReviews
FROM Games G
LEFT JOIN Score S ON G.GameID = S.GameID
LEFT JOIN Reviews R ON G.GameID = R.GameID
GROUP BY G.GameId, G.Title
ORDER BY AverageScore DESC, NumberOfReviews DESC;
GO

-- 5
CREATE VIEW TopSellingGames AS
SELECT TOP 10 G.GameId, G.Title, SUM(OI.[Price in USD] * OI.Quantity) AS TotalRevenue
FROM Games G
JOIN OrderItems OI ON G.GameId = OI.GameId
GROUP BY G.GameId, G.Title
ORDER BY TotalRevenue DESC;
GO

-- 6
CREATE VIEW MostActiveUsers AS
SELECT TOP 10 U.Username, COUNT(*) AS NumberOfReviews
FROM Users U
JOIN Reviews R ON U.UserId = R.UserId
GROUP BY U.Username
ORDER BY NumberOfReviews DESC;
GO

--- FUNCTIONS

IF OBJECT_ID('GetGamesByGenre', 'IF') IS NOT NULL
BEGIN
  DROP FUNCTION GetGamesByGenre
END
GO

IF OBJECT_ID('GetGamesByPlatform', 'IF') IS NOT NULL
BEGIN
  DROP FUNCTION GetGamesByPlatform
END
GO

IF OBJECT_ID('DeveloperGames', 'TF') IS NOT NULL
BEGIN
  DROP FUNCTION DeveloperGames
END
GO

IF OBJECT_ID('PublisherGames', 'TF') IS NOT NULL
BEGIN
  DROP FUNCTION PublisherGames
END
GO

IF OBJECT_ID('CalculateTotalPrice', 'FN') IS NOT NULL
BEGIN
  DROP FUNCTION CalculateTotalPrice
END
GO

IF OBJECT_ID('HowMuch', 'FN') IS NOT NULL
BEGIN
  DROP FUNCTION HowMuch
END
GO

-- 1
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

-- 5
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

-- 6
CREATE FUNCTION HowMuch
(
  @GameID INT,
  @Currency NVARCHAR(3)
)
RETURNS MONEY
AS
BEGIN
  DECLARE @Price MONEY = 0
  DECLARE @ExchangeRate MONEY = 0
  SELECT @Price = [Price in USD] FROM Games WHERE GameID = @GameID
  SELECT @ExchangeRate = [Equal 1 USD] FROM [ExchangeRate] WHERE [Currency] = @Currency
  RETURN ROUND((@Price * @ExchangeRate), 2)
END;
GO

--- INSERT DATA

-- 1
INSERT INTO Users (UserId, Username, Email, Password)
VALUES
  (1, N'john_doe', N'john_doe@example.com', N'password1'),
  (2, N'jane_doe', N'jane_doe@example.com', N'password2'),
  (3, N'jim_smith', N'jim_smith@example.com', N'password3'),
  (4, N'sara_lee', N'sara_lee@example.com', N'password4'),
  (5, N'tom_jones', N'tom_jones@example.com', N'password5');
GO

-- 2
INSERT INTO Games (GameId, Title, LastUpdatedDate, Description, [Price in USD])
VALUES
  (1, N'The Last of Us Part II', '2023-03-15', 'Survive and explore a post-apocalyptic world filled with danger and complex characters.', 59.99),
  (2, N'Red Dead Redemption 2', '2022-09-25', 'Live the life of an outlaw in a stunning open world filled with memorable characters and tough choices.', 59.99),
  (3, N'God of War', '2022-10-01', 'Journey with Kratos and his son Atreus through Norse mythology in this epic adventure.', 39.99),
  (4, N'Halo 5: Guardians', '2022-06-15', 'Join Master Chief and Spartan Locke in a battle to save the galaxy from a new threat.', 59.99),
  (5, N'Minecraft', '2022-11-30', 'Unleash your creativity and build anything you can imagine in a blocky, procedurally generated world.', 26.95);
GO

-- 3
INSERT INTO GameGenres (GameGenreId, GameId, Genre)
VALUES
  (1, 1, N'Multiplayer'),
  (2, 1, N'Open-World'),
  (3, 2, N'First-Person'),
  (4, 2, N'Shooter'),
  (5, 3, N'Adventure');
GO

-- 4
INSERT INTO Platforms (PlatformId, Name) 
VALUES 
  (1, N'PlayStation 4'),
  (2, N'Xbox One'),
  (3, N'Nintendo Switch'),
  (4, N'PC'),
  (5, N'Mobile');
GO

-- 5
INSERT INTO GamePlatforms (GamePlatformId, GameId, PlatformId) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);
GO

-- 6
INSERT INTO UpcomingGames (UpcomingGameId, GameId, TrailerUrl, ExpectedDeliveryDate)
VALUES
  (1, 1, N'https://www.youtube.com/watch?v=btmN-bWwv0A', '2019-12-01'),
  (2, 3, N'https://www.youtube.com/watch?v=K0u_kAWLJOA', '2018-04-20'),
  (3, 5, N'https://www.youtube.com/watch?v=MmB9b5njVbA', '2011-11-18'),
  (4, 4, N'https://www.youtube.com/watch?v=Rh_NXwqFvHc', '2015-06-13'),
  (5, 2, N'https://www.youtube.com/watch?v=gmA6MrX81z4', '2017-10-18');
GO

-- 7
INSERT INTO PreOrderGames (PreOrderGameId, GameId, PreOrderBonus, PreOrderDiscount)
VALUES
  (1, 1, N'Bonus skin pack', 5.00),
  (2, 4, N'Bonus weapon pack', 10.00),
  (3, 2, N'Bonus story mission', 5.00),
  (4, 3, N'Exclusive in-game item', 5.00),
  (5, 5, N'Bonus skin pack', 5.00);
GO

-- 8
INSERT INTO BetaGames (BetaGameId, GameId, BetaStartDate, BetaEndDate)
VALUES
  (1, 1, '2020-05-19', '2020-06-19'),
  (2, 2, '2018-06-01', '2018-07-01'),
  (3, 3, '2018-02-01', '2018-03-15'),
  (4, 4, '2015-08-01', '2015-10-27'),
  (5, 5, '2011-10-01', '2011-11-18');
GO

-- 9
INSERT INTO ReleasedGames (ReleasedGameId, GameId, ReleaseDate)
VALUES
  (1, 1, '2020-06-19'),
  (2, 3, '2018-04-20'),
  (3, 4, '2015-10-27'),
  (4, 5, '2011-11-18'),
  (5, 2, '2018-10-26');
GO

-- 10
INSERT INTO Score (ScoreId, UserId, GameId, Score) 
VALUES 
  (1, 1, 1, 9),
  (2, 2, 1, 8),
  (3, 3, 2, 7),
  (4, 4, 3, 6),
  (5, 5, 4, 9);
GO

-- 11
INSERT INTO Reviews (ReviewId, UserId, GameId, Review) 
VALUES 
  (1, 1, 1, 'Great game with fantastic graphics and gameplay!'),
  (2, 2, 1, 'Loved the storyline and the character development.'),
  (3, 3, 2, 'Not the best game I have played, but it is still fun.'),
  (4, 4, 3, 'The graphics are impressive, but the gameplay is a bit repetitive.'),
  (5, 5, 4, 'I would recommend this game to anyone looking for a challenging experience.');
GO

-- 12
INSERT INTO GameAwards (GameAwardsId, GameId, AwardName, Year) 
VALUES 
  (1, 1, N'Best Game of the Year', 2020),
  (2, 2, N'Best RPG of the Year', 2019),
  (3, 3, N'Best Adventure Game of the Year', 2019),
  (4, 4, N'Best Shooter of the Year', 2016),
  (5, 5, N'Best Multiplayer Game of the Year', 2011);
GO

-- 13
INSERT INTO Developers (DeveloperId, Name, Description, Website)
VALUES
  (1, N'Naughty Dog', 'A first-party video game developer based in Santa Monica, California', N'naughtydog.com'),
  (2, N'Rockstar Studios', 'A subsidiary of Rockstar Games based in Edinburgh, Scotland', N'rockstargames.com'),
  (3, N'Santa Monica Studio', 'A first-party video game developer based in Santa Monica, California', N'sms.playstation.com'),
  (4, N'343 Industries', 'An American video game development studio located in Redmond, Washington', N'343industries.com'),
  (5, N'Mojang Studios', 'A video game development studio based in Stockholm, Sweden', N'mojang.com');
GO

-- 14
INSERT INTO GameDevelopers (GameDeveloperId, GameId, DeveloperId) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);
GO

-- 15
INSERT INTO Publishers (PublisherId, Name, Description, Website) 
VALUES 
  (1, N'Electronic Arts', 'Electronic Arts (EA) is a leading publisher and developer of interactive entertainment and video games.', N'ea.com'),
  (2, N'Activision Blizzard', 'Activision Blizzard is a leading publisher of interactive entertainment and video games.', N'activisionblizzard.com'),
  (3, N'Ubisoft', 'Ubisoft is a leading publisher and developer of video games and interactive entertainment.', N'ubisoft.com'),
  (4, N'Take-Two Interactive', 'Take-Two Interactive is a leading publisher of interactive entertainment and video games.', N'take2games.com'),
  (5, N'Microsoft', 'Microsoft is a leading technology company that is also involved in the publishing of video games and interactive entertainment.', N'microsoft.com');
GO

-- 16
INSERT INTO GamePublishers (GamePublisherId, GameId, PublisherId) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);
GO

-- 17
INSERT INTO Wishlist (WishlistId, UserId, GameId) 
VALUES 
  (1, 1, 2),
  (2, 2, 3),
  (3, 3, 4),
  (4, 4, 5),
  (5, 5, 1);
GO

-- 18
INSERT INTO Cart (CartId, UserId, GameId, Quantity) 
VALUES 
  (1, 1, 2, 1),
  (2, 2, 3, 2),
  (3, 3, 4, 3),
  (4, 4, 5, 4),
  (5, 5, 1, 5);
GO

-- 19
INSERT INTO Orders (OrderId, UserId, OrderDate, [Total amount in USD]) 
VALUES 
  (1, 1, '2022-12-01', 200.00),
  (2, 2, '2022-11-15', 150.00),
  (3, 3, '2022-10-31', 100.00),
  (4, 4, '2022-09-15', 75.00),
  (5, 5, '2022-08-01', 50.00);
GO

-- 20
INSERT INTO OrderItems (OrderItemId, OrderId, GameId, Quantity, [Price in USD]) 
VALUES 
  (1, 1, 1, 2, 59.99),
  (2, 2, 2, 1, 49.99),
  (3, 3, 3, 3, 39.99),
  (4, 4, 4, 4, 29.99),
  (5, 5, 5, 5, 19.99);
GO

-- 21
INSERT INTO ExchangeRate (ExchangeRateId, Currency, [Equal 1 USD]) 
VALUES 
  (1, N'USD', 1.00),
  (2, N'EUR', 0.93),
  (3, N'GBP', 0.83),
  (4, N'JPY', 134.15),
  (5, N'PLN', 4.45);
GO