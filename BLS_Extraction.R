# This is initial, messy code to extract data from the BLS API

library(blsAPI)
library(rjson)

# Load in the state codes
state_codes <- read.table('./BLS DATA/sm.state.txt', sep ='\t', header = TRUE, colClasses = "character")

# Example: Alabama Unemployment Rate, most recent 36 months
alabama_unemployment_response <- blsAPI('LAUST010000000000003')
alabama_json <- fromJSON(alabama_unemployment_response)
alabama_unemployment_unlist <- unlist(alabama_json$Results$series[[1]]$data)
alabama_unemployment_rate <- matrix(alabama_unemployment_unlist[c(-4,-6,-7)], ncol = 4, byrow = T)
colnames(alabama_unemployment_rate) <- c('year', 'period', 'periodName', 'value')
alabama_unemployment_rate <- data.frame(alabama_unemployment_rate)
