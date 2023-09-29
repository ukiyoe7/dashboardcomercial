
## BIBLIOTECAS E CONEXAO DB

library(DBI)
library(dplyr)
library(readr)

con2 <- dbConnect(odbc::odbc(), "repro",encoding="Latin1")

## QUERY

result <- dbGetQuery(con2, statement = read_file('RESULT.sql'))

View(result)


## GERA BASE EM CSV

write.csv2(result,file = "C:\\Users\\REPRO SANDRO\\OneDrive - Luxottica Group S.p.A\\DASHBOARD_COMERCIAL\\result.csv",row.names = FALSE,na="")