create table artist_type
(
    id int PRIMARY KEY NOT NULL,
    name varchar NOT NULL
);

create table gender
(
    id int PRIMARY KEY NOT NULL,
    name varchar NOT NULL
);

create table country
(
    id int PRIMARY KEY NOT NULL,
    name varchar NOT NULL
);


create table artist
(
    id int PRIMARY KEY NOT NULL,
    name varchar NOT NULL,
    gender int REFERENCES gender(id) ON DELETE CASCADE,
    sday int,
    smonth int,
    syear int,
    eday int,
    emonth int,
    eyear int,
    type int DEFAULT 3 REFERENCES artist_type(id) ON DELETE CASCADE,
    area int REFERENCES country(id) ON DELETE SET NULL

    CHECK ( (smonth is null or (smonth <=12 and smonth >=1)) and (sday is null
            or (
                    sday <= 28     --normal february
                    or (sday = 29 and smonth = 2 and syear%4=0 and (syear%100!=0 or syear%400=0))  -- leap syear
                    or (sday <= 30 and (smonth = 4 or smonth = 6 or smonth = 9 or smonth = 11)) --30 sdays
                    or (sday <= 31 and (smonth = 1 or smonth = 3 or smonth = 5 or smonth = 7 or smonth = 8 or smonth = 10 or smonth = 12))

            )
        )
    )


    CHECK ( (emonth is null or (emonth <=12 and emonth >=1)) and (eday is null
            or (
                    eday <= 28     --normal february
                    or (eday = 29 and emonth = 2 and eyear%4=0 and (eyear%100!=0 or eyear%400=0))  -- leap eyear
                    or (eday <= 30 and (emonth = 4 or emonth = 6 or emonth = 9 or emonth = 11)) --30 edays
                    or (eday <= 31 and (emonth = 1 or emonth = 3 or emonth = 5 or emonth = 7 or emonth = 8 or emonth = 10 or emonth = 12))

            )
        )
    )





);



create table release_status
(
    id int PRIMARY KEY NOT NULL,
    name varchar NOT NULL
);

create table release
(
    id int PRIMARY KEY NOT NULL,
    title varchar NOT NULL,
    status int REFERENCES release_status(id) ON DELETE SET NULL,
    barcode numeric(26,0),
    packaging varchar(22)
);



create table release_country   --event
(
    release int NOT NULL REFERENCES release(id),
    country int NOT NULL REFERENCES country(id),
    day int,
    month int,
    year int,
    PRIMARY KEY (release, country),
    --constraint date--

    CHECK ( (month is null or (month <=12 and month >=1)) and (day is null
                or (
                        day <= 28     --normal february
                        or (day = 29 and month = 2 and year%4=0 and (year%100!=0 or year%400=0))  -- leap year
                        or (day <= 30 and (month = 4 or month = 6 or month = 9 or month = 11)) --30 days
                        or (day <= 31 and (month = 1 or month = 3 or month = 5 or month = 7 or month = 8 or month = 10 or month = 12))

                )
            )
    )


);


create table release_has_artist
(
    release int NOT NULL REFERENCES release(id),
    artist int NOT NULL REFERENCES artist(id),
    contribution int NOT NULL,
    PRIMARY KEY (release, artist)
);

create table track
(
    id int PRIMARY KEY NOT NULL,
    name varchar NOT NULL,
    no int,
    length bigint,
    release int NOT NULL REFERENCES release(id)

);

create table track_has_artist
(
    artist int NOT NULL REFERENCES artist(id),
    track int NOT NULL REFERENCES track(id),
    contribution int NOT NULL,
    PRIMARY KEY (artist, track)
);


/*
---PARTICIPATION CONSTRAINT (NOT POSSIBLE TO ADD)
ALTER TABLE release ADD CONSTRAINT
participation
CHECK ( (SELECT COUNT(*)
FROM release_country
WHERE release_country.release = release.id) > 0);
 */


/* --All releases that don't have release country (event)
   --There are some releases that don't have any event, which violates the constraint
SELECT *
FROM release
WHERE ((SELECT COUNT(*)
FROM release_country
WHERE release_country.release = release.id) = 0);
 */