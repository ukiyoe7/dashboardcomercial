

## TIME INTEL

library(DBI)
library(dplyr)
library(readr)

con2 <- dbConnect(odbc::odbc(), "repro",encoding="Latin1")




peddt <- 
  dbGetQuery(con2,"
           SELECT DISTINCT CAST(PEDDTEMIS AS DATE)
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             DATEADD(MONTH, -5, CURRENT_DATE - EXTRACT(DAY FROM CURRENT_DATE) + 1) AND
                                 ' YESTERDAY' OR  PEDDTEMIS BETWEEN DATEADD(MONTH, -5,DATEADD(YEAR, -1, CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 1) AND DATEADD(YEAR, -1, CURRENT_DATE)") 

View(peddt)






dbGetQuery(con2,"
           SELECT PEDDTEMIS
                      FROM PEDID WHERE
(PEDDTEMIS BETWEEN (CURRENT_DATE-1) - EXTRACT(DAY FROM (CURRENT_DATE-1)) + 1 AND 'TODAY' OR
  PEDDTEMIS BETWEEN DATEADD(-1 YEAR TO (CURRENT_DATE-1) - EXTRACT(DAY FROM CURRENT_DATE-1) + 1)
  AND DATEADD(-1 YEAR TO (CURRENT_DATE-1) - EXTRACT(DAY FROM CURRENT_DATE-1) + 32 - 
                EXTRACT(DAY FROM (CURRENT_DATE-1) - EXTRACT(DAY FROM (CURRENT_DATE-1)) + 32)))") %>% 
  distinct (PEDDTEMIS) %>% 
  View()





dbGetQuery(con2,"
           SELECT PEDDTBAIXA
                      FROM PEDID WHERE
                       (PEDDTBAIXA BETWEEN 
                               CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE) AND
                                  'YESTERDAY' 
                                  OR
                      PEDDTBAIXA BETWEEN 
                                  DATEADD(YEAR, -1, CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE)) AND
                                  DATEADD(YEAR, -1, CURRENT_DATE-1)
                                  )") %>% View()


## YTD YESTERDAY
dbGetQuery(con2,"
           SELECT DISTINCT PEDDTEMIS
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE) AND
                                  'YESTERDAY'") %>% View()


## YTD LAST MONTH
dbGetQuery(con2,"
           SELECT DISTINCT PEDDTEMIS
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE) AND
                                  DATEADD(DAY, -EXTRACT(DAY FROM CURRENT_DATE), CURRENT_DATE)") %>% View()


## LAST MONTH
dbGetQuery(con2,"
           SELECT DISTINCT PEDDTEMIS
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             DATEADD(MONTH, -1, CURRENT_DATE - EXTRACT(DAY FROM CURRENT_DATE) + 1) AND
                                  DATEADD(DAY, -EXTRACT(DAY FROM CURRENT_DATE), CURRENT_DATE)") %>% View()


## LAST MONTH LAST YEAR
dbGetQuery(con2,"
           SELECT DISTINCT PEDDTEMIS
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             DATEADD(MONTH, -1,DATEADD(YEAR, -1, CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 1) AND
  DATEADD(YEAR, -1, DATEADD(DAY, -EXTRACT(DAY FROM CURRENT_DATE), CURRENT_DATE))") %>% View()



## YTD LAST YEAR LAST MONTH
dbGetQuery(con2,"
           SELECT DISTINCT PEDDTEMIS
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             DATEADD(YEAR, -1, CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE)) AND
                                  DATEADD(YEAR, -1,DATEADD(DAY, -EXTRACT(DAY FROM CURRENT_DATE), CURRENT_DATE))") %>% View()



## YTD LAST YEAR CURRENT MONTH YESTERDAY
dbGetQuery(con2,"
           SELECT DISTINCT PEDDTEMIS
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             DATEADD(YEAR, -1, CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE)) AND
                                  DATEADD(YEAR, -1, CURRENT_DATE-1)") %>% View()




