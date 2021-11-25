# This is initial, messy code to extract data from the BLS API

library(blsAPI)
library(rjson)

# Load in the state codes
state_codes <- read.table('./BLS DATA/sm.state.txt', sep ='\t', header = TRUE, colClasses = "character")

# Example: Alabama Unemployment Rate, most recent 36 months
alabama_unemployment_rate <- blsAPI(payload = 'LAUST010000000000003', return_data_frame = TRUE)
