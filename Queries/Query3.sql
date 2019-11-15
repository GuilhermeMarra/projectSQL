SELECT artist.id
FROM release_country, release_has_artist, country, artist
WHERE release_has_artist.artist = artist.id and release_has_artist.release = release_country.release
        and  release_country.country = country.id and country.name LIKE 'A%'
GROUP BY artist.id
ORDER BY  artist.id;