CREATE VIEW ArtistsOrdered AS
    (SELECT row_number() OVER (ORDER BY A.syear, A.smonth, A.sday) - 1 AS nb_global,
            row_number() OVER (PARTITION BY area ORDER BY area, syear, smonth, sday) - 1 AS nb, *
    FROM Artist A
    WHERE A.syear IS NOT NULL AND A.smonth IS NOT NULL AND A.sday IS NOT NULL);

SELECT C.name as country, P0.name as name, P0.nb, P0.nb_global
FROM ArtistsOrdered P0
INNER JOIN country c on P0.area = c.id
WHERE P0.type = 1
ORDER BY nb, nb_global;
