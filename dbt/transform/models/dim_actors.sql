WITH movie_actors AS (
	SELECT DISTINCT actor.id AS actor_id
	FROM {{ ref('movies') }},
	UNNEST(actors) AS actor
)

SELECT 
	p.person_id AS actor_id,
	p.name AS actor_name,
	p.birth_year,
	p.death_year,
	p.profession,
	p.known_for_titles
FROM movie_actors ma
INNER JOIN {{ ref('stg_person') }} p
	ON ma.actor_id = p.person_id
