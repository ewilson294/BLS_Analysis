# Author: Eric Wilson
# Date Created: 15 November 2021

"This code extracts data from the BLS API
 You will require your own registration key for the API, it should be
 a character vector named 'registration'"

library(blsAPI)
library(rjson)
library(tidyverse)

blsSeriesIDs <- function(area_code, seasonal_adjustment = 'U', measure = '03'){
    "
     This function is for Local Area Statistics
     seasonal_adjustment <- {'U', 'S}, where 'U' is unadjusted and 'S' is adjusted
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

# Create DataFrame of unemployment rate series IDs
state_and_territories <- blsSeriesIDs(area_codes$area_code[area_codes$area_type_code == 'A'])
ID_and_state_map <- data.frame(IDs = state_and_territories, Territory = area_codes$area_text[area_codes$area_type_code == 'A'])

# Example: Alabama Unemployment Rate, most recent 36 months
# alabama_unemployment_rate <- blsAPI(payload = 'LAUST010000000000003', return_data_frame = TRUE)

# Download US Unemployment Data by State with the BLS API
# bls_payload <- list('seriesid' = state_and_territories, 'registrationKey' = registration)
# US_unemployment_by_state <- blsAPI(bls_payload, return_data_frame = TRUE)
# US_unemployment_by_state <- left_join(US_unemployment_by_state, ID_and_state_map, by = c("seriesID" = "IDs"))
# US_unemployment_by_state$value <- as.numeric(US_unemployment_by_state$value)
# US_unemployment_by_state$Date <- as.Date(paste("1", tolower(US_unemployment_by_state$periodName), US_unemployment_by_state$year, sep = ""), "%d%b%Y")

# Download US Labor Force Data by State with the BLS API
# state_and_territories <- blsSeriesIDs(area_codes$area_code[area_codes$area_type_code == 'A'], measure = '06')
# ID_and_state_map <- data.frame(IDs = state_and_territories, Territory = area_codes$area_text[area_codes$area_type_code == 'A'])
# bls_payload <- list('seriesid' = state_and_territories, 'registrationKey' = registration)
# US_laborForce_by_state <- blsAPI(bls_payload, return_data_frame = TRUE)
# US_laborForce_by_state <- left_join(US_laborForce_by_state, ID_and_state_map, by = c("seriesID" = "IDs"))
# US_laborForce_by_state$value <- as.numeric(US_laborForce_by_state$value)
# US_laborForce_by_state$Date <- as.Date(paste("1", tolower(US_laborForce_by_state$periodName), US_laborForce_by_state$year, sep = ""), "%d%b%Y")

blsEHEids <- function(seasonal_adjustment = 'U', state, area = '00000', 
                      industry = '00000000', data_type = '03'){
    seriesID <- paste('SM', seasonal_adjustment, state, area, industry, data_type, sep = "")
    return(seriesID)
}

# Create DataFrame of Average Hourly Earnings of All Nonfarm Employees, In Dollars 
state_wages <- blsEHEids(state = state_codes$state_code)
wage_to_state_map <- data.frame(IDs = state_wages, State = state_codes$state_code)

# Download US Nonfarm Hourly Wage Data, by State
# bls_payload <- list('seriesid' = state_wages, 'registrationKey' = registration)
# US_hourlyWages_by_state <- blsAPI(bls_payload, return_data_frame = TRUE)
