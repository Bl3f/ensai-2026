SELECT
  tconst AS movie_id,
  primaryTitle as title,
  originalTitle as original_title,
  runtimeMinutes as runtime_minutes
FROM {{ source('bronze', 'title_basics') }}
WHERE
  titleType = 'movie'
  AND isAdult = 0
  AND startYear > '1950'
