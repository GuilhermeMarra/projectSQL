SELECT release_has_artist.release, release_has_artist.artist
FROM release_has_artist
WHERE release_has_artist.contribution = 0;
