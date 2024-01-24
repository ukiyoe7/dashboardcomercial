
library(DBI)
library(dplyr)
library(readr)
library(lubridate)

con2 <- dbConnect(odbc::odbc(), "repro",encoding="Latin1")


## RESULT ==============================================


result <- dbGetQuery(con2, statement = read_file('SQL/RESULT.sql'))

View(result)

result %>% group_by(ANO,MES) %>% tally() %>% View()


result2 <- dbGetQuery(con2, statement = read_file('SQL/RESULT2.sql'))

View(result2)

result %>% group_by(ANO,MES) %>% tally() %>% View()




## PILARES ===============================================


pilares <- dbGetQuery(con2, statement = read_file('SQL/PILARES.sql'))

View(pilares)

pilares %>% 
  filter(MES==11)%>%
   filter(ANO==2023) %>% 
  summarize(v=sum(VRVENDA))


# DESCONTOS =================================


descontos <- dbGetQuery(con2, statement = read_file('SQL/DESCONTOS.sql'))

View(descontos)


# CLIEN =======================================


cliendesc <- dbGetQuery(con2, statement = read_file('SQL/DESCONTO_GERAL.sql'))

View(cliendesc)



# VLXESPECIALISTA ====================================


vlx_esp <- dbGetQuery(con2, statement = read_file('SQL/VLX_ESPECIAL.sql'))

View(vlx_esp)

# STATUSCLI ==============================================


statuscli <- dbGetQuery(con2, statement = read_file('SQL/STATUSCLI.sql'))

View(statuscli)


# BLOQUEIO ======================================================


bloqueio <- dbGetQuery(con2, statement = read_file('SQL/BLOQUEIO.sql'))

View(bloqueio)


bloqueio2 <- dbGetQuery(con2, statement = read_file('SQL/BLOQUEIO2.sql'))

View(bloqueio2)


contasareceber <- dbGetQuery(con2, statement = read_file('SQL/REL_399_CONTASARECEBER.sql'))

View(contasareceber)



# PACOTES ====================================================================

pacotes <- dbGetQuery(con2, statement = read_file('SQL/PACOTES.sql'))

View(pacotes)


write.csv2(pacotes,file = "C:\\Users\\REPRO SANDRO\\Documents\\R\\DASHBOARD_COMERCIAL\\BASES\\pacotes.csv",row.names = FALSE,na="")


# ANALISE DESCTOS MCLIENTE =====================================================


acordos_mclientes <- dbGetQuery(con2, statement = read_file('SQL/ANALISE_ACORDOS_MCLIENTES.sql'))

View(acordos_mclientes)


acordos_mclientes2 <- dbGetQuery(con2, statement = read_file('SQL/ANALISE_ACORDOS_MCLIENTES_2.sql'))

View(acordos_mclientes2)


acordos_mclientes3 <- 
inner_join(acordos_mclientes,acordos_mclientes2,by="TBPCODIGO")

View(acordos_mclientes3)

write.csv2(acordos_mclientes3,file = "C:\\Users\\REPRO SANDRO\\Documents\\R\\DASHBOARD_COMERCIAL\\BASES\\acordos_mclientes.csv",row.names = FALSE,na="")


dbGetQuery(con2,"SELECT * FROM CLITBP WHERE TBPCODIGO=307") %>% 
  inner_join(.,acordos_mclientes2,by="TBPCODIGO") %>% 
write.csv2(.,file = "C:\\Users\\REPRO SANDRO\\Documents\\R\\DASHBOARD_COMERCIAL\\BASES\\acordos_mclientes_relrepro.csv",row.names = FALSE,na="")

