# aktorzy w filmie <id>
SELECT a.LastName, a.Name, m.Title
FROM Movies m
       join ActorsMovies am on am.MovieId = m.MovieId
       join Actors a on am.ActorId = a.ActorId
where m.MovieId = 2;
# reżyserzy filmu '%<tytul>%'
SELECT d.Name, d.LastName
FROM Directors d
       join DirectorsMovies dm on dm.DirectorId = d.DirectorId
       join Movies m on m.MovieId = dm.MovieId
where m.Title like '%Kevin%';
# filmy, w których grał aktor <id>
SELECT a.Name, a.LastName, m.Title
from Movies m
       join actorsmovies on m.MovieId = actorsmovies.MovieId
       join Actors a on actorsmovies.ActorId = a.ActorId
where a.ActorId = 5;
# filmy, w których grali aktorzy urodzeni w <kraj>
SELECT m.Title, count(a.LastName)
from Movies m
       join ActorsMovies on m.MovieId = ActorsMovies.MovieId
       join Actors a on a.ActorId = ActorsMovies.ActorId
       join DIC_Country on a.CountryId = DIC_Country.CountryId
where DIC_Country.CountryName = 'USA'
order by a.LastName desc;
# aktorzy w wieku powyżej <lat> oraz ich filmy (funkcja 'year')
SELECT a.LastName, m.Title
from Actors a
       join ActorsMovies on a.ActorId = ActorsMovies.ActorId
       join Movies m on m.MovieId = ActorsMovies.MovieId
where year(now()) - year(a.BirthDate) > 26;
# najstarszy / najmłodszy aktor lub aktorka
SELECT LastName, BirthDate
from Actors
order by BirthDate desc
limit 1;
# ilu aktorów urodziło się w <rok>
SELECT COUNT(a.LastName)
from Actors a
where year(a.BirthDate) = 1946;
# ile filmów powstało w <nazwa wytwórni>
SELECT COUNT(Movies.Title) as MoviesCount
from Movies
       join StudioMovies on StudioMovies.MovieId = movies.MovieId
       join DIC_Studio on DIC_Studio.StudioId = StudioMovies.StudioId
where DIC_Studio.StudioName = 'MGM';

# filmy które miały premierę w roku urodzenia aktora <id>
SELECT Movies.Title, Movies.ProductionYear, Actors.Name, Actors.LastName, Actors.BirthDate
from Movies
       join Actors on Movies.ProductionYear = year(Actors.BirthDate)
where Actors.ActorId = 22;
# średnia liczba aktorów w filmach reżysera <id>
SELECT AVG(s.count) as Average
from (
       SELECT m.MovieId, COUNT(a.ActorId) as count
       from Actors a
              join ActorsMovies am on a.ActorId = am.ActorId
              join Movies m on am.MovieId = m.MovieId
              join DirectorsMovies dm on m.MovieId = dm.MovieId
       where dm.DirectorId = 2
       group by m.MovieId) s;

# liczba filmów per rok (group by)
SELECT COUNT(Title) as CountPerYear, ProductionYear
from Movies
group by ProductionYear
ORDER BY CountPerYear, ProductionYear;

# aktorzy, którzy grali w filmach z gatunku <id>
SELECT DISTINCT a.LastName
from Actors a
       join ActorsMovies am on a.ActorId = am.ActorId
       join DIC_GenreMovie gm on am.MovieId = gm.MovieId
       join DIC_Genre g on g.GenreId = gm.GenreId
where g.GenreName = 'komedia';

# który aktor grał w największej liczbie filmów gatunku <nazwa>
SELECT DISTINCT Count(a.LastName) as ct, a.LastName, a.Name
from Actors a
       join ActorsMovies am on a.ActorId = am.ActorId
       join DIC_GenreMovie gm on gm.MovieId = am.MovieId
       join DIC_Genre g on g.GenreId = gm.GenreId
where g.GenreName = 'komedia'
group by a.LastName, a.LastName
ORDER BY ct desc
limit 1;

# SELECT *
# From (
#        SELECT DISTINCT Count(a.LastName) as ct, a.LastName, a.Name
#        from Actors a
#               join ActorsMovies am on a.ActorId = am.ActorId
#               join DIC_GenreMovie gm on gm.MovieId = am.MovieId
#               join DIC_Genre g on g.GenreId = gm.GenreId
#        where g.GenreName = 'komedia'
#        group by a.LastName, a.LastName
#        ORDER BY ct desc
#      ) count where ct = max(count.ct);

# reżyserzy, z którymi współpracowal aktor <id>
SELECT m.Title, d.LastName, d.Name
From Actors a
       join ActorsMovies am on a.ActorId = am.ActorId
       join Movies m on m.MovieId = am.MovieId
       join DirectorsMovies dm on dm.MovieId = m.MovieId
       join Directors d on d.DirectorId = dm.DirectorId
where a.ActorId = 5;

# reżyserzy, z którymi współpracowali aktorzy urodzeni w <rok>
SELECT d.Name, d.LastName
FROM Directors d
       join DirectorsMovies dm on dm.DirectorId = d.DirectorId
       join Movies m on m.MovieId = dm.MovieId
       join ActorsMovies am on am.MovieId = m.MovieId
       join Actors a on a.ActorId = am.ActorId
where year(a.BirthDate) = 1955;

# reżyserzy, którzy nakręcili film w języku <nazwa>
SELECT d.Name, d.LastName
FROM Directors d
       join DirectorsMovies dm on dm.DirectorId = d.DirectorId
       join LanguageMovies lm on lm.MovieId = dm.MovieId
       join DIC_Language l on l.LanguageId = lm.LanguageId
where l.LanguageName = 'polski';

# reżyserzy, którzy nakręcili film dla wytwórni <id>
SELECT d.Name, d.LastName
FROM Directors d
            join DirectorsMovies dm on dm.DirectorId = d.DirectorId
            join StudioMovies sm on sm.MovieId = dm.MovieId
where sm.StudioId = 1;

# gatunki filmów nakręconych w języku <id>
SELECT DISTINCT DIC_Genre.GenreName
FROM DIC_Genre
       join DIC_GenreMovie on DIC_GenreMovie.GenreId = DIC_Genre.GenreId
       join LanguageMovies on LanguageMovies.MovieId = DIC_GenreMovie.MovieId
where LanguageMovies.LanguageId = 1;

# wszystkie wytwórnie i filmy dla każdej z nich
SELECT s.StudioName, m.Title FROM DIC_Studio s
join StudioMovies sm on s.StudioId = sm.StudioId
join Movies m on m.MovieId = sm.MovieId;

# wszystkie kraje i urodzeni w nich aktorzy
INSERT into DIC_Country(CountryName) VALUES ('Finlandia');
SELECT c.CountryName, a.Name, a.LastName
FROM DIC_Country c
       left join Actors a on a.CountryId = c.CountryId;

# filmy zawierające frazę <query> w tytule
SELECT m.Title FROM Movies m
where m.Title LIKE '%kazani%';

# imię i nazwisko aktorów, którzy zagrali w filmie z aktorem <id>
SELECT a.LastName, a.Name FROM Actors a
join ActorsMovies am on am.ActorId = a.ActorId
where a.ActorId = 1;

# reżyser, który nakręcił najwięcej filmów
SELECT d.LastName, COUNT(m.Title) as count FROM Directors d
join DirectorsMovies dm on dm.DirectorId = d.DirectorId
join Movies m on m.MovieId = dm.MovieId
GROUP BY d.LastName;

# filmy wyprodukowane po roku <rok> i wydane na <form_id>
SELECT m.Title from Movies m
join FormMovies fm on m.MovieId = fm.MovieId
where m.ProductionYear > 1980 AND fm.FormId = 1;

# zmodyfikuj tabelę Actors dodając pole Gender varchar(1), następnie używając update z where ActorId in (<ids>) ustaw wartość (M lub F)
ALTER TABLE Actors
  ADD COLUMN Gender varchar(1) NOT NULL default '';
UPDATE Actors
SET Gender = 'M';
UPDATE Actors
SET Gender = 'F'
where ActorId in (3, 8, 12);

#   pobierz najstarszą / najmłodszą aktorkę (używając ^gender)
SELECT Name, LastName, BirthDate
from Actors
where Gender = 'F'
ORDER BY BirthDate
limit 1;

#   zmodyfikuj tabelę movie dodając pole rating, następnie uzupełnij je losową wartością z przedziału 1-10
ALTER TABLE Movies
  ADD COLUMN Rating float not null default 0;
UPDATE Movies
SET Rating = RAND() * 9 + 1;

SELECT Movies.Title, Movies.Rating
FROM Movies
ORDER BY Rating DESC;
SELECT Movies.Title, Movies.Rating
FROM Movies
WHERE Rating BETWEEN 5 AND 6
ORDER BY Rating DESC;

#   pobierz wszystkie filmy o ocenie większej niż <val>
SELECT m.Title, m.Rating FROM Movies m where m.Rating > 4;

#   znajdź aktorów którzy grali w filmach z oceną poniżej <val>
SELECT Actors.Name, Actors.LastName
FROM Actors
       join ActorsMovies on Actors.ActorId = ActorsMovies.ActorId
       join Movies on Movies.MovieId = ActorsMovies.MovieId
where Movies.Rating < 5
  AND Movies.CountryId = 2;

#   jaki procent filmów ma ocenę większą niż <val>
SELECT (ct.ct / tot.tot) * 100 as percent
from (
       SELECT COUNT(MovieId) as tot
       from Movies) tot,
     (
       SELECT COUNT(MovieId) as ct
       from Movies
       where Rating > 4) ct;
#   średnia ocen wszystkich filmów
SELECT AVG(Rating)
from Movies;

#   język, w którym nakręcone zostało najwięcej filmów
SELECT COUNT(DIC_Language.LanguageId), DIC_Language.LanguageName
FROM DIC_Language
       join LanguageMovies on DIC_Language.LanguageId = languagemovies.LanguageId
       join Movies on LanguageMovies.MovieId = Movies.MovieId
group by DIC_Language.LanguageName;

SELECT Movies.Title
From Movies
       join LanguageMovies on LanguageMovies.MovieId = Movies.MovieId
       join DIC_Language on DIC_Language.LanguageId = LanguageMovies.LanguageId
where DIC_Language.LanguageName = 'hiszpański';