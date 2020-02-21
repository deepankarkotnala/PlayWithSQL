## Data Cleaning with SQL

Most of the data we get is usually full of noise, so we need to clean the data before analysing it.
Here, we present some methods of cleaning data. These statements can be used effectively to remove the unwanted chunk from the data, concatenate the data, etc. Most of the statements stated in this module are specific to certain data types. However, most of the time, using a particular statement changes the data to the appropriate type.

For example, LEFT, RIGHT, and TRIM is used to select only certain elements from the strings, but we can use them with numbers and dates as well. For the purpose of these functions, they are considered to be strings.

### LEFT, RIGHT, and TRIM

The LEFT statement is used to extract a certain number of characters from the left side of a string and present them in the form of a separate string.
The syntax is —

```sql
LEFT (string, number of characters)
```

An example is —
```sql
SELECT LEFT('Deepankar',2);
```
Output:
```sql
De
```

The RIGHT statement extracts a certain number of characters from the right side of a string.

The syntax is —
```sql
RIGHT (string, number of characters)
```
An example is —
```sql
SELECT RIGHT('Deepankar', 3);
```

Output:

```sql
kar
```

The LENGTH statement returns the length of the string.

The syntax is —
```sql
LENGTH(string)
```
An example is —

Let’s suppose that there is a column named ‘Date’, which consists of dates and timestamps. Assume that the LENGTH(date) function will return 28 on this column. The first 10 characters in that field will be the date, followed by a space, making a total of 11 characters. The RIGHT statement can be used in the following way to extract the timestamp from the ‘date’ column:
```sql
SELECT date,
RIGHT(date, LENGTH(date)-11) As extracted_time
FROM Name_of_the_table
```

The TRIM statement is used to remove specified characters from the beginning and/or end of a string. The TRIM statement takes three arguments. The first argument is to specify where you want to remove the characters from.

If you want to remove characters from the beginning, use the keyword ‘leading’.

If you want to remove characters from the end, use the keyword ‘trailing’.

If you want to remove characters from both ends, use the keyword ‘both’.

The second argument is to state which character is to be removed. You have to provide the character in quotes for it to be removed from the specified ends. Finally, the third argument is to specify the text from which you need to remove the specified character, using the from keyword.

The syntax is —
```sql
TRIM (method ‘character to trim’ from ‘text from which you want to trim’)
```
An example is —
```sql
Select TRIM(both ' ' FROM '  location ')
```

POSITION, SUBSTR and CONCAT

The POSITION statement returns the position of the given substring in the target string (counting from the left). If the given substring is not present in the target string, the statement returns a 0. If the given substring is present multiple times, the position of the first occurrence is returned as the output. For example, the following query will return the position of the character ‘A’ (note that the POSITION statement is not case sensitive), where it first appears in the string ‘DEEPANKAR’.

```sql
Select POSITION('A' IN 'DEEPANKAR');
```
The SUBSTR statement can be used to extract a string from the middle of another string.

The syntax is —
```sql
SUBSTR(*string*, *starting character position*, *# of characters*)
```

An example is —

```sql
Select SUBSTR('DEEPANKAR', 2, 3);
 ```

The CONCAT statement is used to concatenate characters together to form a single string. Just provide all the characters/substrings as arguments of the CONCAT function in the order you want them to be concatenated, and separate the different characters/substrings with commas. The output will be a concatenated string.

The syntax is —
```sql
CONCAT(*substring1*,* substring2*) AS Complete_String
```
An example is —
```sql
Select CONCAT('DEEP','ANKAR') as FullName;
```
The LOWER and UPPER statements are used to convert a string to lower and upper cases, respectively.

The syntax is —
```sql
UPPER(string)

LOWER(string)
```
An example is —  
```sql
select UPPER('deepankar');
Select LOWER('DEEpankaR');
```

Output:
```sql
DEEPANKAR
deepankar
```
-- --------------------------------------------------------------------

## Date Time

### The EXTRACT statement can be used to get the required information from the ‘Date’ column.

```sql
Select CURRENT_TIME() AS time,
CURRENT_DATE() AS date,
CURRENT_TIMESTAMP() AS timestmp,
localtime() AS local,
LOCALTIMESTAMP() AS localtimestmp,
NOW() AS now;
```
#### Output
```sql
# time, date, timestmp, local, localtimestmp, now
'00:45:25', '2020-02-22', '2020-02-22 00:45:25', '2020-02-22 00:45:25', '2020-02-22 00:45:25', '2020-02-22 00:45:25'
```


```sql
SELECT CURRENT_DATE() AS date, 
EXTRACT(year FROM NOW()) AS year,
EXTRACT(month FROM NOW()) AS month,
EXTRACT(day FROM NOW()) AS day;
```
#### Output
```sql
# date, year, month, day
'2020-02-22', '2020', '2', '22'
```
