-- Netflix Data Analysis using SQL by Aaron Mascarenhas

-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY 1

-- 2. Find the most common rating for movies and TV shows

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * 
FROM netflix
WHERE release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix

SELECT * 
FROM
(
	SELECT 
		-- country,
		UNNEST(STRING_TO_ARRAY(country, ',')) as country,
		COUNT(*) as total_content
	FROM netflix
	GROUP BY 1
)as t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5


-- 5. Identify the longest movie

SELECT 
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC


-- 6. List content where the title starts with 'The'

SELECT *
FROM netflix
WHERE title ILIKE 'The%';


-- 7. Find all the movies/TV shows by director 'Christopher Nolan'!

SELECT *
FROM
(

SELECT 
	*,
	UNNEST(STRING_TO_ARRAY(director, ',')) as director_name
FROM 
netflix
)
WHERE 
	director_name = 'Christopher Nolan'



-- 8. Find the number of TV shows released each year

SELECT 
	release_year,
	COUNT(*) AS tv_show_count
FROM netflix
WHERE type = 'TV Show'
GROUP BY release_year
ORDER BY release_year;


-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1


-- 10. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries'



-- 11. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL


-- 12. Categorize content based on age rating group: 'Kids', 'Teens', 'Adults'

SELECT 
	rating,
	COUNT(*) AS total,
	CASE 
		WHEN rating IN ('G', 'TV-G', 'TV-Y', 'TV-Y7') THEN 'Kids'
		WHEN rating IN ('PG', 'TV-PG', 'PG-13') THEN 'Teens'
		WHEN rating IN ('R', 'TV-MA', 'NC-17') THEN 'Adults'
		ELSE 'Unrated'
	END AS age_group
FROM netflix
GROUP BY rating, age_group
ORDER BY total DESC;


--Aaron Mascarenhas

