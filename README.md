# theScore "the Rush" Interview Challenge
Here is a quick demo of the main page with no filtering or sorting:
![Screenshot](./screenshot.png)

## Background
We have sets of records representing football players' rushing statistics. All records have the following attributes:
* `Player` (Player's name)
* `Team` (Player's team abbreviation)
* `Pos` (Player's postion)
* `Att/G` (Rushing Attempts Per Game Average)
* `Att` (Rushing Attempts)
* `Yds` (Total Rushing Yards)
* `Avg` (Rushing Average Yards Per Attempt)
* `Yds/G` (Rushing Yards Per Game)
* `TD` (Total Rushing Touchdowns)
* `Lng` (Longest Rush -- a `T` represents a touchdown occurred)
* `1st` (Rushing First Downs)
* `1st%` (Rushing First Down Percentage)
* `20+` (Rushing 20+ Yards Each)
* `40+` (Rushing 40+ Yards Each)
* `FUM` (Rushing Fumbles)

In this repo is a sample data file [`rushing.json`](/rushing.json).

## Basic App Structure
The backend of the server is a Rails 6 application using Ruby 2.7
The frontend of the server is written in React, backed by Redux.

## Primary backend route
There is one main get route for fetching statistics. It handles both the JSON (web-side) and CSV fetching. Specifically, it dictates the response format by using the 'Accept' header.

`GET show_stats`

| Parameter | Parameter Description               | Type   | Expected values   | Required |
| ----------| ------------------------------------|--------| ------------------| ---------|
| page_num  | The page number of data to fetch    | int    | >= 1              | yes      |
| page_size | The size of pages                   | int    | >= 1              | yes      |
| sort_by   | The column to sort by               | string | yards/tds/longest | no       |
| order_dir | The ordering of the sorting         | string | asc/desc          | no       |
| query     | The query to filter results by name | string | &lt;any value&gt; | no       |

JSON Returns:
| Output      | Output Description                                                               | Type   |
| ------------| ---------------------------------------------------------------------------------|--------|
| stats       | An array of the fetched rushing stat                                             | array  |
| enable_back | Whether we should enable fetching the page before, i.e. is there an earlier page | bool   |
| enable_next | Whether we should enable fetching the next page, i.e. is there a later page      | bool   |

Example output:
```
{
  stats: [
    {
      attempts: 254,
      attempts_per_game: 19.5,
      first_down_percentage: 24,
      first_downs: 61,
      fumbles: 2,
      id: 234,
      is_longest_td: false,
      longest: 48,
      name: "Melvin Gordon",
      player_id: 234,
      pos: "RB",
      runs_forty_plus: 3,
      runs_twenty_plus: 7,
      tds: 10,
      team_name: "SD",
      yards: 997,
      yards_per_attempt: 3.9,
      yards_per_game: 76.7
    },
    {
      attempts: 217,
      attempts_per_game: 16.7,
      first_down_percentage: 22.1,
      first_downs: 48,
      fumbles: 4,
      id: 221,
      is_longest_td: false,
      longest: 47,
      name: "Carlos Hyde",
      player_id: 221,
      pos: "RB",
      runs_forty_plus: 2,
      runs_twenty_plus: 7,
      tds: 6,
      team_name: "SF",
      yards: 988,
      yards_per_attempt: 4.6,
      yards_per_game: 76
    }
  ],
  enable_back: false,
  enable_next: true
}
```

CSV Returns:
A streamed CSV response of rushing stats, based on the filter, like the following:
```
Player,Team,Pos,Att/G,Att,Yds,Avg,Yds/G,TD,Lng,1st,1st%,20+,40+,FUM
Melvin Gordon,SD,RB,19.5,254,997,3.9,76.7,10,48,61,24.0,7,3,2
Carlos Hyde,SF,RB,16.7,217,988,4.6,76.0,6,47,48,22.1,7,2,4
```

## Installing and Running
Postgres is required for this application. If you are on a Mac and use Homebrew, you can install and start Postgres with:
```
brew install postgres
brew services start postgresql
```

To set up the database and appropriate user, run the following script:
```
cd nfl-rushing-app
script/set_up_environment.sh
```
It will also parse the rushing.json file into the Postgres database

To start the server, run `rails server`

To access the rushing statistics, visit `http://localhost:3000/rushing`

## Running Tests
To run the Rails tests:
```
cd nfl-rushing-app
bundle exec rspec spec
```

## Design Decisions
I decided to parse the data into a database because it allows separation of data source/retrieval and actual use. It is possible that there could be many sources of data and having scripts to sanitize them and parse them into a database for a web application is a standard practice and felt most appropriate. In a related, more structured sense, it would be appropriate to have a service that runs periodically to refetch the rushing statistics and update the database. I designed the JsonParser to support such a use case.

I wrote the front-end in React, and Redux to back it, because those are very commonly used in industry. Their modular design allows for reuse and good encapsulation. Redux also allows components themselves to be much simpler by just accepting props and having actions and reducers be the pieces that do the heavy-lifting.

I decided to perform a request to the server per general query parameter change. I had considered loading more pages into the browser, but was unconvinced with the use of such schemes to move between pages. It would speed up most back and next page interactions, but the benefit is unclear in terms of code complexity. I would like to further evaluate usage to determine how much added benefit there would be for such a change, how many pages should be cached, etc.

I decided to use the file-saver module to create a downloadable attachment (for the CSV download). I have used it in the past and it's a common strategy. For extremely large files, I would more thoroughly investigate the implications.

I decided to use the default Puma server provided as part of Rails 6.0. I would consider using another server like Unicorn or Passenger if the need arose.

## Future Improvements
* Remove the passwords from the set-up script (and config/database.yml). For this submission, it's reasonable, but in a production system, I would be using Vault (or some other credential storage service)
* Dockerizing the environment and startup. That would make management and startup much less manual
* More extensive and explicit React testing, especially more complete Redux testing. The crux of the front-end logic is in the actions and reducers
* Implement debouncing for the query search (could be done through a delay). It can be expensive to kick off a request per query change
* Restructure the CSV file download to not download an attachment in-browser
* Support parsing URL parameters directly. It would be nice to be able to search for players, and have the URL update, so that the link could be passed to someone else more seamlessly 
