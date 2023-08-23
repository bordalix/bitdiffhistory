# Bitdiffhistory

Ruby script that scrapes https://btc.com/stats/diff and produces a CSV file.

Each line of this file has the following columns:

- **block_height**: block height (aka number)
- **block_timestamp**: when this block was mined
- **difficulty_absolute**: absolute value of difficulty
- **difficulty_change_percentage**: difficulty change in percentage
- **bits**: difficulty represented as bits
- **time_between_blocks**: average time between blocks for last 2016 blocks
- **hashrate_pretty**: easy to read hashrate value
- **hashrate_units**: hashrate absolute value
- **difficulty_abs_change**: absolute change in difficulty
- **hashrate_u_abs_change**: absolute change in hashrate

### Usage

Install necessary gem:

```
gem install nokogiri
```

Run script:

```
./scrape.rb > export.csv
```

Google sheet (as of August 23, 2023):

https://docs.google.com/spreadsheets/d/1-bkLvQFz3dUvDmf_EuNip0BUzPklwUippvlgyqALp1Q/edit?usp=sharing
