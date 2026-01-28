SELECT
  tconst AS movie_id,
  averageRating AS average_rating,
  numVotes AS num_votes
FROM {{ source('bronze', 'title_ratings') }}
WHERE
	averageRating IS NOT NULL
	AND numVotes > 10000