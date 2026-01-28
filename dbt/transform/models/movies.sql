WITH directors_agg AS (
	SELECT 
		movie_id,
		ARRAY_AGG(
			STRUCT(
				director_id AS id,
				director_name AS name,
				birth_year AS birth_year
			) ORDER BY director_name
		) AS directors
	FROM {{ ref('stg_crew') }}
	WHERE director_name IS NOT NULL
	GROUP BY movie_id
),

actors_agg AS (
	SELECT 
		movie_id,
		ARRAY_AGG(
			STRUCT(
				actor_id AS id,
				actor_name AS name,
				birth_year AS birth_year,
				death_year AS death_year,
				characters AS characters,
				gender AS gender
			) IGNORE NULLS ORDER BY ordering
		) AS actors
	FROM {{ ref('stg_actor') }}
	GROUP BY movie_id
)

SELECT
	/* Title basics */
	t.movie_id,
	t.title,
	t.original_title,
	t.runtime_minutes,
	t.release_year,

	/* Ratings */
	r.average_rating,
	r.num_votes,

	/* Crew */
	d.directors,
	a.actors
	
FROM {{ ref('stg_title_basics') }} t
INNER JOIN {{ ref('stg_ratings') }} r
	ON t.movie_id = r.movie_id
LEFT JOIN directors_agg d
	ON d.movie_id = t.movie_id
LEFT JOIN actors_agg a
	ON a.movie_id = t.movie_id
