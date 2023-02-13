/*
Entity–relationship model:

USERS
  |
  V
GAMES  <-  GAME_DEVELOPERS
  |
  V
DEVELOPERS
  |
  V
PUBLISHERS  <-  GAME_PUBLISHERS
  |
  V
PLATFORMS
  |
  V
REVIEWS  <-  SCORE
  |
  V
WISHLIST
  |
  V
CART
  |
  V
ORDERS  <-  ORDER_ITEMS
  |
  V
GAME_GENRES
  |
  V
GAME_AWARDS
*/

-- 1
IF OBJECT_ID('USERS', 'U') IS NOT NULL
  DROP TABLE USERS;

CREATE TABLE USERS (
  ID INT PRIMARY KEY,
  USERNAME VARCHAR(255) NOT NULL,
  EMAIL VARCHAR(255) NOT NULL UNIQUE,
  PASSWORD VARCHAR(255) NOT NULL
);

INSERT INTO USERS (ID, USERNAME, EMAIL, PASSWORD)
VALUES
  (1, 'john_doe', 'john_doe@example.com', 'password1'),
  (2, 'jane_doe', 'jane_doe@example.com', 'password2'),
  (3, 'jim_smith', 'jim_smith@example.com', 'password3'),
  (4, 'sara_lee', 'sara_lee@example.com', 'password4'),
  (5, 'tom_jones', 'tom_jones@example.com', 'password5');

-- 2
IF OBJECT_ID('GAME_DEVELOPERS', 'U') IS NOT NULL
  DROP TABLE GAME_DEVELOPERS;

CREATE TABLE GAME_DEVELOPERS (
  ID INT PRIMARY KEY,
  GAME_ID INT NOT NULL,
  DEVELOPER_ID INT NOT NULL,
  FOREIGN KEY (GAME_ID) REFERENCES GAMES (ID),
  FOREIGN KEY (DEVELOPER_ID) REFERENCES DEVELOPERS (ID)
);

INSERT INTO GAME_DEVELOPERS (ID, GAME_ID, DEVELOPER_ID) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);

-- 3
IF OBJECT_ID('GAMES', 'U') IS NOT NULL
  DROP TABLE GAMES;

CREATE TABLE GAMES (
  ID INT PRIMARY KEY,
  TITLE VARCHAR(255) NOT NULL,
  GENRE VARCHAR(255),
  RELEASE_DATE DATE,
  DESCRIPTION TEXT,
  PRICE DECIMAL(10,2) NOT NULL
);

INSERT INTO GAMES (ID, TITLE, GENRE, RELEASE_DATE, DESCRIPTION, PRICE)
VALUES
  (1, 'The Last of Us Part II', 'Action-adventure', '2020-06-19', 'A post-apocalyptic action-adventure game developed by Naughty Dog', 59.99),
  (2, 'Red Dead Redemption 2', 'Action-adventure', '2018-10-26', 'An action-adventure game developed by Rockstar Studios', 59.99),
  (3, 'God of War', 'Action-adventure', '2018-04-20', 'A soft reboot of the God of War series developed by Santa Monica Studio', 39.99),
  (4, 'Halo 5: Guardians', 'First-person shooter', '2015-10-27', 'A first-person shooter developed by 343 Industries', 59.99),
  (5, 'Minecraft', 'Sandbox', '2011-11-18', 'A sandbox game developed by Mojang Studios', 26.95);

-- 4
IF OBJECT_ID('DEVELOPERS', 'U') IS NOT NULL
  DROP TABLE DEVELOPERS;

CREATE TABLE DEVELOPERS (
  ID INT PRIMARY KEY,
  NAME VARCHAR(255) NOT NULL,
  DESCRIPTION TEXT,
  WEBSITE VARCHAR(255)
);

INSERT INTO DEVELOPERS (ID, NAME, DESCRIPTION, WEBSITE)
VALUES
  (1, 'Naughty Dog', 'A first-party video game developer based in Santa Monica, California', 'naughtydog.com'),
  (2, 'Rockstar Studios', 'A subsidiary of Rockstar Games based in Edinburgh, Scotland', 'rockstargames.com'),
  (3, 'Santa Monica Studio', 'A first-party video game developer based in Santa Monica, California', 'sms.playstation.com'),
  (4, '343 Industries', 'An American video game development studio located in Redmond, Washington', '343industries.com'),
  (5, 'Mojang Studios', 'A video game development studio based in Stockholm, Sweden', 'mojang.com');

-- 5
IF OBJECT_ID('GAME_PUBLISHERS', 'U') IS NOT NULL
  DROP TABLE GAME_PUBLISHERS;

CREATE TABLE GAME_PUBLISHERS (
  ID INT PRIMARY KEY,
  GAME_ID INT NOT NULL,
  PUBLISHER_ID INT NOT NULL,
  FOREIGN KEY (GAME_ID) REFERENCES GAMES (ID),
  FOREIGN KEY (PUBLISHER_ID) REFERENCES PUBLISHERS (ID)
);

INSERT INTO GAME_PUBLISHERS (ID, GAME_ID, PUBLISHER_ID) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);

-- 6
IF OBJECT_ID('PUBLISHERS', 'U') IS NOT NULL
  DROP TABLE PUBLISHERS;

CREATE TABLE PUBLISHERS (
  ID INT PRIMARY KEY,
  NAME VARCHAR(255) NOT NULL,
  DESCRIPTION TEXT,
  WEBSITE VARCHAR(255)
);

INSERT INTO PUBLISHERS (ID, NAME, DESCRIPTION, WEBSITE) 
VALUES 
(1, 'Electronic Arts', 'Electronic Arts (EA) is a leading publisher and developer of interactive entertainment and video games.', 'ea.com'),
(2, 'Activision Blizzard', 'Activision Blizzard is a leading publisher of interactive entertainment and video games.', 'activisionblizzard.com'),
(3, 'Ubisoft', 'Ubisoft is a leading publisher and developer of video games and interactive entertainment.', 'ubisoft.com'),
(4, 'Take-Two Interactive', 'Take-Two Interactive is a leading publisher of interactive entertainment and video games.', 'take2games.com'),
(5, 'Microsoft', 'Microsoft is a leading technology company that is also involved in the publishing of video games and interactive entertainment.', 'microsoft.com');

-- 7
IF OBJECT_ID('PLATFORMS', 'U') IS NOT NULL
  DROP TABLE PLATFORMS;

CREATE TABLE PLATFORMS (
  ID INT PRIMARY KEY,
  NAME VARCHAR(255) NOT NULL
);

INSERT INTO PLATFORMS (ID, NAME) 
VALUES 
  (1, 'PlayStation 4'),
  (2, 'Xbox One'),
  (3, 'Nintendo Switch'),
  (4, 'PC'),
  (5, 'Mobile');

-- 8
IF OBJECT_ID('SCORE', 'U') IS NOT NULL
  DROP TABLE SCORE;

CREATE TABLE SCORE (
  ID INT PRIMARY KEY,
  USER_ID INT NOT NULL,
  GAME_ID INT NOT NULL,
  SCORE INT NOT NULL CHECK (SCORE BETWEEN 1 AND 10),
  FOREIGN KEY (USER_ID) REFERENCES USERS (ID),
  FOREIGN KEY (GAME_ID) REFERENCES GAMES (ID)
);

INSERT INTO RATINGS (ID, USER_ID, GAME_ID, RATING) 
VALUES 
  (1, 1, 1, 9),
  (2, 2, 1, 8),
  (3, 3, 2, 7),
  (4, 4, 3, 6),
  (5, 5, 4, 9);

-- 9
IF OBJECT_ID('REVIEWS', 'U') IS NOT NULL
  DROP TABLE REVIEWS;

CREATE TABLE REVIEWS (
  ID INT PRIMARY KEY,
  USER_ID INT NOT NULL,
  GAME_ID INT NOT NULL,
  REVIEW TEXT,
  FOREIGN KEY (USER_ID) REFERENCES USERS (ID),
  FOREIGN KEY (GAME_ID) REFERENCES GAMES (ID)
);

INSERT INTO REVIEWS (ID, USER_ID, GAME_ID, REVIEW) 
VALUES 
  (1, 1, 1, 'Great game with fantastic graphics and gameplay!'),
  (2, 2, 1, 'Loved the storyline and the character development.'),
  (3, 3, 2, 'Not the best game I have played, but it is still fun.'),
  (4, 4, 3, 'The graphics are impressive, but the gameplay is a bit repetitive.'),
  (5, 5, 4, 'I would recommend this game to anyone looking for a challenging experience.');

-- 10
IF OBJECT_ID('WISHLIST', 'U') IS NOT NULL
  DROP TABLE WISHLIST;

CREATE TABLE WISHLIST (
  ID INT PRIMARY KEY,
  USER_ID INT NOT NULL,
  GAME_ID INT NOT NULL,
  FOREIGN KEY (USER_ID) REFERENCES USERS (ID),
  FOREIGN KEY (GAME_ID) REFERENCES GAMES (ID)
);

INSERT INTO WISHLIST (ID, USER_ID, GAME_ID) 
VALUES 
  (1, 1, 2),
  (2, 2, 3),
  (3, 3, 4),
  (4, 4, 5),
  (5, 5, 1);

-- 11
IF OBJECT_ID('CART', 'U') IS NOT NULL
  DROP TABLE CART;

CREATE TABLE CART (
  ID INT PRIMARY KEY,
  USER_ID INT NOT NULL,
  GAME_ID INT NOT NULL,
  QUANTITY INT NOT NULL,
  FOREIGN KEY (USER_ID) REFERENCES USERS (ID),
  FOREIGN KEY (GAME_ID) REFERENCES GAMES (ID)
);

INSERT INTO CART (ID, USER_ID, GAME_ID, QUANTITY) 
VALUES 
  (1, 1, 2, 1),
  (2, 2, 3, 2),
  (3, 3, 4, 3),
  (4, 4, 5, 4),
  (5, 5, 1, 5);

-- 12
IF OBJECT_ID('ORDER_ITEMS', 'U') IS NOT NULL
  DROP TABLE ORDER_ITEMS;

CREATE TABLE ORDER_ITEMS (
  ID INT PRIMARY KEY,
  ORDER_ID INT NOT NULL,
  GAME_ID INT NOT NULL,
  QUANTITY INT NOT NULL,
  PRICE DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (ORDER_ID) REFERENCES ORDERS (ID),
  FOREIGN KEY (GAME_ID) REFERENCES GAMES (ID)
);

INSERT INTO ORDER_ITEMS (ID, ORDER_ID, GAME_ID, QUANTITY, PRICE) 
VALUES 
  (1, 1, 1, 2, 59.99),
  (2, 2, 2, 1, 49.99),
  (3, 3, 3, 3, 39.99),
  (4, 4, 4, 4, 29.99),
  (5, 5, 5, 5, 19.99);

-- 13
IF OBJECT_ID('ORDERS', 'U') IS NOT NULL
  DROP TABLE ORDERS;

CREATE TABLE ORDERS (
  ID INT PRIMARY KEY,
  USER_ID INT NOT NULL,
  ORDER_DATE DATE NOT NULL,
  TOTAL_AMOUNT DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (USER_ID) REFERENCES USERS (ID)
);

INSERT INTO ORDERS (ID, USER_ID, ORDER_DATE, TOTAL_AMOUNT) 
VALUES 
  (1, 1, '2022-12-01', 200.00),
  (2, 2, '2022-11-15', 150.00),
  (3, 3, '2022-10-31', 100.00),
  (4, 4, '2022-09-15', 75.00),
  (5, 5, '2022-08-01', 50.00);

-- 14
IF OBJECT_ID('GAME_PLATFORMS', 'U') IS NOT NULL
  DROP TABLE GAME_PLATFORMS;

CREATE TABLE GAME_PLATFORMS (
  ID INT PRIMARY KEY,
  GAME_ID INT NOT NULL,
  PLATFORM_ID INT NOT NULL,
  FOREIGN KEY (GAME_ID) REFERENCES GAMES (ID),
  FOREIGN KEY (PLATFORM_ID) REFERENCES PLATFORMS (ID)
);

INSERT INTO GAME_PLATFORMS (ID, GAME_ID, PLATFORM_ID) 
VALUES 
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, 4),
  (5, 5, 5);

-- 15
IF OBJECT_ID('GAME_GENRES', 'U') IS NOT NULL
  DROP TABLE GAME_GENRES;

CREATE TABLE GAME_GENRES (
  ID INT PRIMARY KEY,
  GAME_ID INT NOT NULL,
  TAG VARCHAR(255) NOT NULL,
  FOREIGN KEY (GAME_ID) REFERENCES GAMES (ID)
);

INSERT INTO GAME_GENRES (ID, GAME_ID, TAG)
VALUES
  (1, 1, 'Multiplayer'),
  (2, 1, 'Open-World'),
  (3, 2, 'First-Person'),
  (4, 2, 'Shooter'),
  (5, 3, 'Adventure');

-- 16
IF OBJECT_ID('GAME_AWARDS', 'U') IS NOT NULL
  DROP TABLE GAME_AWARDS;

CREATE TABLE GAME_AWARDS (
  ID INT PRIMARY KEY,
  GAME_ID INT NOT NULL,
  AWARD_NAME VARCHAR(255) NOT NULL,
  YEAR INT NOT NULL,
  FOREIGN KEY (GAME_ID) REFERENCES GAMES (ID)
);

INSERT INTO GAME_AWARDS (ID, GAME_ID, AWARD_NAME, YEAR) 
VALUES 
  (1, 1, 'Best Game of the Year', 2022),
  (2, 2, 'Best RPG of the Year', 2022),
  (3, 3, 'Best Sports Game of the Year', 2022),
  (4, 4, 'Best Adventure Game of the Year', 2022),
  (5, 5, 'Best Multiplayer Game of the Year', 2022);