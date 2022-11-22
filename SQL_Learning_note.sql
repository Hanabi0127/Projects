# Study started 2022-11-21 ~ Present
# This is my study note where I write and store my SQL codes that I learned from Udemy course.
# The purpose of writing this code is to share my learning, record my progression, and to lookup codes when I need to.

# 2022-11-21 Study note

# How to create database
CREATE DATABASE hello_my_db;

# How to show database list.
SHOW DATABASE;

# How to delete a database
DROP DATABASE hello_my_db;

# How to create and use database
CREATE DATABASE database_1;
USE database_1;

# How to create a table
# A table with two columns: name and age.
CREATE TABLE customers(
    name varchar(100),
    age int);

# How to show table, table columns, and datatypes.
SHOW TABLES;
SHOW COLUMNS FROM Customers;
DESC Customers;

# How to delete table.
DROP TABLE Customers;

# How to insert data.
INSERT INTO Customers(name, age)
VALUES ("Tina", 13), ("Taylor", 15), ("Park Jin Seok", 24)

# How to show warnings.
SHOW WARNINGS;

# How to set NULL and NOT NULL for columns, Default value, Primary Key, and AUTO_INCREMENT.
# 6 columns: id, last name, first name, middle name, age, and status.
# Id, last name, first name, age and status cannot be NULL and id is our unique primary key. Set default value to 'employed' for status. Use AUTO_INCREMENT for id column.
CREATE TABLE Employees(
    id int AUTO_INCREMENT NOT NULL PRIMARY KEY,
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    middle_name varchar(255),
    age int NOT NULL,
    current_status varchar(50) NOT NULL DEFAULT "Employed"
);