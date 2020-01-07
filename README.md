## 1) Data Wrangling, Analysis and AB Testing, an e-Commerce Website in SQL
### Description:

Running an experiment at an item-level, which means all users who visit will see the same page, but the layout of different item pages may differ. 

#### Steps:
a) Compare the final_assignments_qa table to the assignment events we captured for user_level_testing. 

b) Write a query and table creation statement to make final_assignments_qa look like the final_assignments table, filling in the missing values with a place holder of the appropriate data type.

c) Use the final_assignments table to calculate the order binary for the 30 day window after the test assignment for item_test_2 (including the day the test started)

d) Use the final_assignments table to calculate the view binary, and average views for the 30 day window after the test assignment for item_test_2. (including the day the test started)

e) Use the https://thumbtack.github.io/abba/demo/abba.html to compute the lifts in metrics and the p-values for the binary metrics ( 30 day order binary and 30 day view binary) using a interval 95% confidence.

### Results:
#### Order binary:
There is only 0.5% improvement (observed relative lift in success rate between control and treatment) and p-value is 0.94, meaning that there is a no significant difference in the number of orders within 30days of the assigned treatment date between the two treatments.

#### View binary:
The lift value is 2% and the p_value is 0.1. There is not a significant difference in the number of views within 30days of the assigned treatment date between the two treatments.



## 2) Profiling and Analyzing the Yelp Dataset Coursera Worksheet
### First part:
A series of questions are answered to profile and understand. 
### Second part: 
Inferences and analysis of the data for a particular research question.

For both parts of this assignment, use this the "worksheet" is provided online. Dataset (Yelp Dataset Worksheet) and codes are on Jupyter Notebook (the codes and answers are uploaded in three formats (text, pdf, docx) on the respiratory). 


![alt text](https://github.com/MerEsf/SQLforDataScienceProject/blob/master/Yelp.png)

### Learning outcomes:
- Posing more reviews does not necessarily correlate with more fans
- There is not a strong correlation between having a high number of fans and being listed as "useful" or "funny
- There is a strong correlation between the location of the business and their rating
- There is not a strong correlation between the number of likes and stars in the reviews
