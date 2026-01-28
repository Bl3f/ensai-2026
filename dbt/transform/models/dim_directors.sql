WITH movie_directors AS (
	SELECT DISTINCT director.id AS director_id
	FROM {{ ref('movies') }},
	UNNEST(directors) AS director
)

SELECT 
	p.person_id AS director_id,
	p.name AS director_name,
	p.birth_year,
	p.death_year,
	p.profession,
	p.known_for_titles
FROM movie_directors md
INNER JOIN {{ ref('stg_person') }} p
	ON md.director_id = p.person_id
