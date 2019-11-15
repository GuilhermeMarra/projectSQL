SELECT country.name as country, artist.name as name,
(
	SELECT COUNT(*)
	FROM artist as aux1
	WHERE aux1.area = artist.area AND
	      (aux1.syear*10000 + aux1.smonth*100 + aux1.sday < artist.syear*10000 + artist.smonth*100 + artist.sday)
	LIMIT 1
) as nb,
(
	SELECT COUNT(*)
	FROM artist as aux2
	WHERE (aux2.syear*10000 + aux2.smonth*100 + aux2.sday < artist.syear*10000 + artist.smonth*100 + artist.sday)
	LIMIT 1
) as nb_global
FROM artist
INNER JOIN country ON country.id = artist.area
WHERE artist.type = 1;
