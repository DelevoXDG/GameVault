IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Steam')
BEGIN
  CREATE DATABASE Steam
END
GO

USE Steam;

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
  Username VARCHAR(255) NOT NULL,
  Email VARCHAR(255) NOT NULL UNIQUE,
  Password VARCHAR(255) NOT NULL
);
GO

-- 2
CREATE TABLE Games (
  GameId INT PRIMARY KEY,
  Title VARCHAR(255) NOT NULL,
  LastUpdatedDate DATE NOT NULL,
  Description TEXT,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0)
);
GO

-- 3
CREATE TABLE GameGenres (
  GameGenreId INT PRIMARY KEY,
  GameId INT NOT NULL,
  Genre VARCHAR(255) NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 4
CREATE TABLE Platforms (
  PlatformId INT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL
);
GO


-- 5
CREATE TABLE GamePlatforms (
  GamePlatformId INT PRIMARY KEY,
  GameId INT NOT NULL,
  PlatformId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PlatformId) REFERENCES Platforms (PlatformId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 6
CREATE TABLE UpcomingGames (
  UpcomingGameId INT PRIMARY KEY,
  GameId INT NOT NULL,
  TrailerUrl VARCHAR(255),
  ExpectedDeliveryDate DATE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 7
CREATE TABLE PreOrderGames (
  PreOrderGameId INT PRIMARY KEY,
  GameId INT NOT NULL,
  PreOrderBonus VARCHAR(255),
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
  AwardName VARCHAR(255) NOT NULL,
  Year INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


-- 13
CREATE TABLE Developers (
  DeveloperId INT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  Description TEXT,
  Website VARCHAR(255)
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
  Name VARCHAR(255) NOT NULL,
  Description TEXT,
  Website VARCHAR(255)
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

--21 
CREATE TABLE ExchangeRate (
  CurrencyId INT PRIMARY KEY,
  Currency NVARCHAR(3) NOT NULL,
  [Equal 1 USD] MONEY NOT NULL CHECK ([Equal 1 USD] >= 0)
);
GO




-- Sample data
INSERT INTO Users (UserId, Username, Email, Password)
VALUES
  (1, 'john_doe', 'john_doe@example.com', 'password1'),
  (2, 'jane_doe', 'jane_doe@example.com', 'password2'),
  (3, 'jim_smith', 'jim_smith@example.com', 'password3'),
  (4, 'sara_lee', 'sara_lee@example.com', 'password4'),
  (5, 'tom_jones', 'tom_jones@example.com', 'password5');
  
INSERT INTO Games (GameId, Title, LastUpdatedDate, Description, [Price in USD])
VALUES
  (1, 'The Last of Us Part II', '2023-03-15', 'Survive and explore a post-apocalyptic world filled with danger and complex characters.', 59.99),
  (2, 'Red Dead Redemption 2', '2022-09-25', 'Live the life of an outlaw in a stunning open world filled with memorable characters and tough choices.', 59.99),
  (3, 'God of War', '2022-10-01', 'Journey with Kratos and his son Atreus through Norse mythology in this epic adventure.', 39.99),
  (4, 'Halo 5: Guardians', '2022-06-15', 'Join Master Chief and Spartan Locke in a battle to save the galaxy from a new threat.', 59.99),
  (5, 'Minecraft', '2022-11-30', 'Unleash your creativity and build anything you can imagine in a blocky, procedurally generated world.', 26.95);

INSERT INTO GameGenres (GameGenreId, GameId, Genre)
VALUES
  (1, 1, 'Multiplayer'),
  (2, 1, 'Open-World'),
  (3, 2, 'First-Person'),
  (4, 2, 'Shooter'),
  (5, 3, 'Adventure');
INSERT INTO Platforms (PlatformId, Name) 
VALUES 
  (1, 'PlayStation 4'),
  (2, 'Xbox One'),
  (3, 'Nintendo Switch'),
  (4, 'PC'),
  (5, 'Mobile');
INSERT INTO GamePlatforms (GamePlatformId, GameId, PlatformId) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);
INSERT INTO UpcomingGames (UpcomingGameId, GameId, TrailerUrl, ExpectedDeliveryDate)
VALUES
  (1, 1, 'https://www.youtube.com/watch?v=btmN-bWwv0A', '2019-12-01'),
  (2, 3, 'https://www.youtube.com/watch?v=K0u_kAWLJOA', '2018-04-20'),
  (3, 5, 'https://www.youtube.com/watch?v=MmB9b5njVbA', '2011-11-18'),
  (4, 4, 'https://www.youtube.com/watch?v=Rh_NXwqFvHc', '2015-06-13'),
  (5, 2, 'https://www.youtube.com/watch?v=gmA6MrX81z4', '2017-10-18');
INSERT INTO PreOrderGames (PreOrderGameId, GameId, PreOrderBonus, PreOrderDiscount)
VALUES
  (1, 1, 'Bonus skin pack', 5.00),
  (2, 4, 'Bonus weapon pack', 10.00),
  (3, 2, 'Bonus story mission', 5.00),
  (4, 3, 'Exclusive in-game item', 5.00),
  (5, 5, 'Bonus skin pack', 5.00);
INSERT INTO BetaGames (BetaGameId, GameId, BetaStartDate, BetaEndDate)
VALUES
  (1, 1, '2020-05-19', '2020-06-19'),
  (2, 2, '2018-06-01', '2018-07-01'),
  (3, 3, '2018-02-01', '2018-03-15'),
  (4, 4, '2015-08-01', '2015-10-27'),
  (5, 5, '2011-10-01', '2011-11-18');
INSERT INTO ReleasedGames (ReleasedGameId, GameId, ReleaseDate)
VALUES
  (1, 1, '2020-06-19'),
  (2, 3, '2018-04-20'),
  (3, 4, '2015-10-27'),
  (4, 5, '2011-11-18'),
  (5, 2, '2018-10-26');
INSERT INTO Score (ScoreId, UserId, GameId, Score) 
VALUES 
  (1, 1, 1, 9),
  (2, 2, 1, 8),
  (3, 3, 2, 7),
  (4, 4, 3, 10),
  (5, 5, 4, 8),
  (6, 4, 3, 6),
  (7, 5, 4, 9);

INSERT INTO Reviews (ReviewId, UserId, GameId, Review) 
VALUES 
  (1, 1, 1, 'Great game with fantastic graphics and gameplay!'),
  (2, 2, 1, 'Loved the storyline and the character development.'),
  (3, 3, 2, 'Not the best game I have played, but it is still fun.'),
  (4, 4, 3, 'The graphics are impressive, but the gameplay is a bit repetitive.'),
  (5, 5, 4, 'I would recommend this game to anyone looking for a challenging experience.');

INSERT INTO GameAwards (GameAwardsId, GameId, AwardName, Year) 
VALUES 
  (1, 1, 'Best Game of the Year', 2020),
  (2, 2, 'Best RPG of the Year', 2019),
  (3, 3, 'Best Adventure Game of the Year', 2019),
  (4, 4, 'Best Shooter of the Year', 2016),
  (5, 5, 'Best Multiplayer Game of the Year', 2011);

INSERT INTO Developers (DeveloperId, Name, Description, Website)
VALUES
  (1, 'Naughty Dog', 'A first-party video game developer based in Santa Monica, California', 'naughtydog.com'),
  (2, 'Rockstar Studios', 'A subsidiary of Rockstar Games based in Edinburgh, Scotland', 'rockstargames.com'),
  (3, 'Santa Monica Studio', 'A first-party video game developer based in Santa Monica, California', 'sms.playstation.com'),
  (4, '343 Industries', 'An American video game development studio located in Redmond, Washington', '343industries.com'),
  (5, 'Mojang Studios', 'A video game development studio based in Stockholm, Sweden', 'mojang.com');

INSERT INTO GameDevelopers (GameDeveloperId, GameId, DeveloperId) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);

INSERT INTO Publishers (PublisherId, Name, Description, Website) 
VALUES 
  (1, 'Electronic Arts', 'Electronic Arts (EA) is a leading publisher and developer of interactive entertainment and video games.', 'ea.com'),
  (2, 'Activision Blizzard', 'Activision Blizzard is a leading publisher of interactive entertainment and video games.', 'activisionblizzard.com'),
  (3, 'Ubisoft', 'Ubisoft is a leading publisher and developer of video games and interactive entertainment.', 'ubisoft.com'),
  (4, 'Take-Two Interactive', 'Take-Two Interactive is a leading publisher of interactive entertainment and video games.', 'take2games.com'),
  (5, 'Microsoft', 'Microsoft is a leading technology company that is also involved in the publishing of video games and interactive entertainment.', 'microsoft.com');
GO


INSERT INTO GamePublishers (GamePublisherId, GameId, PublisherId) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);

INSERT INTO Wishlist (WishlistId, UserId, GameId) 
VALUES 
  (1, 1, 2),
  (2, 2, 3),
  (3, 3, 4),
  (4, 4, 5),
  (5, 5, 1);
INSERT INTO Cart (CartId, UserId, GameId, Quantity) 
VALUES 
  (1, 1, 2, 1),
  (2, 2, 3, 2),
  (3, 3, 4, 3),
  (4, 4, 5, 4),
  (5, 5, 1, 5);

INSERT INTO Orders (OrderId, UserId, OrderDate, [Total amount in USD]) 
VALUES 
  (1, 1, '2022-12-01', 200.00),
  (2, 2, '2022-11-15', 150.00),
  (3, 3, '2022-10-31', 100.00),
  (4, 4, '2022-09-15', 75.00),
  (5, 5, '2022-08-01', 50.00);

INSERT INTO OrderItems (OrderItemId, OrderId, GameId, Quantity, [Price in USD]) 
VALUES 
  (1, 1, 1, 2, 59.99),
  (2, 2, 2, 1, 49.99),
  (3, 3, 3, 3, 39.99),
  (4, 4, 4, 4, 29.99),
  (5, 5, 5, 5, 19.99);

INSERT INTO ExchangeRate (CurrencyID, Currency, [Equal 1 USD]) 
VALUES 
  (1, 'USD', 1.00),
  (2, 'EUR', 0.93),
  (3, 'GBP', 0.83),
  (4, 'JPY', 134.15),
  (5, 'PLN', 4.45);
GO


IF OBJECT_ID('HowMuch', 'FN') IS NOT NULL
BEGIN
  DROP FUNCTION HowMuch
END
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

IF OBJECT_ID('GameGenresView', 'V') IS NOT NULL
BEGIN
  DROP VIEW GameGenresView
END
GO

CREATE VIEW GameGenresView AS
SELECT GameId, STRING_AGG(Genre, ', ') AS Genres
FROM GameGenres
GROUP BY GameId;
GO

IF OBJECT_ID('MostActiveUsers', 'V') IS NOT NULL
BEGIN
  DROP VIEW MostActiveUsers
END
GO

CREATE VIEW MostActiveUsers AS
SELECT TOP 10 U.Username, COUNT(*) AS NumberOfReviews
FROM Users U
JOIN Reviews R ON U.UserId = R.UserId
GROUP BY U.Username
ORDER BY NumberOfReviews DESC;
GO

IF OBJECT_ID('CalculateTotalPrice', 'FN') IS NOT NULL
BEGIN
  DROP FUNCTION CalculateTotalPrice
END
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

IF OBJECT_ID('dbo.GetTopRatedGames', 'P') IS NOT NULL
  DROP PROCEDURE dbo.GetTopRatedGames
GO
CREATE PROCEDURE GetTopRatedGames 
AS
BEGIN
  SELECT TOP 10 g.Title, AVG(S.Score) AS AverageRating
  FROM Games g
  JOIN Score S ON g.GameID = S.GameID
  GROUP BY g.Title
  ORDER BY AverageRating DESC
END
GO

EXEC GetTopRatedGames
GO