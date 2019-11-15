SELECT table1.release as rid , table1.country
FROM release_country as table1, release_country as table2
WHERE table1.release=table2.release and table1.country != table2.country and (table1.year>table2.year or (table1.year=table2.year and table1.month > table2.month) or
                                        (table1.year=table2.year and table1.month = table2.month and table1.day>table2.day) )
GROUP BY table1.release, table1.country
ORDER BY table1.release;