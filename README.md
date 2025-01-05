# pa-discogs-dwh
# PA Roman Meyer

In order to run this project perform the following steps:
- Clone the following repository: https://github.com/philipmat/discogs-xml2db and import the data into a postgresql database.
- Run cleaning/fix.sql to correct the foreign key constraints
- create and populate intermediary tables by running hierarchies/create_dimension_tables.sql and importing the respective csv-files into those tables and then run hierarchies/create_and_fill_intermediary_tables.sql and create_intermediate_format.sql
- create target-db tables by running all the scripts in the target-db directory (first create_target_db_tables.sql)

Now all the required tables for an analysis platform are created
