
## BIBLIOTECAS E CONEXÕES

library(DBI)
library(dplyr)
library(readr)
library(lubridate)

con2 <- dbConnect(odbc::odbc(), "repro",encoding="Latin1")

## QUERY

result <- dbGetQuery(con2, statement = read_file('C:\\Users\\REPRO SANDRO\\Documents\\R\\DASHBOARD_COMERCIAL\\RESULT2.sql'))

View(result)





## GERA BASE EM CSV

write.csv2(result,file = "C:\\Users\\REPRO SANDRO\\OneDrive - Luxottica Group S.p.A\\DASHBOARD_COMERCIAL\\result.csv",row.names = FALSE,na="")


## PILARES

pilares <- dbGetQuery(con2, statement = read_file('C:\\Users\\REPRO SANDRO\\Documents\\R\\DASHBOARD_COMERCIAL\\PILARES.sql'))


View(pilares)
