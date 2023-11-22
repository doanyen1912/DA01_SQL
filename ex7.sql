--EX1:
SELECT EXTRACT(year FROM transaction_date) AS year_transaction,
product_id,spend AS curr_year_spend ,
LAG(spend) OVER(PARTITION BY product_id ORDER BY product_id,
EXTRACT(year FROM transaction_date)) AS prev_year_spend,
ROUND((spend -LAG(spend) OVER(PARTITION BY product_id ORDER BY product_id,
EXTRACT(year FROM transaction_date)))*100.0/LAG(spend) OVER(PARTITION BY product_id ORDER BY product_id,
EXTRACT(year FROM transaction_date)),2)AS yoy_rate
FROM user_transactions;
--EX2:
SELECT DISTINCT
  card_name,
  FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month)
  AS issued_amount
FROM monthly_cards_issued
ORDER BY issued_amount DESC;
--EX3:
WITH rank_user AS (
SELECT
user_id,spend,transaction_date,
Row_number() OVER(PARTITION BY user_id ORDER BY transaction_date)  AS row_date
FROM transactions 
) 
SELECT 
   user_id,spend,transaction_date	
FROM rank_user
WHERE row_date= 3;
--EX5: 
WITH row_tweet AS (
SELECT *, 
lag(tweet_count) over (PARTITION BY user_id ORDER BY tweet_date) AS lag_1, 
lag(tweet_count, 2) over (PARTITION BY user_id ORDER BY tweet_date) AS lag_2
FROM tweets)

SELECT user_id, tweet_date,
  (CASE
  WHEN lag_1 is NULL THEN ROUND(tweet_count, 2)
  WHEN lag_2 is NULL THEN ROUND((tweet_count+lag_1)/2.0, 2)
  ELSE ROUND((tweet_count+lag_1+lag_2)/3.0, 2)
  END) AS rolling_avg_3d
  FROM row_tweet;
--EX5:
WITH rank_trans AS(
SELECT transaction_date,
user_id,product_id,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS rank_by_user
FROM user_transactions) 
SELECT transaction_date,user_id,
COUNT(user_id) AS purchase_count
FROM rank_trans
WHERE rank_by_user = '1'
GROUP BY user_id,transaction_date,rank_by_user
ORDER BY transaction_date;
--EX6:
WITH payments AS (
  SELECT 
  merchant_id, 
  EXTRACT(EPOCH FROM transaction_timestamp - 
  LAG(transaction_timestamp) OVER(
  PARTITION BY merchant_id, credit_card_id, amount 
  ORDER BY transaction_timestamp)
  )/60 AS minute_difference 
  FROM transactions) 

SELECT COUNT(merchant_id) AS payment_count
FROM payments 
WHERE minute_difference <= 10;
--EX7: 
WITH ranked_spending AS(
  SELECT 
    category, 
    product, 
    SUM(spend) AS total_spend,
    RANK() OVER (
      PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS ranking 
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY category, product) 
SELECT 
  category, 
  product, 
  total_spend 
FROM  ranked_spending
WHERE ranking <= 2 
ORDER BY category, ranking;
--EX8: 
WITH top_10 AS (
SELECT 
artists.artist_name,
DENSE_RANK() OVER (
ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
FROM artists
JOIN songs
ON artists.artist_id = songs.artist_id
JOIN global_song_rank AS ranking
ON songs.song_id = ranking.song_id
WHERE ranking.rank <= 10
GROUP BY artists.artist_name
)

SELECT artist_name, artist_rank
FROM top_10
WHERE artist_rank <= 5;
