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

W niżej przedstawionym opisie są zaznaczone wszystkie występujące więzy integralności (NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK, DEFAULT, CREATE INDEX) dla każdej tabeli istniejącej w zaprojektowanej bazie danych.

```tsql
 CREATE TABLE Users (
  UserID INT PRIMARY KEY IDENTITY(1,1),
  Username NVARCHAR(255) NOT NULL,
  Email NVARCHAR(255) NOT NULL UNIQUE,
  Password NVARCHAR(255) NOT NULL
);

CREATE TABLE LoginAttempts (
  LoginAttemptID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  Time DATETIME NOT NULL,
  Success BIT NOT NULL DEFAULT 0,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UserBans (
  BanID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  BanStart DATETIME NOT NULL,
  BanEnd DATETIME NOT NULL
);

CREATE TABLE Games (
  GameID INT PRIMARY KEY IDENTITY(1,1),
  Title NVARCHAR(255) NOT NULL,
  LastUpdatedDate DATE NOT NULL,
  Description TEXT,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0)
);

CREATE TABLE GameGenres (
  GameGenreID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  Genre NVARCHAR(255) NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Platforms (
  PlatformID INT PRIMARY KEY IDENTITY(1,1),
  Name NVARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE GamePlatforms (
  GamePlatformID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  PlatformID INT NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PlatformID) REFERENCES Platforms (PlatformID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UpcomingGames (
  UpcomingGameID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  TrailerUrl NVARCHAR(255),
  ExpectedDeliveryDate DATE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PreOrderGames (
  PreOrderGameID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  PreOrderBonus TEXT,
  PreOrderDiscount DECIMAL(2),
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE BetaGames (
  BetaGameID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  BetaStartDate DATE NOT NULL,
  BetaEndDate DATE NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ReleasedGames (
  ReleasedGameID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  ReleaseDate DATE NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Score (
  ScoreID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  GameID INT NOT NULL,
  Score INT NOT NULL CHECK (Score BETWEEN 1 AND 10),
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Reviews (
  ReviewID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  GameID INT NOT NULL,
  Review TEXT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GameAwards (
  GameAwardsID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  AwardName NVARCHAR(255) NOT NULL,
  Year INT NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Developers (
  DeveloperID INT PRIMARY KEY IDENTITY(1,1),
  Name NVARCHAR(255) NOT NULL UNIQUE,
  Description TEXT,
  Website NVARCHAR(255) UNIQUE
);

CREATE TABLE GameDevelopers (
  GameDeveloperID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  DeveloperID INT NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DeveloperID) REFERENCES Developers (DeveloperID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Publishers (
  PublisherID INT PRIMARY KEY IDENTITY(1,1),
  Name NVARCHAR(255) NOT NULL UNIQUE,
  Description TEXT,
  Website NVARCHAR(255) UNIQUE
);

CREATE TABLE GamePublishers (
  GamePublisherID INT PRIMARY KEY IDENTITY(1,1),
  GameID INT NOT NULL,
  PublisherID INT NOT NULL,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PublisherID) REFERENCES Publishers (PublisherID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Wishlist (
  WishlistID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  GameID INT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Cart (
  CartID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  GameID INT NOT NULL,
  Quantity INT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY IDENTITY(1,1),
  UserID INT NOT NULL,
  OrderDate DATE NOT NULL,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE OrderItems (
  OrderItemID INT PRIMARY KEY IDENTITY(1,1),
  OrderID INT NOT NULL,
  GameID INT NOT NULL,
  Quantity INT NOT NULL,
  [Price in USD] MONEY NOT NULL CHECK ([Price in USD] >= 0),
  FOREIGN KEY (OrderID) REFERENCES Orders (OrderID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (GameID) REFERENCES Games (GameID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ExchangeRate (
  ExchangeRateID INT PRIMARY KEY IDENTITY(1,1),
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

Przykładowe zastosowanie:

```tsql
SELECT * FROM GameGenresView;
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

Przykładowe zastosowanie:

```tsql
SELECT * FROM GameDevelopersAndPublishers;
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

Przykładowe zastosowanie:

```tsql
SELECT * FROM ReleasedGamesWithPublishers;
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

Przykładowe zastosowanie:

```tsql
SELECT * FROM TopRatedGames;
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

Przykładowe zastosowanie:

```tsql
SELECT * FROM TopSellingGames;
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

Przykładowe zastosowanie:

```tsql
SELECT * FROM MostActiveUsers;
```

<h3> Opis procedur składowanych </h3>

Procedura zalecająca gry danemu użytkownikowi na podstawie gier zakupionych przez innych użytkowników, którzy dzielą wspólne zakupy z danym użytkownikiem, przy czym w pierwszej kolejności występują gry, które są posiadane przez użytkówników o największej liczcbie wspólnych gier z danym użytkownikiem.

```tsql
REATE PROCEDURE GetRecommendedGames (@UserID INT)
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
```

Przykładowe zastosowanie:

```tsql
EXEC GetRecommendedGames 4;
```

Procedura podejmująca próbe logowania do konta użytkownika. Sprawdza, czy dane logowania użytkownika są prawidłowe, weryfikując jego nazwę użytkownika i hasło w bazie danych, a także sprawdza, czy użytkownik jest aktualnie zbanowany. Jeśli użytkownik nie jest zbanowany, a jego poświadczenia są prawidłowe, procedura zwraca wartość 1, co wskazuje na pomyślne logowanie. Procedura rejestruje również próbę logowania w tabeli LoginAttempts. Jeśli użytkownik został zbanowany lub dane logowania są nieprawidłowe, procedura zwraca wartość 0, co wskazuje na nieudane logowanie. Procedura generuje również komunikat wskazujący, czy logowanie powiodło się, czy nie.

```tsql
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
END;
```

Przykładowe zastosowanie:

*Po pięciokrotnym podaniu nipoprawnego hasła użytkownik zostaje zbanowany i próba logowania nawet z poprawnym hasłem kończy się niepowodzeniem.*

```tsql
BEGIN
  DECLARE @ok BIT
  EXEC @ok = dbo.userLogin 'jim_smith', 'passw0rd'
  SELECT IIF (@ok = 1, 'SUCCESSFUL', 'FAILED') AS [Login Attempt]
  EXEC @ok = dbo.userLogin 'jim_smith', '000000'
  SELECT IIF (@ok = 1, 'SUCCESSFUL', 'FAILED') AS [Login Attempt]
  EXEC @ok = dbo.userLogin 'jim_smith', '000000'
  EXEC @ok = dbo.userLogin 'jim_smith', '000000'
  EXEC @ok = dbo.userLogin 'jim_smith', '000000'
  EXEC @ok = dbo.userLogin 'jim_smith', '000000'
  EXEC @ok = dbo.userLogin 'jim_smith', 'passw0rd'
  SELECT IIF (@ok = 1, 'SUCCESSFUL', 'FAILED') AS [Login Attempt]
SELECT * FROM UserBans
END;
```

Procedura pobiera łączną sprzedaż określonej gry lub wszystkich gier między określoną datą początkową a końcową i zwraca wynik posortowany według sprzedaży każdej gry w kolejności malejącej.

```tsql
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
```

Przykładowe zastosowanie:

```tsql
EXEC CalculateTotalSales;
```

Procedura wyszukiwająca wszystkich użytkowników, których nazwa użytkownika zawiera określony ciąg znaków. Zwraca identyfikator użytkownika i nazwę użytkownika wszystkich pasujących użytkowników.

```tsql
CREATE PROCEDURE SearchUsers
  @Username NVARCHAR(255)
AS
  SELECT UserID, Username 
  FROM Users
  WHERE Username LIKE '%' + @Username + '%';
```

Przykładowe zastosowanie:

```tsql
EXEC SearchUsers 'jo';
```

Procedura wyszukiwająca największych konsumentów na podstawie ich łącznych wydatków lub liczby gier kupionych w danym okresie, z opcją sortowania według dowolnej metryki.

```tsql
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
```

Przykładowe zastosowanie:

```tsql
EXEC GetBiggestConsumers '2022-12-01', '2022-12-31', 'GamesBought';
```

Procedura wyśwetlająca historię zakupów danego użytkownika, w tym datę zamówienia, tytuł gry i cenę każdej zakupionej gry. Wynik jest sortowany według daty zamówienia i identyfikatora zamówienia.

```tsql
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
```

Przykładowe zastosowanie:

```tsql
EXEC GetUserPurchaseHistory 2;
```

<h3> Opis wyzwalaczy </h3>


<h3> Opis programu klienckiego </h3>

Program kliencki jest realizowany w języku Python. W programie są wykorzystywane odpowiednie biblioteki pozwalające na wyświetlanie rekordów tabeli Games w czasie rzeczywistym wraz z możliwością realizacji nastepujących operujących się na tej samej tabele operacji:

- Dodawanie rekordu;
- Usuwanie rekordu;
- Edytowanie rekordu;
- Wyszykiwanie rekordu przez wyszukiwanie nazwy gry;
- Konwertacja cen wszystkich gier na inną walutę wedlug znanego kursu;

<h3> Skrypt tworzący bazę danych </h3>
