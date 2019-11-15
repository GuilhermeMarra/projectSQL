SELECT country.name, artist.name
FROM artist, country
WHERE artist.area = country.id and artist.area = (SELECT   artist.area
                                                    FROM     artist
                                                    GROUP BY artist.area
                                                    ORDER BY COUNT(artist.area) DESC
                                                    LIMIT 1)
ORDER BY artist.name;