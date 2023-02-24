Herman Lazarchyk, Maksim Zdobnikau

<h1> Baza Danych Sklepu Internetowego Gier Komputerowych </h1>

<h3> Cel i możliwości </h3>

Zaprojektowana baza danych sklepu internetowego gier komputerowych umożliwia użytkownikom przeglądanie, wybieranie i kupowanie gier. Dzięki odpowiednim tabelom w bazie danych, użytkownicy mogą przeglądać gry według różnych kryteriów, takich jak gatunek, platforma, wydawca, deweloper, a także korzystać z funkcjonalności takich jak przedsprzedaż, beta testy, recenzje i oceny użytkowników, również jak i  tworzenie list życzeń i koszyków zakupowych. Dodatkowo, baza danych umożliwia twórcom gier przeglądanie i aktualizowanie swoich danych, a także otrzymywanie nagród i wyróżnień. Wszystko to pozwala na łatwe i przyjemne korzystanie ze sklepu internetowego gier komputerowych oraz umożliwia na szybkie i wygodne kupowanie gier dla ich fanów.

<h3> Główne założenia </h3>

Do zaprojektowania i stworzenia bazy przyjęto szereg założeń celem jak optymalizacji pracy projektantów oraz działania bazy, jak również i zachowania ogromnej różnorodności branży gier:

- Ceny gier wpisują się w walucie USD, która musi być nieujemna;
- Każda gra może występować w sklepie tylko jeden raz;
- Użytkowniki sklepu muszą mieć różne adresy e-mail;
- Gra może mieć ocenę tylko w zakresie od 1 do 10;
- W niektórych przypadkach istnieją ograniczenia dotyczące maksymalnej liczby znaków (np. imię użytkownika albo nazwa gry);

<h3> Ograniczenia przyjęte przy projektowaniu </h3>

Zaprojektowana baza danych ma kilka istotnych ograniczeń. Przede wszystkim brakuje w niej tabeli pozwalającej na przechowywanie informacji o kodach rabatowych. Bez tej tabeli, administratorzy nie mogą udostępniać użytkownikom kodów promocyjnych, co może ograniczyć sprzedaż i skuteczność działań marketingowych. Inne ograniczenia to brak danych o językach, w jakich gra jest dostępna, wraz z danymi o typie i wersji platformy, brak informacji o minimalnych wymaganiach sprzętowych, a także brak szczegółowych danych o aktualizacjach dla każdej gry.

<h3> Schemat pielęgnacji bazy danych </h3>

W związku z tym, że sklep internetowy jest skomplikową instytucją finansową i nie może sobie pozwolić na utracenie takich ważnych danych, jak np. ilość spredanych towarów, dane użytkowników czy ich zamówień, dotyczące jest codziennie utworzenie różnicowej kopii zapasowej w godzinnach nocnych w związku z małym prawdopodobieństwem korzystania z serwisu w tym czasie. Również jest zalecone tworzenie cotygodniowej pełnej kopii zapasowej w nocnych godzinach weekendowych.

<h3> Diagram ER wraz ze schematem bazy danych </h3>

<h3> Dodatkowe więzy integralności danych </h3>

W niżej przedstawionym opisie są zaznaczone wszystkie występujące więzy integralności (NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK) dla każdej tabeli istniejącej w zaprojektowanej bazie danych.

```tsql
CREATE TABLE Users (
  UserId INT PRIMARY KEY IDENTITY(1,1),
  Username NVARCHAR(255) NOT NULL,
  Email NVARCHAR(255) NOT NULL UNIQUE,
  Password NVARCHAR(255) NOT NULL
);

CREATE TABLE Games (
  GameId INT PRIMARY KEY IDENTITY(1,1),
  Title NVARCHAR(255) NOT NULL UNIQUE,
  LastUpdatedDate DATE NOT NULL,
  Description TEXT,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0)
);

CREATE TABLE GameGenres (
  GameGenreId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  Genre NVARCHAR(255) NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Platforms (
  PlatformId INT PRIMARY KEY IDENTITY(1,1),
  Name NVARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE GamePlatforms (
  GamePlatformId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  PlatformId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PlatformId) REFERENCES Platforms (PlatformId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UpcomingGames (
  UpcomingGameId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  TrailerUrl NVARCHAR(255),
  ExpectedDeliveryDate DATE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PreOrderGames (
  PreOrderGameId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  PreOrderBonus TEXT,
  PreOrderDiscount DECIMAL(2),
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE BetaGames (
  BetaGameId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  BetaStartDate DATE NOT NULL,
  BetaEndDate DATE NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ReleasedGames (
  ReleasedGameId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  ReleaseDate DATE NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Score (
  ScoreId INT PRIMARY KEY IDENTITY(1,1),
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Score INT NOT NULL CHECK (Score BETWEEN 1 AND 10),
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Reviews (
  ReviewId INT PRIMARY KEY IDENTITY(1,1),
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Review TEXT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GameAwards (
  GameAwardsId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  AwardName NVARCHAR(255) NOT NULL,
  Year INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Developers (
  DeveloperId INT PRIMARY KEY IDENTITY(1,1),
  Name NVARCHAR(255) NOT NULL UNIQUE,
  Description TEXT,
  Website NVARCHAR(255) UNIQUE
);

CREATE TABLE GameDevelopers (
  GameDeveloperId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  DeveloperId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DeveloperId) REFERENCES Developers (DeveloperId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Publishers (
  PublisherId INT PRIMARY KEY IDENTITY(1,1),
  Name NVARCHAR(255) NOT NULL UNIQUE,
  Description TEXT,
  Website NVARCHAR(255) UNIQUE
);

CREATE TABLE GamePublishers (
  GamePublisherId INT PRIMARY KEY IDENTITY(1,1),
  GameId INT NOT NULL,
  PublisherId INT NOT NULL,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PublisherId) REFERENCES Publishers (PublisherId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Wishlist (
  WishlistId INT PRIMARY KEY IDENTITY(1,1),
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Cart (
  CartId INT PRIMARY KEY IDENTITY(1,1),
  UserId INT NOT NULL,
  GameId INT NOT NULL,
  Quantity INT NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Orders (
  OrderId INT PRIMARY KEY IDENTITY(1,1),
  UserId INT NOT NULL,
  OrderDate DATE NOT NULL,
  FOREIGN KEY (UserId) REFERENCES Users (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE OrderItems (
  OrderItemId INT PRIMARY KEY IDENTITY(1,1),
  OrderId INT NOT NULL,
  GameId INT NOT NULL,
  Quantity INT NOT NULL,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0),
  FOREIGN KEY (OrderId) REFERENCES Orders (OrderId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameId) REFERENCES Games (GameId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ExchangeRate (
  ExchangeRateId INT PRIMARY KEY IDENTITY(1,1),
  Currency NVARCHAR(3) NOT NULL UNIQUE,
  [Equal 1 USD] MONEY NOT NULL CHECK ([Equal 1 USD] >= 0)
);

```

<h3> Opis stworzonych widoków </h3>

Wyświetlanie wszystkich gatunków dla każdej gry:

```tsql
CREATE VIEW GameGenresView AS
SELECT GameId, CONVERT(NVARCHAR(MAX), (
  SELECT Genre + ', '
  FROM GameGenres
  WHERE GameId = G.GameId
  FOR XML PATH('')
), 1) AS Genres
FROM GameGenres G
GROUP BY GameId;
```

Wyświetlanie wszystkich deweloperów i wydawców dla każdej gry:

```tsql
CREATE VIEW GameDevelopersAndPublishers AS
SELECT GameDevelopers.GameId, Developers.Name AS Developers, Publishers.Name AS Publishers
FROM GameDevelopers
JOIN Developers ON GameDevelopers.DeveloperId = Developers.DeveloperId
JOIN GamePublishers ON GameDevelopers.GameId = GamePublishers.GameId
JOIN Publishers ON GamePublishers.PublisherId = Publishers.PublisherId
GROUP BY GameDevelopers.GameId, Developers.Name, Publishers.Name;
```

Wyświetlanie odpowiedniej informacji o grach wydanych na rynku wraz z nazwami ich wszystkich wydawców:

```tsql
CREATE VIEW ReleasedGamesWithPublishers AS
SELECT R.GameId, G.Title AS GameTitle, P.Name AS PublisherName, R.ReleaseDate
FROM ReleasedGames R
JOIN Games G ON R.GameId = G.GameId
JOIN GamePublishers GP ON G.GameId = GP.GameId
JOIN Publishers P ON GP.PublisherId = P.PublisherId;
```

Wyświetlanie dziesięciu najlepiej ocenionych gier, sortując rosnąco wyniki według średniej oceny i liczby recenzji:

```tsql
CREATE VIEW TopRatedGames AS
SELECT TOP 10 G.GameID, G.Title, AVG(S.Score) AS AverageScore, COUNT(R.GameId) AS NumberOfReviews
FROM Games G
LEFT JOIN Score S ON G.GameID = S.GameID
LEFT JOIN Reviews R ON G.GameID = R.GameID
GROUP BY G.GameId, G.Title
ORDER BY AverageScore DESC, NumberOfReviews DESC;
```

Wyświetlanie dziesięciu najlepiej sprzedających się gier, sortując malejąco po TotalRevenue:

```tsql
CREATE VIEW TopSellingGames AS
SELECT TOP 10 G.GameId, G.Title, SUM(OI.[Price in USD] * OI.Quantity) AS TotalRevenue
FROM Games G
JOIN OrderItems OI ON G.GameId = OI.GameId
GROUP BY G.GameId, G.Title
ORDER BY TotalRevenue DESC;
```

Wyświetlanie dziesięciu użytkowników (ich nazwy użytkowników i liczbę recenzji) z tabel "Users" i "Reviews", którzy napisali najwięcej recenzji, w kolejności malejącej liczby recenzji:

```tsql
CREATE VIEW MostActiveUsers AS
SELECT TOP 10 U.Username, COUNT(*) AS NumberOfReviews
FROM Users U
JOIN Reviews R ON U.UserId = R.UserId
GROUP BY U.Username
ORDER BY NumberOfReviews DESC;
```
