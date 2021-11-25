# Author: Eric Wilson
# Date Created: 15 November 2021

# This is initial, messy code to extract data from the BLS API
# You will require your own registration key for the API, it should be
# a character vector named 'registration'

library(blsAPI)
library(rjson)

blsSeriesIDs <- function(area_code, seasonal_adjustment = 'U', measure = '03'){
    "seasonal_adjustment <- {'U', 'S}, where 'U' is unadjusted and 'S' is adjusted
     measure <- {'03', '04', '05', '06'} where '03' is Unemployment Rate,
        '04' is Unemployment, '05' is Employment, and '06' is Labor Force
     area_code refers to BLS area codes
    "
    seriesID <- paste('LA', seasonal_adjustment, area_code, measure, sep = "")
    return(seriesID)
}

# Load in the state codes
state_codes <- read.table('./BLS DATA/sm.state.txt', sep ='\t', header = TRUE, colClasses = "character")
area_file <- readLines('BLS DATA/la.area.txt')
area_file <- gsub('([A-Z])\t[(A-Z0-9]{15}) (.+) ([0-9]+)\t([TF])\t([0-9]+)', "\\1'\\2'\\3'\\4'\\5'\\6'", area_file)
tc <- textConnection(area_file)
area_codes <- read.table(tc, sep = '\t', header = TRUE, colClasses = "character", quote = "")
close(tc)

# Create DataFrame of unemployment rate
state_and_territories <- blsSeriesIDs(area_codes$area_code[area_codes$area_type_code == 'A'])

# Example: Alabama Unemployment Rate, most recent 36 months
# alabama_unemployment_rate <- blsAPI(payload = 'LAUST010000000000003', return_data_frame = TRUE)

# Download Data with the BLS API
# bls_payload <- list('seriesid' = state_and_territories, 'registrationKey' = registration)
# US_unemployment_by_state <- blsAPI(bls_payload, return_data_frame = TRUE)
