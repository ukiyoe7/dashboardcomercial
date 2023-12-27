
library(DBI)
library(dplyr)
library(readr)
library(lubridate)

con2 <- dbConnect(odbc::odbc(), "repro",encoding="Latin1")


## RESULT

result <- dbGetQuery(con2, statement = read_file('RESULT.sql'))

View(result)



## PILARES

pilares <- dbGetQuery(con2, statement = read_file('PILARES.sql'))

View(pilares)

pilares %>% 
  filter(MES==11)%>%
   filter(ANO==2023) %>% 
  summarize(v=sum(VRVENDA))


# DESCONTOS

descontos <- dbGetQuery(con2, statement = read_file('DESCONTOS.sql'))

View(descontos)


# CLIEN

cliendesc <- dbGetQuery(con2, statement = read_file('DESCONTO_GERAL.sql'))

View(cliendesc)

