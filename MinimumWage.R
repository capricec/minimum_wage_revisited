setwd("~/Documents/Min_Wage")
#used the same minimum wage csv as in previous work. Data from: http://www.dol.gov/whd/state/stateminwagehis.htm
#states with ranges were averaged
poverty_rates <- read.csv("~/Documents/Min_Wage/poverty_rates.csv", stringsAsFactors=FALSE)
min_wage_data3 <- read.csv("~/Documents/Min_Wage/min_wage_data3.csv")

min_wage_data4 <- merge(min_wage_data3, poverty_rates, by.x = c("State", "Year"), by.y = c("State", "Year"), all.x = TRUE)
write.csv(min_wage_data4, file = "~/Documents/Min_Wage/min_wage_data4")

#creating new column to record which states did not have minimum wages set at the time
#under this system, the federal rate applied
min_wage_data5 <- min_wage_data4
min_wage_data5$Fed <- 0
min_wage_data5$Fed[which(min_wage_data5$Wage == "...")]<- 1
write.csv(min_wage_data5, file = "~/Documents/Min_Wage/min_wage_data5")

#filling in the federal rate where there isn't one for the state
min_wage_data5$Wage[which(min_wage_data5$Wage == "..." && min_wage_data5$Year == 1968)]<- min_wage_data5$Wage[which(min_wage_data5$State == "Federal" && min_wage_data5$Year == 1968)]

#BLS API SETUP
install_github("mikeasilva/blsAPI")
library(blsAPI)
response <- blsAPI('APU000070111')
install.packages("RJSONIO")
library(RJSONIO)
json <- fromJSON(response)

#Downloaded CPI from BLS directly. uploaded via CSV from here: http://www.bls.gov/cpi/cpid1501.pdf table 27 data
CPI <- read.csv("~/Documents/CPI.csv", stringsAsFactors=FALSE)
CPI2 <- CPI
CPI2$Index <- 0
CPI2$Index = 237.897 / CPI2$Annual

min_wage_data6 <- read.csv("~/Documents/Min_Wage/min_wage_data6.csv", stringsAsFactors=FALSE)

min_wage_data7 <- merge(min_wage_data6, CPI2, by.x = "Year", by.y = "Year", all.x = TRUE)
min_wage_data7$RealWage <- min_wage_data7$Wage * min_wage_data7$Index





