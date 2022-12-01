# This Python scrip will read the acinys_types.csv file and create 
# a dictionary of the types and their corresponding values.
# the dictionary will be saved as a SQL insert query file. 
# The file will be named avinya_types.sql
# The file will be saved in the same directory as the script.
# THe name of the database table to insert into is avinya_type
# The csv file column to SQL tabale mapping will be as follows 
# Entity to description 
# Name to name
# Global Type to global_type 
# Foundation Type to foundation_type 
# Focus to focus 
# Level to level 

import csv
import os

# read the csv file 
with open('avinya_types.csv', 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    with open('avinya_types.sql', 'w') as sql_file:
        for line in csv_reader:
            sql_file.write("INSERT INTO avinya_type (description, name, global_type, foundation_type, focus, level) VALUES ('%s', '%s', '%s', '%s', '%s', '%s');")

# use Python Pandas to read the csv file and create a dataframe
import pandas as pd
df = pd.read_csv('avinya_types.csv')
print(df)
# process the dataframe and create a dictionar
# create a dictionary of the dataframe
# the dictionary will be used to create the SQL insert query
# the dictionary will be saved as a SQL insert query file.
# The file will be named avinya_types.sql
# The file will be saved in the same directory as the script.
# THe name of the database table to insert into is avinya_type
# The csv file column to SQL tabale mapping will be as follows
# Entity to description
# Name to name
# Global Type to global_type
# Foundation Type to foundation_type
# Focus to focus
# Level to level
with open('avinya_types.sql', 'w') as sql_file:
    for index, row in df.iterrows():
        print(row['Entity'], row['Name'], row['Global Type'], row['Foundation Type'], row['Focus'], row['Level'])
        description = 'null'
        if (pd.isna(row['Entity']) == False):
            description = "'" + row['Entity'] + "'"
        name = 'null'
        if (pd.isna(row['Name']) == False):
            name = "'" + row['Name'] + "'"
        global_type = 'null'
        if (pd.isna(row['Global Type']) == False):
            global_type = "'" + row['Global Type'] + "'"
        foundation_type = 'null'
        if (pd.isna(row['Foundation Type']) == False):
            foundation_type = "'" + row['Foundation Type'] + "'"
        focus = 'null'
        if (pd.isna(row['Focus']) == False):
            focus= "'" + row['Focus'] + "'"
        level = -1
        if (pd.isna(row['Level']) == False):
            level = int(row['Level'])
        print("INSERT INTO avinya_type (description, name, global_type, foundation_type, focus, level) VALUES (%s, %s, %s, %s, %s, %s);\n"%(description, name, global_type, foundation_type, focus, level))
        sql_file.write("INSERT INTO avinya_type (description, name, global_type, foundation_type, focus, level) VALUES (%s, %s, %s, %s, %s, %s);\n"%(description, name, global_type, foundation_type, focus, level))



