psql postgres -c "CREATE USER nfl_rushing WITH ENCRYPTED PASSWORD 'nfl_rushing';"
psql postgres -c "ALTER USER nfl_rushing WITH CREATEDB;"
psql postgres -c "CREATE DATABASE nfl_rushing_database OWNER nfl_rushing;"
psql postgres -c "CREATE DATABASE nfl_rushing_database_test OWNER nfl_rushing;"
psql postgres -c "CREATE DATABASE nfl_rushing_database_development OWNER nfl_rushing;"
bundle install
RAILS_ENV=development rails db:migrate
RAILS_ENV=production rails db:migrate
bundle exec ruby script/process_rushing_stats_for_database_insertion.rb -f ../rushing.json RAILS_ENV=development
bundle exec ruby script/process_rushing_stats_for_database_insertion.rb -f ../rushing.json RAILS_ENV=production
