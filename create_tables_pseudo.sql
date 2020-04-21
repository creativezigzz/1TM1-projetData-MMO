create table personne (
    pseudo char(30) not null,
    nomP char(30) not null,
    prenomP char(30) not null,
    mdp char(30) not null,
    CONSTRAINT PK_pseudo PRIMARY KEY (pseudo)
);

create table genre(
    genrId integer not null default autoincrement,
    genrNom char(30) not null, 
    CONSTRAINT PK_genrId PRIMARY KEY (genrId)
);

create table anime (
    animeId integer not null default autoincrement,
    titre char(60) not null,
    genrId integer not null,
    CONSTRAINT PK_animeId PRIMARY KEY (animeId),
    CONSTRAINT FK_genrId FOREIGN KEY (genrId) REFERENCES genre(genrId)
);

create table myList (
    pseudo char(30) not null,
    animeId integer not null,
    rating integer not null,
    CONSTRAINT PK_pseudoanimeIdrating PRIMARY KEY (pseudo, animeId, rating),
    CONSTRAINT FK_pseudo FOREIGN KEY (pseudo) REFERENCES personne(pseudo),
    CONSTRAINT FK_animeId FOREIGN KEY (animeId) REFERENCES anime(animeId)
);