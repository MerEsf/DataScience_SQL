# SQLforDataScienceProject

## Profiling and Analyzing the Yelp Dataset Coursera Worksheet
### First part:
A series of questions are answered to profile and understand. 
### Second part: 
Inferences and analysis of the data for a particular research question.

For both parts of this assignment, use this the dataset is provided online. Both dataset and codes are on Jupyter Notebook (Because the course was on Jupyter Notebook the text file is uploaded on the respiratory). 

![alt text](https://d3c33hcgiwev3.cloudfront.net/imageAssetProxy.v1/hOlYbrgyEeeTsRKxhJ5OZg_517578844a2fd129650492eda3186cd1_YelpERDiagram.png?expiry=1545696000000&hmac=vcB_9oSPRTq6lonUaySzcPH84Bp1q9mdHRo36GhpzpY)

Part 1: Yelp Dataset Profiling and Understanding
1. Profile the data by finding the total number of records for each of the tables below:
i. Attribute table =
ii. Business table =
iii. Category table =
iv. Checkin table =
v. elite_years table =
vi. friend table =
vii. hours table =
viii. photo table =
ix. review table =
x. tip table =
xi. user table =
2. Find the total number of distinct records for each of the keys listed below:
i. Business =
ii. Hours =
iii. Category =
iv. Attribute =
v. Review =
vi. Checkin =
vii. Photo =
viii. Tip =
ix. User =
x. Friend =
xi. Elite_years =
3. Are there any columns with null values in the Users table? Indicate "yes," or "no."
4. Find the minimum, maximum, and average value for the following fields:
i. Table: Review, Column: Stars
min: max: avg:
ii. Table: Business, Column: Stars
min: max: avg:
iii. Table: Tip, Column: Likes
min: max: avg:
iv. Table: Checkin, Column: Count
min: max: avg:
v. Table: User, Column: Review_count
min: max: avg:
5. List the cities with the most reviews in descending order:
SQL code used to arrive at answer:
Copy and Paste the Result Below:
6. Find the distribution of star ratings to the business in the following cities:
i. Avon
SQL code used to arrive at answer:
Copy and Paste the Resulting Table Below (2 columns - star rating and count):
ii. Beachwood
SQL code used to arrive at answer:
Copy and Paste the Resulting Table Below (2 columns - star rating and count):
7. Find the top 3 users based on their total number of reviews:
8. Does posing more reviews correlate with more fans?
Please explain your findings and interpretation of the results:
9. Are there more reviews with the word "love" or with the word "hate" in them?
10. Find the top 10 users with the most fans:
11. Is there a strong correlation between having a high number of fans and being listed
as "useful" or "funny?"
SQL code used to arrive at answer:
Copy and Paste the Result Below:
Please explain your findings and interpretation of the results:
Part 2: Inferences and Analysis
1. Pick one city and category of your choice and group the businesses in that city
or category by their overall star rating. Compare the businesses with 2-3 stars to
the businesses with 4-5 stars and answer the following questions. Include your code.
i. Do the two groups you chose to analyze have a different distribution of hours?
ii. Do the two groups you chose to analyze have a different number of reviews?
iii. Are you able to infer anything from the location data provided between these two
groups? Explain.
SQL code used for analysis:
1/24/2018 https://d3c33hcgiwev3.cloudfront.net/_daf7b462ae8620d9690e739c8b21a834_YelpDataCourseraPR.txt?Expires=1516924800&Signature=YNu…
https://d3c33hcgiwev3.cloudfront.net/_daf7b462ae8620d9690e739c8b21a834_YelpDataCourseraPR.txt?Expires=1516924800&Signature=YNuY~ZJP… 4/4
2. Group business based on the ones that are open and the ones that are closed. What
differences can you find between the ones that are still open and the ones that are
closed? List at least two differences and the SQL code you used to arrive at your
answer.
i. Difference 1:
ii. Difference 2:
SQL code used for analysis:
3. For this last part of your analysis, you are going to choose the type of analysis you
want to conduct on the Yelp dataset and are going to prepare the data for analysis.
Ideas for analysis include: Parsing out keywords and business attributes for sentiment
analysis, clustering businesses to find commonalities or anomalies between them,
predicting the overall star rating for a business, predicting the number of fans a
user will have, and so on. These are just a few examples to get you started, so feel
free to be creative and come up with your own problem you want to solve. Provide
answers, in-line, to all of the following:
i. Indicate the type of analysis you chose to do:
ii. Write 1-2 brief paragraphs on the type of data you will need for your analysis
and why you chose that data:
iii. Output of your finished dataset:
iv. Provide the SQL code you used to create your final dataset:
