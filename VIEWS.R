
library(DBI)
library(dplyr)
library(readr)
library(lubridate)

con2 <- dbConnect(odbc::odbc(), "repro",encoding="Latin1")


## RESULT

result <- dbGetQuery(con2, statement = read_file('SQL/RESULT.sql'))

View(result)

result %>% group_by(ANO,MES) %>% tally() %>% View()

## PILARES

pilares <- dbGetQuery(con2, statement = read_file('PILARES.sql'))

View(pilares)

pilares %>% 
  filter(MES==11)%>%
   filter(ANO==2023) %>% 
  summarize(v=sum(VRVENDA))


# DESCONTOS

descontos <- dbGetQuery(con2, statement = read_file('SQL/DESCONTOS.sql'))

View(descontos)


# CLIEN

cliendesc <- dbGetQuery(con2, statement = read_file('DESCONTO_GERAL.sql'))

View(cliendesc)

# VLXESPECIALISTA


vlx_esp <- dbGetQuery(con2, statement = read_file('SQL/VLX_ESPECIAL.sql'))

View(vlx_esp)

# PACOTES

pacotes <- dbGetQuery(con2, statement = read_file('SQL/PACOTES.sql'))

View(pacotes)

