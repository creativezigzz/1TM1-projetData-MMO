create table personne (
    persId integer not null default autoincrement,
    nomP char(30) not null,
    prenomP char(30) not null,
    mdp char(30) not null,
    CONSTRAINT PK_persId PRIMARY KEY (persId)
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
    persId integer not null,
    animeId integer not null,
    rating integer not null,
    CONSTRAINT PK_persIdanimeIdrating PRIMARY KEY (persId, animeId, rating),
    CONSTRAINT FK_persId FOREIGN KEY (persId) REFERENCES personne(persId),
    CONSTRAINT FK_animeId FOREIGN KEY (animeId) REFERENCES anime(animeId)
);