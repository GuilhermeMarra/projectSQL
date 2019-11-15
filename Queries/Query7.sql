SELECT release_country.country, track.release
FROM track, release_country
WHERE track.release = release_country.release
GROUP BY track.release, release_country.country
HAVING COUNT (track.release) > 1;