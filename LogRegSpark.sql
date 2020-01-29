-- Databricks notebook source

-- Preprocess data for use in a machine learning model

%run ../Includes/Classroom-Setup


USE DATABRICKS;

create table if not exists fireCallsClean
using parquet 
options (
path "mnt/davis/fire-calls/fire-calls-clean.parquet")


-- MAGIC Check that your data is loaded in properly.


SELECT * FROM fireCallsClean LIMIT 10


-- MAGIC Write a query to see what the different `Call_Type_Group` values are and their respective counts.


select Call_Type_Group, count(*) as count
from fireCallsClean
group by Call_Type_Group


-- MAGIC Drop all the rows where `Call_Type_Group = null`. Since we don't have a lot of `Call_Type_Group` with the value `Alarm` and `Fire`, we will also drop these calls from the table. Call this new table `fireCallsGroupCleaned`.


create or replace temporary view fireCallsGroupCleaned

As 
select * 
from fireCallsClean 
where Call_Type_Group is not null and Call_Type_Group not in  ('Alarm', 'Fire')

-- MAGIC Check that every entry in `fireCallsGroupCleaned`  has a `Call_Type_Group` of either `Potentially Life-Threatening` or `Non Life-threatening`.


select Call_Type_Group, count(*) from fireCallsGroupCleaned
group by Call_Type_Group


select count(*) from fireCallsGroupCleaned

-- MAGIC  Select the following columns from `fireCallsGroupCleaned` and create a view called `fireCallsDF` so we can access this table in Python:
-- MAGIC 
-- MAGIC * "Call_Type"
-- MAGIC * "Fire_Prevention_District"
-- MAGIC * "Neighborhooods_-\_Analysis_Boundaries" 
-- MAGIC * "Number_of_Alarms"
-- MAGIC * "Original_Priority" 
-- MAGIC * "Unit_Type" 
-- MAGIC * "Battalion"
-- MAGIC * "Call_Type_Group"



create or replace temporary view fireCallsDF
As 
select Call_Type, Fire_Prevention_District, `Neighborhooods_-_Analysis_Boundaries`, Number_of_Alarms, Original_Priority, Unit_Type, Battalion,Call_Type_Group 
from fireCallsGroupCleaned


select * from fireCallsDF

-- MAGIC Fill in the string SQL statement to load the `fireCallsDF` table you just created into python.

%python

spark.conf.set("spark.sql.execution.arrow.enabled", "true")
MAGIC df = sql("""select Call_Type, Fire_Prevention_District, `Neighborhooods_-_Analysis_Boundaries`, Number_of_Alarms, Original_Priority, Unit_Type, Battalion,Call_Type_Group 
from fireCallsGroupCleaned""")
display(df)

-- MAGIC ## Creating a Logistic Regression Model in Sklearn


-- MAGIC convert the Spark DataFrame to pandas 
-- MAGIC 
-- MAGIC perform a train test split on our pandas DataFrame. We are trying to predict is the `Call_Type_Group`.

%python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
 
pdDF = df.toPandas()
le = LabelEncoder()
numerical_pdDF = pdDF.apply(le.fit_transform)
X = numerical_pdDF.drop("Call_Type_Group", axis=1)
y = numerical_pdDF["Call_Type_Group"].values
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

-- Look at our training data `X_train` which should only have numerical values now.

- %python
display(X_train)


--  create a pipeline with 2 steps. 
-- [One Hot Encoding] Converts our  features into vectorized features by creating a dummy column for each value in that category. 
-- MAGIC 
--  [Logistic Regression model]: classification by predicting the probability that the `Call Type Group` is one label and not the other.

%python
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import OneHotEncoder
from sklearn.pipeline import Pipeline

ohe = ("ohe", OneHotEncoder(handle_unknown="ignore"))
lr = ("lr", LogisticRegression())
pipeline = Pipeline(steps = [ohe, lr]).fit(X_train, y_train)
y_pred = pipeline.predict(X_test)

-- see how well our model performed on test data 

%python
from sklearn.metrics import accuracy_score
print(f"Accuracy of model: {accuracy_score(y_pred, y_test)}")

-- Save pipeline (with both stages) to disk.

 %python
 import mlflow
 from mlflow.sklearn import save_model
 model_path = "/dbfs/" + username + "/Call_Type_Group_lr"
 dbutils.fs.rm(username + "/Call_Type_Group_lr", recurse=True)
 save_model(pipeline, model_path)

-- use MLflow to register the `.predict` function of the sklearn pipeline as a UDF which we can use later to apply in parallel. 

%python
import mlflow
from mlflow.pyfunc import spark_udf
predict = spark_udf(spark, model_path, result_type="int")
spark.udf.register("predictUDF", predict)

-- Create a view called `testTable` of our test data `X_test` so that we can see this table in SQL.

%python
df_Xtest = spark.createDataFrame(X_test)
df_Xtest.createOrReplaceTempView("testTable")

select * from testTable

-- MAGIC Create a table called `predictions` using the `predictUDF` function. Apply the `predictUDF` to every row of `testTable` in parallel so that each row of `testTable` has a `Call_Type_Group` prediction.

USE DATABRICKS;
drop table if exists predictions;

create table predictions as (
select *, cast(predictUDF(Call_Type, Fire_Prevention_District, `Neighborhooods_-_Analysis_Boundaries`, Number_of_Alarms, Original_Priority, Unit_Type, Battalion) as double) as prediction
  FROM testTable
  --LIMIT 10000
)

SELECT * FROM predictions LIMIT 10

