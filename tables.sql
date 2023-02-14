IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Steam')
  CREATE DATABASE Steam;
GO

USE Steam;

IF OBJECT_ID('OrderItems', 'U') IS NOT NULL
  DROP TABLE OrderItems;

IF OBJECT_ID('Orders', 'U') IS NOT NULL
  DROP TABLE Orders;

IF OBJECT_ID('Cart', 'U') IS NOT NULL
  DROP TABLE Cart;

IF OBJECT_ID('Wishlist', 'U') IS NOT NULL
  DROP TABLE Wishlist;

IF OBJECT_ID('GamePublishers', 'U') IS NOT NULL
  DROP TABLE GamePublishers;

IF OBJECT_ID('Publishers', 'U') IS NOT NULL
  DROP TABLE Publishers;

IF OBJECT_ID('GameDevelopers', 'U') IS NOT NULL
  DROP TABLE GameDevelopers;

IF OBJECT_ID('Developers', 'U') IS NOT NULL
  DROP TABLE Developers;

IF OBJECT_ID('GameAwards', 'U') IS NOT NULL
  DROP TABLE GameAwards;

IF OBJECT_ID('Reviews', 'U') IS NOT NULL
  DROP TABLE Reviews;

IF OBJECT_ID('Score', 'U') IS NOT NULL
  DROP TABLE Score;

IF OBJECT_ID('GamePlatforms', 'U') IS NOT NULL
  DROP TABLE GamePlatforms;

IF OBJECT_ID('Platforms', 'U') IS NOT NULL
  DROP TABLE Platforms;

IF OBJECT_ID('GameGenres', 'U') IS NOT NULL
  DROP TABLE GameGenres;

IF OBJECT_ID('Games', 'U') IS NOT NULL
  DROP TABLE Games;

IF OBJECT_ID('Users', 'U') IS NOT NULL
  DROP TABLE Users;

-- 1
CREATE TABLE Users (
  Id INT PRIMARY KEY,
  Username VARCHAR(255) NOT NULL,
  Email VARCHAR(255) NOT NULL UNIQUE,
  Password VARCHAR(255) NOT NULL
);

INSERT INTO Users (Id, Username, Email, Password)
VALUES
  (1, 'john_doe', 'john_doe@example.com', 'password1'),
  (2, 'jane_doe', 'jane_doe@example.com', 'password2'),
  (3, 'jim_smith', 'jim_smith@example.com', 'password3'),
  (4, 'sara_lee', 'sara_lee@example.com', 'password4'),
  (5, 'tom_jones', 'tom_jones@example.com', 'password5');

-- 2
CREATE TABLE Games (
  Id INT PRIMARY KEY,
  Title VARCHAR(255) NOT NULL,
  ReleaseDate DATE,
  Description TEXT,
  Price DECIMAL(10,2) NOT NULL
);

INSERT INTO Games (Id, Title, ReleaseDate, Description, Price)
VALUES
  (1, 'The Last of Us Part II', '2020-06-19', 'A post-apocalyptic action-adventure game developed by Naughty Dog', 59.99),
  (2, 'Red Dead Redemption 2', '2018-10-26', 'An action-adventure game developed by Rockstar Studios', 59.99),
  (3, 'God of War', '2018-04-20', 'A soft reboot of the God of War series developed by Santa Monica Studio', 39.99),
  (4, 'Halo 5: Guardians', '2015-10-27', 'A first-person shooter developed by 343 Industries', 59.99),
  (5, 'Minecraft', '2011-11-18', 'A sandbox game developed by Mojang Studios', 26.95);

-- 3
CREATE TABLE GameGenres (
  Id INT PRIMARY KEY,
  GameId INT NOT NULL,
  Genre VARCHAR(255) NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (Id)
);

INSERT INTO GameGenres (Id, GameId, Genre)
VALUES
  (1, 1, 'Multiplayer'),
  (2, 1, 'Open-World'),
  (3, 2, 'First-Person'),
  (4, 2, 'Shooter'),
  (5, 3, 'Adventure');

-- 4
CREATE TABLE Platforms (
  Id INT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL
);

INSERT INTO Platforms (Id, Name) 
VALUES 
  (1, 'PlayStation 4'),
  (2, 'Xbox One'),
  (3, 'Nintendo Switch'),
  (4, 'PC'),
  (5, 'Mobile');

-- 5
CREATE TABLE GamePlatforms (
  Id INT PRIMARY KEY,
  GameId INT NOT NULL,
  PlatformId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (Id),
  FOREIGN KEY (PlatformId) REFERENCES Platforms (Id)
);

INSERT INTO GamePlatforms (Id, GameId, PlatformId) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);

-- 6
CREATE TABLE Score (
  Id INT PRIMARY KEY,
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Score INT NOT NULL CHECK (Score BETWEEN 1 AND 10),
  FOREIGN KEY (UserId) REFERENCES Users (Id),
  FOREIGN KEY (GameId) REFERENCES Games (Id)
);

INSERT INTO Score (Id, UserId, GameId, Score) 
VALUES 
  (1, 1, 1, 9),
  (2, 2, 1, 8),
  (3, 3, 2, 7),
  (4, 4, 3, 6),
  (5, 5, 4, 9);

-- 7
CREATE TABLE Reviews (
  Id INT PRIMARY KEY,
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Review TEXT,
  FOREIGN KEY (UserId) REFERENCES Users (Id),
  FOREIGN KEY (GameId) REFERENCES Games (Id)
);

INSERT INTO Reviews (Id, UserId, GameId, Review) 
VALUES 
  (1, 1, 1, 'Great game with fantastic graphics and gameplay!'),
  (2, 2, 1, 'Loved the storyline and the character development.'),
  (3, 3, 2, 'Not the best game I have played, but it is still fun.'),
  (4, 4, 3, 'The graphics are impressive, but the gameplay is a bit repetitive.'),
  (5, 5, 4, 'I would recommend this game to anyone looking for a challenging experience.');

-- 8
CREATE TABLE GameAwards (
  Id INT PRIMARY KEY,
  GameId INT NOT NULL,
  AwardName VARCHAR(255) NOT NULL,
  Year INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (Id)
);

INSERT INTO GameAwards (Id, GameId, AwardName, Year) 
VALUES 
  (1, 1, 'Best Game of the Year', 2022),
  (2, 2, 'Best RPG of the Year', 2022),
  (3, 3, 'Best Sports Game of the Year', 2022),
  (4, 4, 'Best Adventure Game of the Year', 2022),
  (5, 5, 'Best Multiplayer Game of the Year', 2022);

-- 9
CREATE TABLE Developers (
  Id INT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  Description TEXT,
  Website VARCHAR(255)
);

INSERT INTO Developers (Id, Name, Description, Website)
VALUES
  (1, 'Naughty Dog', 'A first-party video game developer based in Santa Monica, California', 'naughtydog.com'),
  (2, 'Rockstar Studios', 'A subsidiary of Rockstar Games based in Edinburgh, Scotland', 'rockstargames.com'),
  (3, 'Santa Monica Studio', 'A first-party video game developer based in Santa Monica, California', 'sms.playstation.com'),
  (4, '343 Industries', 'An American video game development studio located in Redmond, Washington', '343industries.com'),
  (5, 'Mojang Studios', 'A video game development studio based in Stockholm, Sweden', 'mojang.com');

-- 10
CREATE TABLE GameDevelopers (
  Id INT PRIMARY KEY,
  GameId INT NOT NULL,
  DeveloperId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (Id),
  FOREIGN KEY (DeveloperId) REFERENCES Developers (Id)
);

INSERT INTO GameDevelopers (Id, GameId, DeveloperId) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);

-- 11
CREATE TABLE Publishers (
  Id INT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  Description TEXT,
  Website VARCHAR(255)
);

INSERT INTO Publishers (Id, Name, Description, Website) 
VALUES 
  (1, 'Electronic Arts', 'Electronic Arts (EA) is a leading publisher and developer of interactive entertainment and video games.', 'ea.com'),
  (2, 'Activision Blizzard', 'Activision Blizzard is a leading publisher of interactive entertainment and video games.', 'activisionblizzard.com'),
  (3, 'Ubisoft', 'Ubisoft is a leading publisher and developer of video games and interactive entertainment.', 'ubisoft.com'),
  (4, 'Take-Two Interactive', 'Take-Two Interactive is a leading publisher of interactive entertainment and video games.', 'take2games.com'),
  (5, 'Microsoft', 'Microsoft is a leading technology company that is also involved in the publishing of video games and interactive entertainment.', 'microsoft.com');

-- 12
CREATE TABLE GamePublishers (
  Id INT PRIMARY KEY,
  GameId INT NOT NULL,
  PublisherId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (Id),
  FOREIGN KEY (PublisherId) REFERENCES Publishers (Id)
);

INSERT INTO GamePublishers (Id, GameId, PublisherId) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);

-- 13
CREATE TABLE Wishlist (
  Id INT PRIMARY KEY,
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (Id),
  FOREIGN KEY (GameId) REFERENCES Games (Id)
);

INSERT INTO Wishlist (Id, UserId, GameId) 
VALUES 
  (1, 1, 2),
  (2, 2, 3),
  (3, 3, 4),
  (4, 4, 5),
  (5, 5, 1);

-- 14
CREATE TABLE Cart (
  Id INT PRIMARY KEY,
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Quantity INT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (Id),
  FOREIGN KEY (GameId) REFERENCES Games (Id)
);

INSERT INTO Cart (Id, UserId, GameId, Quantity) 
VALUES 
  (1, 1, 2, 1),
  (2, 2, 3, 2),
  (3, 3, 4, 3),
  (4, 4, 5, 4),
  (5, 5, 1, 5);

-- 15
CREATE TABLE Orders (
  Id INT PRIMARY KEY,
  UserId INT NOT NULL,
  OrderDate DATE NOT NULL,
  TotalAmount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (Id)
);

INSERT INTO Orders (Id, UserId, OrderDate, TotalAmount) 
VALUES 
  (1, 1, '2022-12-01', 200.00),
  (2, 2, '2022-11-15', 150.00),
  (3, 3, '2022-10-31', 100.00),
  (4, 4, '2022-09-15', 75.00),
  (5, 5, '2022-08-01', 50.00);

-- 16
CREATE TABLE OrderItems (
  Id INT PRIMARY KEY,
  OrderId INT NOT NULL,
  GameId INT NOT NULL,
  Quantity INT NOT NULL,
  Price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (OrderId) REFERENCES Orders (Id),
  FOREIGN KEY (GameId) REFERENCES Games (Id)
);

INSERT INTO OrderItems (Id, OrderId, GameId, Quantity, Price) 
VALUES 
  (1, 1, 1, 2, 59.99),
  (2, 2, 2, 1, 49.99),
  (3, 3, 3, 3, 39.99),
  (4, 4, 4, 4, 29.99),
  (5, 5, 5, 5, 19.99);