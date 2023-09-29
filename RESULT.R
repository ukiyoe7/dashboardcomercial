
## BIBLIOTECAS E CONEXAO DB

library(DBI)
library(dplyr)
library(readr)

con2 <- dbConnect(odbc::odbc(), "repro",encoding="Latin1")

## QUERYA

result <- dbGetQuery(con2, statement = read_file('RESULT.sql'))


## GERA BASE EM CSV E SALVA EM DIRETORIO

write.csv2(result,file = "result.csv",row.names = FALSE,na="")