USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- APPROACH :- To count Total_rows in each table of imdb db using a series of UNION queries

-- Count total_rows in 'director_mapping' table
select 'director_mapping' AS 'Table', COUNT(*) AS Total_rows FROM director_mapping 
UNION 
--  Count total_rows in 'genre' table
select 'genre' AS 'Table'           , COUNT(*) AS Total_rows FROM genre 
UNION
-- Count total_rows in 'movie' table 
select 'movie' AS 'Table'           , COUNT(*) AS Total_rows FROM movie 
UNION
-- Count total_rows in 'names' table 
select 'names' AS 'Table'           , COUNT(*) AS Total_rows FROM names 
UNION 
-- Count total_rows in 'ratings' table
select 'ratings' AS 'Table'         , COUNT(*) AS Total_rows FROM ratings 
UNION
-- Count total_rows in 'role_mapping' table 
select 'role_mapping' AS 'Table'    , COUNT(*) AS Total_rows FROM role_mapping;   

/* Observation : Total_rows in each table of the imdb schema
1. director_mapping = 3867 rows
2. genre = 14662 rows
3. movie = 7997 rows
4. names = 25735 rows
5. ratings = 7997 rows
6. role_mapping = 15615 rows 
*/  

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

/* APPROACH :- To count the number of NULL / missing values in different columns of movie table 
			   by using conditional aggregation with CASE statement.                            */ 

select sum(CASE when id IS NULL then 1 else 0 END) as id_null,
       sum(CASE when title IS NULL then 1 else 0 END) as title_null,
       sum(CASE when year IS NULL then 1 else 0 END) as year_null,
       sum(CASE when date_published IS NULL then 1 else 0 END) as date_publish_null,
	   sum(CASE when duration IS NULL then 1 else 0 END) as duration_null,
       sum(CASE when country IS NULL then 1 else 0 END) as country_null,
       sum(CASE when worlwide_gross_income IS NULL then 1 else 0 END) as worl_gross_null,
       sum(CASE when languages IS NULL then 1 else 0 END) as lang_null,
       sum(CASE when production_company IS NULL then 1 else 0 END) as prod_comp_null
FROM movie;

/* Observation : 
1. country_null => 20 missing / null values in country column 
2. worl_gross_null => 3724 missing / null values in worlwide gross income column
3. lang_null => 194 missing / null values in language column
4. prod_comp_null => 528 missing / null values in production company column

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- 1. For number of movies released each year 

-- APPROACH :- To count number_of_movies for each year from movie table, grouping by year

select Year,                             # Selecting 'Year' column from 'movie' table
       count(id) AS number_of_movies     # Counting number of movies in each year 
FROM movie                               # Specifying table 'movie' from which data is retrieved
-- Grouping results by 'Year' column
GROUP BY Year;

/* Observation : The yearly trend for number_of_movies seems to be declining.
=> In 2017, the highest number of movies were released, i.e. , 3052
=> In 2019, the least number of movies were released, i.e. , 2001             */

-- 2. For number of movies released every month (month wise trend) 

-- APPROACH :- To retrieve number_of_movies published each month, grouping and ordering by month_num 
               
select month(date_published) AS month_num,  # Select month of publication from date_published column
       count(id) AS number_of_movies        # Count number of movies (rows) for each month
FROM movie
-- Group results by month of publication.
GROUP BY month(date_published)
-- Order results by month of publication.
ORDER BY month(date_published);

/* Observation : 
-> In March, highest number of movies were released, i.e. , 824.
-> In December, the least number of movies were released, i.e. , 438. */

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- APPROACH :- To count number_of_movies produced in USA or India in year 2019 by using WHERE clause and LIKE statement

select Year,                                       # Selecting 'Year' column from 'movie' table
       count(DISTINCT id) AS Number_of_Movies      # Counting distinct movie IDs
FROM movie                                         # From "movie" table
-- Filtering rows where 'country' column contains 'USA' or 'INDIA'
-- And also, filtering rows where 'year' column = 2019
where (country LIKE '%USA%' 
        OR country LIKE '%INDIA%')
        AND year = 2019;        

-- Observation : Number of Movies produced in the USA or India in the year 2019 = 1059

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- APPROACH :- To retrieve only unique values from genre column of genre table by using DISTINCT

select DISTINCT genre       # Selecting distinct values of 'genre' column
FROM genre;                 # From 'genre' table
 
/* Observation : The movies belong to 13 different types of genres like :-
Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure, Action, Sci-Fi, Crime, Mystery, Others  */

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

/* APPROACH :- To find highest number of movies produced overall we inner join movie and genre table
			   on common id column i.e. movie_id (genre) & id (movie), grouping by genre,
               ordering by Number_of_movies in descending order with limit of 3            */

select genre,                                 # Selecting genre and counting number of movies in each genre
	   count(movie_id) AS Number_of_Movies
FROM genre AS gen                             
INNER JOIN movie as mov                       # Joining genre table with movie table on movie_id and id respectively
ON gen.movie_id = mov.id
-- Grouping result by genre to get counts for each genre
GROUP BY genre 
-- Ordering result by number of movies in descending order
ORDER BY Number_of_Movies DESC
LIMIT 3;                                      # Limit to 3 to retrieve only Top 3 genres with highest Number_of_Movies

-- Observation : The 'DRAMA' genre has the highest number of movies produced overall , i.e. 4285 movies

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

/* APPROACH :- To find out movies belonging to only one genre we use sub-querying to count number of distinct genres for each movie, 
               then filters and counts for movies with only one genre                 */ 

select count(*) AS only_one_genre_movie        # selects count of movies with only one genre
-- Subquery to calculate count of genres for each movie and filter movies with only one genre.
FROM (select movie_id, 
			 count(genre) AS count_of_genre
      FROM genre
      GROUP BY movie_id
      -- To filter out groups where count of distinct genres is equal to 1.
	  HAVING count(DISTINCT genre) = 1) AS only_one_genre_movie;

-- Observation : There are 3289 movies belonging to only one genre.

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* APPROACH :- Using AVG() to find out average duration of movies for each genre, we inner join genre and movie tables on common id column, 
               grouping by genre and ordering by average duration in descending order.            */
	
select genre,                                        # Select genre and rounded avg_duration
       round(AVG(duration), 2) AS avg_duration
FROM genre AS gen
-- Join genre table with movie table using movie_id
INNER JOIN movie AS mov
ON gen.movie_id = mov.id
-- Group results by genre
GROUP BY genre
-- Sort results by avg_duration in descending order
ORDER BY avg_duration DESC;

/* Observation : 
=> 'Action' has the highest average duration, i.e. , 112.88 mins
=> Average_duration of highest produced genre, i.e. , 'Drama' is 106.77 mins (less as compared to Action genre)  */ 

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

/* APPROACH :- Create a common table expression (CTEs), i.e., genre_summary by counting the number of movies for each genre, 
ranking by movie_count in descending order, then selects all columns from the CTE where the genre is 'Thriller' */ 

WITH genre_summary AS 
(
 select genre, 
		count(movie_id) AS movie_count, 
		RANK() OVER(ORDER BY count(movie_id) DESC) AS genre_rank 
 FROM genre AS gen
 INNER JOIN movie AS mov
 ON gen.movie_id = mov.id
 GROUP BY gen.genre       
)
select * FROM genre_summary
where genre = 'Thriller';

-- Observation : Thriller genre ranks 3rd among all the genres with 1484 movies produced

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- APPROACH :- Using min() and max() functions for avg_rating, total_votes & median_rating columns from ratings table

select min(avg_rating) AS min_avg_rating,         # Selecting minimum avg_rating from ratings table
       max(avg_rating) AS max_avg_rating,         # Selecting maximum avg_rating from ratings table
       min(total_votes) AS min_total_votes,       # Selecting minimum total_votes from ratings table
       max(total_votes) AS max_total_votes,       # Selecting maximum total_votes from ratings table
       min(median_rating) AS min_median_rating,   # Selecting minimum median_rating from ratings table
       max(median_rating) AS max_median_rating    # Selecting maximum median_rating from ratings table
FROM ratings;               

/* Observation :-
=> Minimum value of Average rating = 1.0
=> Maximum value of Average rating = 10.0 
=> Minimum value of Total votes = 100
=> Maximum value of Total votes = 725138 
=> Minimum value of Median rating = 1
=> Maximum value of Median rating = 10
=> Hence, from the data we can conclude that all the values are within the range and there are no outliers. 

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

/* APPROACH :- Using DENSE_RANK() along with Common Table Expression (CTEs)
			   To rank movies by avg_rating, then select top 10 ranked movies from the CTE   */

WITH movie_rank_summary AS 
( -- Common Table Expression (CTE) to calculate movie ranks
     select title,        # Selecting movie title
            avg_rating,   # Calculating avg_rating 
	   -- Assigning a dense rank based on avg_rating 
            DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
     FROM ratings AS rat            # Table containing ratings
     INNER JOIN movie AS mov        # Joining with movie table to get movie titles
     ON mov.id = rat.movie_id   
)
select *                    # Selecting all columns
FROM movie_rank_summary     # Using the CTEs
where movie_rank <= 10;     # Filtering to get only Top 10 movies                     

/* Observation : By using DENSE_RANK() we can observe -
=> There are two Movies with Avg_rating = 10 , i.e. , => Kirket and Love in Kilnerry both are at rank 1
=> Movie = 'Fan' has avg_rating of 9.6 which is at rank 4                                               */

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

/* APPROACH :- To calculate median rating for movies and counts number of movies for each median rating, 
			   grouping by median_rating and ordering by movie_count in descending order                  */

select median_rating,                     # selecting median_rating column
       count(movie_id) AS movie_count     # counting number of movies for each median_rating
FROM ratings                              # selecting from ratings table
-- Grouping results by median_rating
GROUP BY median_rating
-- Ordering results by movie_count in descending order
ORDER BY movie_count DESC;       

/* Observation : 
1. Median rating = 7 has the highest number of movie counts , i.e. , 2257 movies
2. Median rating = 1 has the least number of movie counts , i.e. , 94 movies       */


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

/* APPROACH :- We retrieve movie_count, DENSE_RANK() production companies by movie_count in descending order, 
			   perform inner join between ratings and movie tables, filter avg_rating > 8, 
			   exclude NULL production companies, grouping production company and ordering movie_count.   */

select production_company,               # Select production company name
       count(movie_id) AS movie_count,   # Count number of movies produced by each production company
  -- Dense_Rank production companies based on the movie count in descending order     
       DENSE_RANK() OVER ( ORDER BY count(movie_id) DESC ) AS prod_company_rank
FROM ratings AS rating          # Table alias for ratings table
INNER JOIN movie AS mov         # Join ratings and movie tables using movie_id column
ON rating.movie_id = mov.id
where avg_rating > 8                          # Filter movies with avg_rating greater than 8
      AND production_company IS NOT NULL      # Filter out null values for production companies
-- Group results by production company
GROUP BY production_company;

/* Observation : 
=> Dream Warrior Pictures & National Theatre Live (both of them) are the two production companies 
   which have 3 hit movies and ranked as 1 (first) with average rating > 8 
=> RSVP can do partnership with Dream Warrior Pictures or National Theatre Live for their upcoming projects  */

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* APPROACH :- To retrieve movie_count for each genre that meet specific criteria like :- 
			   published in March 2017 in USA with over 1000 votes, 
               we inner join genre, movie and ratings tables and 
               applying filters on date, country and total votes.         */

select genre,                      # Selecting genre and counting number of movies in each genre 
       count(id) AS movie_count
FROM genre AS gen                  # Joining genre table with movie table on movie_id to get movie details
INNER JOIN movie as mov 
ON mov.id = gen.movie_id 
INNER JOIN ratings AS rat          # Joining movie table with ratings table on movie_id to get ratings details
ON mov.id = rat.movie_id
-- Filtering data based on specific conditions
where MONTH(date_published) = 3    # Movies released in March
      AND Year = 2017              # Movies released in 2017
      AND country LIKE '%USA%'     # Movies released in USA
      AND total_votes > 1000       # Movies with more than 1000 total_votes
-- Grouping results by genre to count movies in each genre
GROUP BY genre
-- Ordering result by movie count in descending order
ORDER BY movie_count DESC;

/* Observation : 
=> 24 movies of Drama genre were released in total during March 2017 in USA with more than 1,000 votes
=> On the other hand, Family genre has the least number of movies */

-- Lets try to analyse with a unique problem statement.

-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

/* APPROACH :- We will retrieve title, avg_rating and genre of movies starting with "The", having avg_rating > 8, 
               we inner join genre, movie, ratings tables on common IDs 
               and apply filters before ordering by avg_rating in descending order         */

select title,        # Selecting title of movie
       avg_rating,   # Selecting avg_rating of movie
       genre         # Selecting genre of movie
FROM genre AS gen           # Aliasing genre table as 'gen'
INNER JOIN movie mov        # Joining genre table with movie table using movie_id column
ON gen.movie_id = mov.id
INNER JOIN ratings AS rat   # Joining movie table with ratings table using movie_id column 
ON mov.id = rat.movie_id
-- Filtering movies whose title starts with 'The' AND
-- Filtering movies with avg_rating > 8
where title regexp '^The' AND avg_rating > 8
-- Ordering results by avg_rating in descending order
ORDER BY avg_rating DESC;

/* Observation : The Brighton Miracle under Drama genre is the top rated movie with conditions, i.e., 
				 start with the word ‘The’ and have an avg_rating > 8 */

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

/* APPROACH :- To retrieve movie_count released between April 1, 2018 and April 1, 2019, 
               with median_rating = 8, we inner join movie and ratings tables on common IDs and 
               apply filters based on rating and release date  */

select count(id) AS Movie_Released_April_18_19  # Count number of movies with specified conditions
FROM movie AS mov                               # Alias movie table as "mov"
INNER JOIN ratings AS rat                       # Join ratings table as "rat"
ON mov.id = rat.movie_id                        # Match movie IDs between movie and ratings tables
-- Filter movies with median_rating of 8
where median_rating = 8
   -- Filter movies released between April 1, 2018 and April 1, 2019   
      AND date_published BETWEEN '2018-04-01' AND '2019-04-01';

-- Observation : 361 movies were released between 1 April 2018 and 1 April 2019 with median_rating = 8

-- Once again, try to solve the problem given below.

-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

/* APPROACH :- USING COUNTRY COLUMN AS INITIAL CHECK (To get the total_votes in terms of counts)
			   To calculate total_votes for movies from Germany and Italy, we inner join movie and ratings tables, 
			   we filter movies with corresponding countries and combine using UNION ALL, lastly ordering by country */

select 'Germany' AS country, 
        sum(total_votes) AS 'Total_Votes' 
FROM movie AS mov 
INNER JOIN ratings AS rat
on mov.id = rat.movie_id
where country LIKE 'Germany'
UNION ALL 
select 'Italy' AS country, 
        sum(total_votes) AS 'Total_Votes' 
FROM movie AS mov 
INNER JOIN ratings AS rat
ON mov.id = rat.movie_id
where country LIKE 'Italy'
ORDER BY country;

-- Observation : Germany received higher total_votes, i.e. , 106710 votes as compared to Italy which has received 77965 votes. 

/* APPROACH :- USING LANGUAGE COLUMN AS FINAL CHECK (To display the answer as YES)
			   To calculate total_votes for movies with Italian or German languages using common table expression (CTE), 
			   also to check if there are any votes for either language and return 'YES' if true, 'NO' otherwise. */

WITH vote_summary AS 
( 
 select 'Italian' AS language,
        sum(rat.total_votes) AS total_votes 
 FROM movie AS mov
 INNER JOIN ratings AS rat 
 ON rat.movie_id = mov.id
 -- total_votes for movies with Italian language
 where languages LIKE '%Italian%'
 UNION ALL
 select 'German' AS language,
        sum(rat.total_votes) AS total_votes 
 FROM movie AS mov
 INNER JOIN ratings AS rat 
 ON rat.movie_id = mov.id
 -- total_votes for movies with German language
 where languages LIKE '%GERMAN%' ) , language_flag AS 
( -- To check if there are any votes for either Italian or German languages
 select CASE 
			WHEN ( select total_votes FROM vote_summary where language = 'German') > ( select total_votes FROM vote_summary	where language = 'Italian') THEN 'YES'
			ELSE 'NO'
		END AS ANSWER 
)
select ANSWER
FROM language_flag;

/* Observation : Upon querying against language and country columns, we can conclude that 
                 German movies received highest number of votes against Italian movies */  

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

/* APPROACH :- To retrieve the number of NULL values for each column (name, height, date_of_birth, known_for_movies) 
               in the "names" table using conditional aggregation with CASE statement       */

select sum(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
	   sum(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
	   sum(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
	   sum(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls		
FROM names;

/* Observation : There are null / missing values in 3 columns -
1. name_nulls => No missing / null values in name column 
2. height_nulls => 17335 missing / null values in height column
3. date_of_birth_nulls => 13431 missing / null values in date_of_birth column
4. known_for_movies_nulls => 15226 missing / null values in known_for_movies column  */

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* APPROACH :- We need to identify top_three_genres with highest avg_rating, 
               select top three directors with most movies in those genres with avg_rating > 8, 
			   inner join with appropriate tables and conditions on genre and avg_rating          */

WITH Top_Three_genres AS 
( -- selects Top_Three_Genres with highest movie_count where avg_rating > 8
 select genre,
        count(mov.id) AS movie_count 
 FROM movie AS mov 
 INNER JOIN genre AS gen
 ON mov.id = gen.movie_id
 INNER JOIN ratings AS rat  
 ON mov.id = rat.movie_id
 where avg_rating > 8
 GROUP BY genre
 ORDER BY movie_count DESC
 LIMIT 3
)
select dname.name AS director_name,    # Selects name of the director.
       count(mov.id) AS movie_count    # Counts number of movies directed by each director.
FROM names AS dname                    # Retrieves director names from names table
INNER JOIN director_mapping AS dmap    # Joins director_mapping table with names table based on director's ID.
ON dname.id = dmap.name_id
INNER JOIN movie AS mov                # Joins movie table with director_mapping table based on movie's ID.
ON mov.id = dmap.movie_id
INNER JOIN ratings AS rat              # Joins ratings table with movie table based on movie's ID.
ON mov.id = rat.movie_id
INNER JOIN genre AS gen                # Joins genre table with movie table based on movie's ID.  
ON mov.id = gen.movie_id
-- Filters movies with avg_rating > 8 and filters movies only from Top_Three_Genres selected in CTE.
where avg_rating > 8 AND gen.genre IN (select genre FROM Top_Three_genres)
-- Groups result by director name
GROUP BY director_name
-- Orders result by movie_count directed by each director in descending order   
ORDER BY movie_count DESC
LIMIT 3;                       # Limits to Top Three Directors

/* Observation : RSVP can aim to work with the following directors on top rated genres whose avg_rating > 8 :-
1. James Mangold (4 movies)
2. Joe Russo (3 movies)
3. Anthony Russo (3 movies)                */ 

/* James Mangold can be hired as the director for RSVP's next project. Do you remember his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* APPROACH :- To find actor_name who have appeared in movies with median_rating >= 8 , counts movie_count in which each actor has appeared in, 
               returns top two actors with highest movie counts.           */

select aname.name AS actor_name,      # Selecting actor's name 
	   count(mov.id) AS movie_count   # Counting number of movies each actor has appeared in
FROM names AS aname                   # Alias for table containing actor names
INNER JOIN role_mapping AS rmap       # Joining actor names table with role mapping table on actor ID
ON aname.id = rmap.name_id
INNER JOIN movie AS mov               # Joining movie table with role mapping table on movie ID
ON mov.id = rmap.movie_id 
INNER JOIN ratings AS rat             # Joining ratings table with movie table on movie ID
ON mov.id = rat.movie_id
-- Filtering for movies with median_rating >= 8 and category as 'actor'
where median_rating >= 8 AND category = 'actor'
-- Grouping result by actor name
GROUP BY aname.name
-- Sorting result by movie_count in descending order
ORDER BY movie_count DESC
LIMIT 2;                          # Limit to Top 2 actors with highest movie_count

/* Observation : 
=> Top two actors whose movies have median rating >= 8 are Mammootty (8 movies) and Mohanlal (5 movies)
=> RSVP could consider working with Mammooty for their new project                                      */

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 

RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

/* APPROACH :- Using select statement
			   To retrieve top 3 production_company based on sum of total_votes for their movies, 
			   rank based over sum of total_votes in descending order, 
			   we inner join movie and ratings tables on the movie IDs, 
			   grouping by production company and ordering by rank with a limit      */

select production_company,
       sum(total_votes) AS vote_count,
RANK() OVER (ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM movie AS mov 
INNER JOIN ratings AS rat
ON mov.id = rat.movie_id
-- Group results by production company
GROUP BY production_company
-- Order results by rank of production company
ORDER BY prod_comp_rank
LIMIT 3;                         # Limit to Top 3 production companies

/* Observation : The top 3 production houses based on the number of votes received by their movies are ranked as follows :- 
1. Marvel Studios with vote_count = 2656967  and Rank = 1  
2. Twentieth Century Fox with vote_count = 2411163 and Rank = 2
3. Warner Bros. with vote_count = 2396057 and Rank = 3
=> RSVP can look at working with one of the top 3 production houses, preferably Marvel Studios for its next venture. 

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/* APPROACH :- To find avg_rating, total votes and movie_count for Indian actors who have appeared in at least 5 movies, 
               we can rank based on avg_rating, by doing inner join of multiple tables and 
               applying aggregate functions, grouping by actor name and filtering with a HAVING clause         */

select name AS actor_name,               # Alias for clarity
	   sum(total_votes) AS total_votes,  # Sum of total_votes for all movies
       count(mov.id) AS movie_count,     # Count of movies the actor appeared in
-- Average rating weighted by total votes    
       round(sum(avg_rating * total_votes) / sum(total_votes),2) AS actor_avg_rating, 
-- Ranking based on average rating
       RANK() OVER( ORDER BY round(sum(avg_rating * total_votes) / sum(total_votes),2) DESC) AS actor_rank
FROM names AS nam                  # Alias for names table
INNER JOIN role_mapping AS rmap    # Joining role_mapping table on actor's name ID
ON nam.id = rmap.name_id
INNER JOIN movie AS mov            # Joining movie table on movie ID
ON rmap.movie_id = mov.id
INNER JOIN ratings AS rat          # Joining ratings table on movie ID
ON rat.movie_id = mov.id

where category = 'actor'           # Filter for actors
      AND country LIKE '%india%'   # Filter for actors from India
GROUP BY actor_name                # Grouping by actor_name
HAVING movie_count >= 5;           # Filter for actors who have appeared in at least 5 movies

/* Observation : 
=> Top actor is Vijay Sethupathi with Highest total_votes = 23114 votes, movie_count = 5 movies, actor_avg_rating = 8.42 and actor_rank = 1 

Note : As ratings were closely related to other actors total_votes was indeed a tie-breaker, a significant data to find top actor.

=> So, RSVP can work with Vijay Sethupathi for their project.      */

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/* APPROACH :- To retrieve top 5 Indian Hindi actresses with at least 3 movies, by total votes, movie_count, actress_avg_rating 
               and ranking based on avg_rating, by doing joins of multiple tables, filtering for actresses from India and Hindi movies, 
               grouping by actress name and limiting to top 5 ranked actresses     */

select name AS actress_name,
	   sum(total_votes) AS total_votes,  # Summing total_votes for each actress
       count(mov.id) AS movie_count,     # Counting number of movies each actress has appeared in
--  Calculating avg_rating for each actress
       round(sum(avg_rating * total_votes) / sum(total_votes),2) AS actress_avg_rating,
--  Assigning a rank to each actress based on their avg_rating
       RANK() OVER( ORDER BY round(sum(avg_rating * total_votes) / sum(total_votes),2) DESC) AS actress_rank
FROM names AS nam                 # Table containing actress names
INNER JOIN role_mapping AS rmap   # Table mapping actresses to movies
ON nam.id = rmap.name_id          
INNER JOIN movie AS mov           # Table containing movie information
ON rmap.movie_id = mov.id
INNER JOIN ratings AS rat         # Table containing ratings for movies
ON rat.movie_id = mov.id
-- Filtering data to only include actresses from India who have appeared in Hindi movies
where category = 'actress' AND country LIKE '%india%' AND languages LIKE '%hindi%'  
-- Grouping the data by actress_name
GROUP BY actress_name
-- Filtering out actresses who have appeared in less than 3 movies         
HAVING movie_count >= 3
LIMIT 5;                   # Limiting to only top 5 actresses based on their avg_rating

/* Observation : 
1. Taapsee Pannu with actress_avg_rating = 7.74 (rank = 1) followed by
2. Kriti Sanon with actress_avg_rating = 7.05 (rank = 2), 
3. Divya Dutta with actress_avg_rating = 6.88 (rank = 3), 
4. Shraddha Kapoor with actress_avg_rating = 6.63 (rank = 4),
5. Kriti Kharbanda with actress_avg_rating = 4.80 (rank = 5)
=> RSVP can pair with any one of the following actresses for their next movie (upcoming project)   */

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

/* APPROACH :- To retrieve title, genre, avg_rating and assign category based on rating for thriller movies 
               by doing inner join movie, ratings and genre tables,
               using a CASE statement to categorize movies as superhit, hit, one-time-watch, or flop, 
               with a condition on genre being 'Thriller'  */

select title,      # Selecting movie title, genre, average rating, and assigning rating categories 
       genre,
       avg_rating,
       CASE 
           WHEN avg_rating > 8             THEN 'Superhit movies'
		   WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
		   WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
           WHEN avg_rating < 5             THEN 'Flop movies'
	   END AS avg_rating_category
FROM movie AS mov 
INNER JOIN ratings AS rat
ON mov.id = rat.movie_id
INNER JOIN genre AS gen 
ON mov.id = gen.movie_id
where genre = 'Thriller';       # Filtering movies by genre 'Thriller' 

/* Observation : The thriller movies as per avg_rating were classified as per the category mentioned in the question:
=> Movie title = Rakshasudu, avg_rating = 8.4 is a Superhit movie 
=> Movie title = Back Roads, avg_rating = 7.0 is a Hit movies
=> Movie title = Killer in Law, avg_rating = 5.1 is a One-time-watch movie 
=> Movie title = Staged Killer, avg_rating = 3.3 is a Flop movie                  */

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

/* APPROACH :- To retrieve avg_duration of movies for each genre, compute running_total_duration and moving_average_duration for each genre 
			   using window functions      */

WITH avg_duration_for_genre AS 
( -- Selecting genre, calculating avg_duration and rounding it
  select genre,
         round(AVG(duration)) AS avg_duration,
         -- Calculating running_total_duration for genres
         sum(round(AVG(duration), 1)) OVER ( ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
         -- Calculating moving_avg_duration for genres
         ROUND(AVG(ROUND(AVG(duration), 2)) OVER ( ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
  FROM movie AS mov 
  INNER JOIN genre AS gen
  ON mov.id = gen.movie_id
  GROUP BY genre
)
select *
FROM avg_duration_for_genre;

/* Observation : The genre-wise avg_duration, running_total_duration, moving_avg_duration values are displayed in the output below.
1. avg_duration => Horror genre has lowest avg_duration = 93 mins
                => Action genre has highest avg_duration = 113 mins
2. running_total_duration => There is a gradual increase in running_total_duration for each genre (genre-wise).
                          => Action genre has lowest running_total_duration = 112.9 mins
                          => Thriller genre has highest running_total_duration = 1341.1 mins
3. moving_avg_duration => There are fluctuations in moving_avg_duration for each genre (decrease-increase-decrease) like trend genre-wise
                       => Thriller genre has lowest moving_avg_duration = 103.16 mins
                       => Horror genre has highest moving_avg_duration = 112.88 mins             */
                       
-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- APPROACH :- To retrieve Top_Five_Movies from each of the Top_Three_Genres, ordered by worldwide gross income, for each year. 

-- Top_Three_Genres based on most number of movies

WITH Top_Three_Genres AS 
( -- Calculate Top_Three_Genres by movie_count and assign a rank to each genre
     select genre,
            count(movie_id) AS movie_count,
            DENSE_RANK() OVER(ORDER BY count(movie_id) DESC) AS genre_rank 
     FROM movie AS mov
     INNER JOIN genre AS gen
     ON mov.id = gen.movie_id
	 GROUP BY genre
     LIMIT 3
),  
Top_Five_Movies AS    
(  -- Select Top_Five_Movies from each Top_Three_Genres for each year based on worldwide_gross_income	   
   select gen.genre,                                            
		  mov.year,
		  mov.title AS movie_name,
		  mov.worlwide_gross_income AS worldwide_gross_income,
		  DENSE_RANK() OVER ( PARTITION BY mov.year 
							 ORDER BY CASE             
                                   -- Convert income values to USD for comparison
		                                  WHEN worlwide_gross_income LIKE '%$%' THEN CAST(TRIM(REPLACE(IFNULL(worlwide_gross_income, 0),'$','')) AS FLOAT)
								          WHEN worlwide_gross_income LIKE '%INR%' THEN round(CAST(TRIM(REPLACE(IFNULL(worlwide_gross_income, 0),'INR','')) AS FLOAT) / 82.9) 
								      END DESC ) AS movie_rank
   FROM movie AS mov
   INNER JOIN genre AS gen 
   ON mov.id = gen.movie_id
   where genre IN ( select genre FROM Top_Three_Genres ) 
   ORDER BY year, movie_rank
) 
select * FROM Top_Five_Movies       # To retrieve Top 5 movies in Top_Three_Genres
where movie_rank <= 5;

/* Observation :- 
>> In 2017, we can say that genre = Thriller was the highest-grossing genre based on worldwide_gross_income ( ADDITIONAL INSIGHT ) :-  
1. "The Fate of the Furious" was the highest-grossing movie of Thriller genre (worldwide_gross_income = $ 1236005118) followed by, 
2. "Despicable Me 3" was one of the top movies of genre = Comedy (worldwide_gross_income = $ 1034799409)
3. "Jumanji: Welcome to the Jungle" was again a movie of genre = Comedy and (worldwide_gross_income = $ 962102237)
4. "Zhan lang II" was a top performer in both Drama and Thriller genres (worldwide_gross_income = $ 870325439)
5. "Guardians of the Galaxy Vol. 2" was one of the top performers of genre = Comedy (worldwide_gross_income = $ 863756051)

>> In 2018, we can say that genre = 'Drama' was the highest-grossing genre based on worldwide_gross_income ( ADDITIONAL INSIGHT ) :-   
1. "Bohemian Rhapsody" was the highest-grossing movie of Drama genre (worldwide_gross_income = $ 903655259) followed by, 
2. "Venom" was one of the top movies of genre = Thriller (worldwide_gross_income = $ 856085151)
3. "Mission: Impossible - Fallout" was again a movie of genre = Thriller (worldwide_gross_income = $ 791115104) and 
4. "Deadpool 2" was a top performer of genre = Comedy (worldwide_gross_income = $ 785046920)
5. "Ant-Man and the Wasp" was one of the top performers again of genre = Comedy (worldwide_gross_income = $ 622674139)

>> In 2019, we can say that genre = Drama was the highest-grossing genre based on worldwide_gross_income ( ADDITIONAL INSIGHT ) :-   
1. "Avengers: Endgame" was the highest-grossing movie of Drama genre (worldwide_gross_income = $ 2797800564) followed by, 
2. "The Lion King" was one of the top movies again belonging to genre = Drama (worldwide_gross_income = $ 1655156910)
3. "Toy Story 4" was again a movie of genre = Comedy and (worldwide_gross_income = $ 1073168585)
4. "Joker" was a top performer in both Drama and Thriller genres (worldwide_gross_income = $ 995064593)
5. "Ne Zha zhi mo tong jiang shi" was one of the top performers of genre = Thriller (worldwide_gross_income = $ 700547754)
*/

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.

-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

/* APPROACH :- Using Common Table Expressions (CTEs)
			   To retrieve production_company with high-rated movies, count movies with non-null production company and multiple languages, 
			   rank by movie count and limit to top 2              */

WITH prod_comp_summary AS 
( -- Selecting production company and counting movies meeting specified criteria
 select production_company,
		count(*) AS movie_count
 FROM movie AS mov
 INNER JOIN ratings AS rat
 ON rat.movie_id = mov.id
 WHERE median_rating >= 8                   # Selecting movies with median_rating of 8 or higher
	   AND production_company IS NOT NULL   # Ensuring production company is not null
       AND position(',' IN languages) > 0   # Checking if languages contain a comma
 GROUP BY production_company
 -- Ordering production companies by count of their movies
 ORDER BY movie_count DESC)
SELECT * ,
RANK() OVER ( ORDER BY movie_count DESC ) AS prod_comp_rank     # Ranking production companies by movie_count
FROM prod_comp_summary
LIMIT 2;                                # Limit to Top 2 production companies based on movie_count

/* Observation : The top 2 production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies are :-
1. Star Cinema with movie_count = 7 movies and ranked as prod_comp_rank = 1 (first rank)
2. Twentieth Century Fox with movie_count = 4 movies and ranked as prod_comp_rank = 2 (second rank) */

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages) > 0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/* APPROACH :- Using Common Table Expression (CTEs) with ROW_NUMBER()
			   To summarize actress data in drama movies, ranking them by movie count, total votes, average rating, row number 
			   and then select top 3 actresses.                   */

WITH actress_summary AS
(
  select anam.name AS actress_name,
  		 sum(rat.total_votes) AS total_votes,
         count(mov.id) AS movie_count,
         round(AVG(rat.avg_rating),2) AS actress_avg_rating,
         ROW_NUMBER() OVER(ORDER BY count(mov.id) DESC) AS actress_rank
  FROM movie AS mov
  INNER JOIN ratings AS rat
  ON mov.id = rat.movie_id
  INNER JOIN role_mapping AS rmap
  ON mov.id = rmap.movie_id
  INNER JOIN names AS anam
  ON rmap.name_id = anam.id
  INNER JOIN GENRE AS gen
  ON gen.movie_id = mov.id
  where category = 'ACTRESS'
        AND avg_rating > 8
        AND genre = "Drama"
  GROUP BY actress_name
)
select * 
FROM actress_summary 
LIMIT 3;
                 
/* Observation : The top 3 actresses based on number of Super Hit Movies (avg_rating > 8) in Drama genre are as follows :-
1. Parvathy Thiruvothu with total_votes = 4974 , movie_count = 2 , actress_avg_rating = 8.20 and rank = 1 (first rank)
2. Susan Brown with total_votes = 656 , movie_count = 2 , actress_avg_rating = 8.95 and rank = 2 (second rank)
3. Amanda Lawrence with total_votes = 656 , movie_count = 2 , actress_avg_rating = 8.95 and rank = 3 (third rank)

Therefore, we can conclude that Parvathy Thiruvothu is the top actress for Superhit category of movies in the top genre and 
RSVP can consider this actress for their upcoming project      */

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

/* APPROACH :- To calculate statistics for directors based on their movie release dates and ratings, 
               using common table expressions (CTEs) for intermediate results                        */

WITH next_date_pub_summary AS
(
  select dir.name_id,          # Subquery to calculate various date-related metrics
         name, 
         dir.movie_id,
         duration,
		 rat.avg_rating,
		 total_votes,
		 mov.date_published,
-- Using LEAD function to get the next date published for each director's movies       
		 LEAD(date_published, 1) OVER( PARTITION BY dir.name_id 
                                       ORDER BY date_published, movie_id ) AS next_date_published
  FROM director_mapping AS dir
  INNER JOIN names AS nam
  ON nam.id = dir.name_id
  INNER JOIN movie AS mov
  ON mov.id = dir.movie_id
  INNER JOIN ratings AS rat
  ON rat.movie_id = mov.id ), 
  -- Subquery to calculate the date difference between consecutive movies for each director
  Top_Nine_Director AS
(
  select *,
	Datediff(next_date_published, date_published) AS date_difference
  FROM   next_date_pub_summary  )
-- Main query to aggregate the calculated metrics for each director  
select name_id AS director_id,
	   NAME AS director_name,
	   count(movie_id) AS number_of_movies,
	   round(AVG(date_difference)) AS avg_inter_movie_days,
	   round(AVG(avg_rating),2) AS avg_rating,
	   sum(total_votes) AS total_votes,
	   min(avg_rating) AS min_rating,
	   max(avg_rating) AS max_rating,
	   sum(duration) AS total_duration
FROM Top_Nine_Director
GROUP BY director_id
ORDER BY count(movie_id) DESC, avg_rating DESC 
LIMIT 9;

/* Observation : 
=> Director with highest number_of_movies = 'A.L. Vijay' has directed the highest number_of_movies (5 movies), 
                                             which could indicate a prolific career and experience in filmmaking.
=> Average Inter-Movie Days: Andrew Jones has the lowest avg_inter_movie_days (191 days), 
                             suggesting a faster pace of movie production compared to other directors.
=> Average Rating: Steven Soderbergh has the highest avg_rating (6.48) among the directors listed, 
                   indicating consistently well-received films.
=> Total Votes: Steven Soderbergh also has the highest total_votes (171,684 votes), 
                showcasing a significant audience engagement with his films.
=> Range of Ratings: The range of ratings for different directors varies, with some like 
					 A.L. Vijay having a narrower range (3.7 to 6.9) compared to others like Chris Stokes (4.0 to 4.6). 
                     This indicates varying levels of critical reception for their works.
=> Total Duration: Özgür Bakar has the highest total_duration (374 mins), 
                   which could suggest a focus on longer films or projects with extensive content.
*/