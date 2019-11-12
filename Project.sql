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




-- The commands needed in order to drop all the constraints from the database

SELECT 'ALTER TABLE "'||nspname||'"."'||relname||'" DROP CONSTRAINT "'||conname||'" CASCADE;'
FROM pg_constraint
INNER JOIN pg_class ON conrelid=pg_class.oid
INNER JOIN pg_namespace ON pg_namespace.oid=pg_class.relnamespace
WHERE nspname = current_schema()
ORDER BY CASE WHEN contype='f' THEN 0 ELSE 1 END,contype,nspname,relname,conname;


ALTER TABLE "public"."artist" DROP CONSTRAINT "artist_area_fkey" CASCADE;
ALTER TABLE "public"."artist" DROP CONSTRAINT "artist_gender_fkey" CASCADE;
ALTER TABLE "public"."artist" DROP CONSTRAINT "artist_type_fkey" CASCADE;
ALTER TABLE "public"."release" DROP CONSTRAINT "release_status_fkey" CASCADE;
ALTER TABLE "public"."release_country" DROP CONSTRAINT "release_country_country_fkey" CASCADE;
ALTER TABLE "public"."release_country" DROP CONSTRAINT "release_country_release_fkey" CASCADE;
ALTER TABLE "public"."release_has_artist" DROP CONSTRAINT "release_has_artist_artist_fkey" CASCADE;
ALTER TABLE "public"."release_has_artist" DROP CONSTRAINT "release_has_artist_release_fkey" CASCADE;
ALTER TABLE "public"."track" DROP CONSTRAINT "track_release_fkey" CASCADE;
ALTER TABLE "public"."track_has_artist" DROP CONSTRAINT "track_has_artist_artist_fkey" CASCADE;
ALTER TABLE "public"."track_has_artist" DROP CONSTRAINT "track_has_artist_track_fkey" CASCADE;
ALTER TABLE "public"."artist" DROP CONSTRAINT "artist_check" CASCADE;
ALTER TABLE "public"."artist" DROP CONSTRAINT "artist_check1" CASCADE;
ALTER TABLE "public"."release_country" DROP CONSTRAINT "release_country_check" CASCADE;
ALTER TABLE "public"."artist" DROP CONSTRAINT "artist_pkey" CASCADE;
ALTER TABLE "public"."artist_type" DROP CONSTRAINT "artist_type_pkey" CASCADE;
ALTER TABLE "public"."country" DROP CONSTRAINT "country_pkey" CASCADE;
ALTER TABLE "public"."gender" DROP CONSTRAINT "gender_pkey" CASCADE;
ALTER TABLE "public"."release" DROP CONSTRAINT "release_pkey" CASCADE;
ALTER TABLE "public"."release_country" DROP CONSTRAINT "release_country_pkey" CASCADE;
ALTER TABLE "public"."release_has_artist" DROP CONSTRAINT "release_has_artist_pkey" CASCADE;
ALTER TABLE "public"."release_status" DROP CONSTRAINT "release_status_pkey" CASCADE;
ALTER TABLE "public"."track" DROP CONSTRAINT "track_pkey" CASCADE;
ALTER TABLE "public"."track_has_artist" DROP CONSTRAINT "track_has_artist_pkey" CASCADE;




--READ ALL
copy gender from '/Users/gui_marra/Documents/X/3A/Projects/SQL Project/mbdump_reduced/gender';
copy artist_type from '/Users/gui_marra/Documents/X/3A/Projects/SQL Project/mbdump_reduced/artist_type';
copy country from '/Users/gui_marra/Documents/X/3A/Projects/SQL Project/mbdump_reduced/country';
copy artist from '/Users/gui_marra/Documents/X/3A/Projects/SQL Project/mbdump_reduced/artist';

copy release_status from '/Users/gui_marra/Documents/X/3A/Projects/SQL Project/mbdump_reduced/release_status';
copy release from '/Users/gui_marra/Documents/X/3A/Projects/SQL Project/mbdump_reduced/release';
copy release_country from '/Users/gui_marra/Documents/X/3A/Projects/SQL Project/mbdump_reduced/release_country';
copy release_has_artist from '/Users/gui_marra/Documents/X/3A/Projects/SQL Project/mbdump_reduced/release_has_artist';

copy track from '/Users/gui_marra/Documents/X/3A/Projects/SQL Project/mbdump_reduced/track';
copy track_has_artist from '/Users/gui_marra/Documents/X/3A/Projects/SQL Project/mbdump_reduced/track_has_artist';




-- The commands needed in order to add all constraints dropped from the database
SELECT 'ALTER TABLE "'||nspname||'"."'||relname||'" ADD CONSTRAINT "'||conname||'" '
||pg_get_constraintdef(pg_constraint.oid)||';'
FROM pg_constraint
INNER JOIN pg_class ON conrelid=pg_class.oid
INNER JOIN pg_namespace ON pg_namespace.oid=pg_class.relnamespace
WHERE nspname = current_schema()
ORDER BY CASE WHEN contype='f' THEN 0 ELSE 1 END DESC,contype DESC,nspname DESC,
relname DESC,conname DESC;



ALTER TABLE "public"."track_has_artist" ADD CONSTRAINT "track_has_artist_pkey" PRIMARY KEY (artist, track);
ALTER TABLE "public"."track" ADD CONSTRAINT "track_pkey" PRIMARY KEY (id);
ALTER TABLE "public"."release_status" ADD CONSTRAINT "release_status_pkey" PRIMARY KEY (id);
ALTER TABLE "public"."release_has_artist" ADD CONSTRAINT "release_has_artist_pkey" PRIMARY KEY (release, artist);
ALTER TABLE "public"."release_country" ADD CONSTRAINT "release_country_pkey" PRIMARY KEY (release, country);
ALTER TABLE "public"."release" ADD CONSTRAINT "release_pkey" PRIMARY KEY (id);
ALTER TABLE "public"."gender" ADD CONSTRAINT "gender_pkey" PRIMARY KEY (id);
ALTER TABLE "public"."country" ADD CONSTRAINT "country_pkey" PRIMARY KEY (id);
ALTER TABLE "public"."artist_type" ADD CONSTRAINT "artist_type_pkey" PRIMARY KEY (id);
ALTER TABLE "public"."artist" ADD CONSTRAINT "artist_pkey" PRIMARY KEY (id);
ALTER TABLE "public"."release_country" ADD CONSTRAINT "release_country_check" CHECK ((((month IS NULL) OR ((month <= 12) AND (month >= 1))) AND ((day IS NULL) OR ((day <= 28) OR ((day = 29) AND (month = 2) AND ((year % 4) = 0) AND (((year % 100) <> 0) OR ((year % 400) = 0))) OR ((day <= 30) AND ((month = 4) OR (month = 6) OR (month = 9) OR (month = 11))) OR ((day <= 31) AND ((month = 1) OR (month = 3) OR (month = 5) OR (month = 7) OR (month = 8) OR (month = 10) OR (month = 12)))))));
ALTER TABLE "public"."artist" ADD CONSTRAINT "artist_check1" CHECK ((((emonth IS NULL) OR ((emonth <= 12) AND (emonth >= 1))) AND ((eday IS NULL) OR ((eday <= 28) OR ((eday = 29) AND (emonth = 2) AND ((eyear % 4) = 0) AND (((eyear % 100) <> 0) OR ((eyear % 400) = 0))) OR ((eday <= 30) AND ((emonth = 4) OR (emonth = 6) OR (emonth = 9) OR (emonth = 11))) OR ((eday <= 31) AND ((emonth = 1) OR (emonth = 3) OR (emonth = 5) OR (emonth = 7) OR (emonth = 8) OR (emonth = 10) OR (emonth = 12)))))));
ALTER TABLE "public"."artist" ADD CONSTRAINT "artist_check" CHECK ((((smonth IS NULL) OR ((smonth <= 12) AND (smonth >= 1))) AND ((sday IS NULL) OR ((sday <= 28) OR ((sday = 29) AND (smonth = 2) AND ((syear % 4) = 0) AND (((syear % 100) <> 0) OR ((syear % 400) = 0))) OR ((sday <= 30) AND ((smonth = 4) OR (smonth = 6) OR (smonth = 9) OR (smonth = 11))) OR ((sday <= 31) AND ((smonth = 1) OR (smonth = 3) OR (smonth = 5) OR (smonth = 7) OR (smonth = 8) OR (smonth = 10) OR (smonth = 12)))))));
ALTER TABLE "public"."track_has_artist" ADD CONSTRAINT "track_has_artist_track_fkey" FOREIGN KEY (track) REFERENCES track(id);
ALTER TABLE "public"."track_has_artist" ADD CONSTRAINT "track_has_artist_artist_fkey" FOREIGN KEY (artist) REFERENCES artist(id);
ALTER TABLE "public"."track" ADD CONSTRAINT "track_release_fkey" FOREIGN KEY (release) REFERENCES release(id);
ALTER TABLE "public"."release_has_artist" ADD CONSTRAINT "release_has_artist_release_fkey" FOREIGN KEY (release) REFERENCES release(id);
ALTER TABLE "public"."release_has_artist" ADD CONSTRAINT "release_has_artist_artist_fkey" FOREIGN KEY (artist) REFERENCES artist(id);
ALTER TABLE "public"."release_country" ADD CONSTRAINT "release_country_release_fkey" FOREIGN KEY (release) REFERENCES release(id);
ALTER TABLE "public"."release_country" ADD CONSTRAINT "release_country_country_fkey" FOREIGN KEY (country) REFERENCES country(id);
ALTER TABLE "public"."release" ADD CONSTRAINT "release_status_fkey" FOREIGN KEY (status) REFERENCES release_status(id) ON DELETE SET NULL;
ALTER TABLE "public"."artist" ADD CONSTRAINT "artist_type_fkey" FOREIGN KEY (type) REFERENCES artist_type(id) ON DELETE CASCADE;
ALTER TABLE "public"."artist" ADD CONSTRAINT "artist_gender_fkey" FOREIGN KEY (gender) REFERENCES gender(id) ON DELETE CASCADE;
ALTER TABLE "public"."artist" ADD CONSTRAINT "artist_area_fkey" FOREIGN KEY (area) REFERENCES country(id) ON DELETE SET NULL;


/*
DROP TABLE gender CASCADE;
DROP TABLE artist_type CASCADE;
DROP TABLE country CASCADE;
DROP TABLE artist CASCADE;
DROP TABLE track CASCADE;
DROP TABLE  release CASCADE;
DROP TABLE  release_has_artist CASCADE;
DROP TABLE  release_status CASCADE;
DROP TABLE  release_country CASCADE;
DROP TABLE  track_has_artist CASCADE;*/





