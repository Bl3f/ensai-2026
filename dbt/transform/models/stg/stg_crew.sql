WITH exploded_directors AS (
	SELECT 
		tconst AS movie_id,
		director_id
	FROM {{ source('bronze', 'title_crew') }},
	UNNEST(SPLIT(directors, ',')) AS director_id
	WHERE directors != r'\N'
)

SELECT 
	ed.movie_id,
	ed.director_id,
	p.name AS director_name,
	p.birth_year,
	p.profession
FROM exploded_directors ed
LEFT JOIN {{ ref('stg_person') }} p
	ON ed.director_id = p.person_id