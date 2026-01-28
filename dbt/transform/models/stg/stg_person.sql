SELECT 
	nconst AS person_id,
	primaryName AS name,
	birthYear AS birth_year,
	deathYear AS death_year,
	primaryProfession AS profession,
	knownForTitles AS known_for_titles
FROM {{ source('bronze', 'name_basics') }}
WHERE
	birthYear != r'\N'
	AND knownForTitles != r'\N'