SELECT country.name, artist.name
FROM artist, country
WHERE artist.area = country.id
ORDER BY country.name, artist.name;
