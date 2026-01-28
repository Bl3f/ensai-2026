WITH actor_principals AS (
	SELECT 
		tconst AS movie_id,
		ordering,
		nconst AS actor_id,
		category,
		characters
	FROM {{ source('bronze', 'title_principals') }}
	WHERE category IN ('actor', 'actress')
)

SELECT 
	ap.movie_id,
	ap.ordering,
	ap.actor_id,
	p.name AS actor_name,
	ap.category,
	CASE 
		WHEN ap.category = 'actor' THEN 'Male'
		WHEN ap.category = 'actress' THEN 'Female'
		ELSE NULL
	END AS gender,
	ap.characters,
	p.birth_year,
	p.death_year,
	p.profession
FROM actor_principals ap
LEFT JOIN {{ ref('stg_person') }} p
	ON ap.actor_id = p.person_id
