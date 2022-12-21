# SQL Portfolio: "Supermart Grocery Sales - Retail Analytics Dataset"
# Name: Taehwan Kim
# Date: 2022/12/14 ~ 2022/12/14
# In this portfolio, I'm going to perform a simple EDA by using basic SQL skills to explore the dataset and extract information that we want to retrieve.
# Then, we're going to answer some questions related to the dataset and make an approach to some realistic questions.

##  Introduction
# The dataset is downloaded from "Kaggle" by Mohamed Harris and it is a fictional dataset and all the information in the dataset are not real. 
# The dataset is designed with an assumption that the orders are placed by customers living in the state of Tamil Nadu, India.
# Before we start, let's make a database and import our csv file to our database. 

CREATE DATABASE supermart;
USE supermart;

# Done. The name of our database is supermart and imported the csv file as a table (The table name is also supermart). Let's view our table.
SELECT * FROM supermart;
SELECT COUNT(*) FROM supermart;

# There are total of 9 columns and 9994 rows. Becasue we're not going to use all 9 columns, we're going to select only valid columns out of the table.
# Then, what are the valid columns that we can use in our EDA?
# We need customer name, category, sub category, city, order date, region, sales, and profit for various reasons but what about Order ID and State?
# The order ID column would be useful if we're interacting with other tables that has the same column referencing to Order ID column but since we're only using this table for this project,
# it's not very useful in this case. Same reason for state column because as we mentioned above, these customers are living in the state of Tamil Nadu, India which means,
# there is no customer from other than Tamil Nadu.

# Let's find how many orders are placed in total for each region and add a column for percentage in total orders. 
SELECT Region, COUNT(*) AS Count, CONCAT(ROUND((COUNT(*)/9994)*100,2)," ", "%") AS percentage
FROM supermart
GROUP BY Region
ORDER BY Count DESC;

# It seems like 32.05 % of our placed orders are from the customers reside in Western cities, 28.5 % from Eastern cities , 23.24 % from Central cities, 16.2 % from Southern cities, and
# 0.01 % from Northern City. This indicates how much portion of placed orders are coming from which region of the state and we can roughly see the whole picture of our market
# and targeting region. Let's add some more details to our finding. Let's find how much sales and profits are made from each region.
SELECT Region, COUNT(*) AS Count, CONCAT(ROUND((COUNT(*)/9994)*100,2)," ", "%") AS percentage, SUM(Sales) AS Total_Sales, ROUND(SUM(Profit),2) AS Total_Profit
FROM supermart
GROUP BY Region
ORDER BY Total_Sales DESC;

# The key idea of this result is that which region has to be prioritized to maximize our sales and profit.
# If we're going to advertise for new products or discount event but only for one region, we would want to advertise in Western side of the state because
# most of our sales and profit are made from the customers from Western side. The advertisement would be much more effective than Southern or Northern side of the state.
# Our second option would be either Eastern or Central side since we get over 25% of total placed orders from both regions.

# Now we know which region of customer purchases the most, then what category is the most popular item in the store?
# It is important to know which category that the customers purchases the most so that we make sure to have those category of items in stock.
# Let's find top 5 best selling categories in the store.
SELECT Category, COUNT(*) AS Count
FROM supermart
GROUP BY Category
ORDER BY Count DESC
LIMIT 5;

# As we can see in the result, snacks are the most popular category of items that the majority of customer puchases in the store. The rest of top selling categories
# are also very popular and close to each other in the range of 100 orders. This result shows that the ranking of customer's demands in each cateogry and 
# it is important to aware that these category of items requires to have a closer look into the number of supplies in the warehouse so that we don't end up having a shortage in stock.
# Also, when we're placing an order on these categories, we can roughly estimate the number of orders. We can add sub_category column to be more speicifc with which items are exactly sold but
# We're going to skip that for now. Let's add 2 more columns, total sales and total profit and re-order them by total profit.

SELECT Category, COUNT(*) AS Count, SUM(Sales) AS Total_Sales, ROUND(SUM(Profit),2) AS Total_Profit
FROM supermart
GROUP BY Category
ORDER BY Total_Profit DESC
LIMIT 5;

# It is always important to track down which category makes the most sales and profit in the store. Because now we ordered them by total profit,
# we can determine which category makes the most profit. In overall, snacks are the most profitable items in the store followed by Eggs,Meat&Fish
# and Fruit&Veggies. 

# This time, let's make an annual report for each year. The report should have the total profit and total sales made in the store by each year.
SELECT SUBSTRING(Order_Date, -4) AS Year, COUNT(*) AS Count, SUM(Sales) AS Total_Sales, ROUND(SUM(Profit),2) AS Total_Profit
FROM supermart
GROUP BY Year
ORDER BY Year;

# As we can see, we noticed that the total number of counts, total sales and total profit increased by every year.
# This can be an evidence that the store is rapidly growing. Because the first 2 years of business, there is an improvement in our sales but not too significant.
# However, after 2016, the number of orders has dramatically increased along with our total sales and profit.
# The next year, the total sales and profit increased even more than the past year. This means every year, more customers are visiting the store and purchasing items.
# Perhaps, there could be potential external factors are applied to this result such as growing population in the area, no substitution near the area, and more.
# Nonetheless, as long as the business is growing, our job is to keep this retention and maintain what we have. 
# Let's add one more table to our annual report. This time, we're going to be more specific with our total sales and total profit. Let's create a table that indicates the total sales and
# the total profit of each month in corresponding years. Then, sort them out in appropriate order.
SELECT MONTHNAME(STR_TO_DATE(REPLACE(SUBSTRING(Order_Date,1,2), "/", ""), "%m")) AS Month,
		SUBSTRING(Order_Date,-4) AS Year,
		SUM(Sales) AS Total_Sales,
		ROUND(SUM(Profit),2) AS Total_Profit
FROM supermart
GROUP BY Month, Year
ORDER BY Year, STR_TO_DATE(REPLACE(SUBSTRING(Order_Date,1,2), "/", ""), "%m");

# One thing that we noticed is that there is one common pattern lying on every year. We noticed that there are some months that we have relatively higher total sales than other months and those
# months are September, November, and December. This could be the affect of world wide events like Halloween, Christmas, and New Year. Every year we have more total sales and total profit on these months.
# Therefore, we make sure to have sufficient amount of items ready in the warehouse and prepare for more customers shopping in the store.
# This is important thing to know as a businessman because there are some products that are sensitive to expire date such as dairy products. So it's not a good idea to receive excessive dairy products and not be able to sell
# surplus amount of products. Therefore, it is important to know which months are the busy time of the year so that we can find an equilibrium solution to have exact amount of items received on specific month.

# Next is, we move onto customers. Let's make a scenario. If we want to give out coupons to our VIP customers reside in Western area, we want to have specific criterion to distinguish which
# customers are considered as VIP. Let's bring out each customer's purchase history.
# Before we start, Let's find the total number of customers from West who purchased in the store.
SELECT COUNT(DISTINCT(Customer_Name)) FROM supermart
WHERE Region = "West";

# Done. We have total of 50 customers visited to our store. If we want to consider top 10% of customers who purchased the most in the store as a VIP, we want to find top 10% of 50 customers which is top 5 customers.
SELECT Customer_Name, SUM(Sales) AS Total
FROM supermart
WHERE Region = "West"
GROUP BY Customer_Name
ORDER BY Total DESC
LIMIT 5;

# These 5 customers are the loyal customers to our store. Therefore, we can give out coupons to these customers.
# In our next scenario, Let's say we want to find the list of customer's name who purchased in our store in 2018.
# Then, we want to make a new column named Status, this column will indicate the supply status of each category in 2018.
# Let's be pretend that we had a world wide shortage in Fruits & Veggies and Food Grains due to a abnormal climate change. So we want to indicate the status of categories whoever purchased in those two categories will
# be shown as "SHORTAGE_SUPPLY", if not, it will be shown as "NORMAL" in status column.
SELECT Customer_Name, SUBSTRING(Order_Date,-4) AS Year, Category, Sub_Category , Region,
	CASE
		WHEN Category = "Food Grains" OR  Category = "Fruits & Veggies" THEN "SHORTAGE_SUPPLY"
        ELSE "NORMAL"
	END AS Status
FROM supermart
WHERE SUBSTRING(Order_Date,-4) = "2018"
ORDER BY Status DESC, Category;

# As we can see in the result, we can find the status column at the end of our table and it indicates the customers who purchased items that sorted as 
# either Food Grains or Fruits & Veggies, as "SHORTAGE_SUPPLY" and the other categories are listed as "NORMAL". In this way, we can easily sort out which customer
# purchased the items that distributed as shortage items in 2018.
