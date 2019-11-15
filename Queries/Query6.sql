SELECT table1.artist, table2.artist, COUNT(*) as count
FROM release_has_artist as table1, release_has_artist as table2
WHERE table1.release = table2.release and table1.artist != table2.artist
GROUP BY (table1.artist, table2.artist);