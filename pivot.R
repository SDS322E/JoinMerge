################################################################################
## pivot_wider() and pivot_longer() demo
library(tidyverse)

## Download the MAAIT data
maait <- read_csv("https://raw.githubusercontent.com/rdpeng/stat322E_public/main/data/maait.csv")
maait

## Quick look
glimpse(maait)

## Select 4 variables
maait |>
    select(ID, VisitNum,
           sxsgeneral, group)

## Pivot to a wider data frame with one column per visit
maait |>
    select(ID, VisitNum,
           sxsgeneral, group) |>
    pivot_wider(names_from = "VisitNum",
                values_from = "sxsgeneral")

## Add a prefix to the column names after pivoting wider
maait |>
    select(ID, VisitNum,
           sxsgeneral, group) |>
    pivot_wider(names_from = "VisitNum",
                names_prefix = "symptom_visit",
                values_from = "sxsgeneral")

## Store the wide version of the data frame in an object named 'widedat'
widedat <- maait |>
    select(ID, VisitNum,
           sxsgeneral, group) |>
    pivot_wider(names_from = "VisitNum",
                names_prefix = "symptom_visit",
                values_from = "sxsgeneral")
widedat

## Pivot the wide data frame back into a long version w/one row per visit
widedat |>
    pivot_longer(cols = symptom_visit0:symptom_visit4,
                 names_to = "VisitNum",
                 values_to = "symptoms")

## Strip the prefix text from the 'VisitNum' column
widedat |>
    pivot_longer(cols = symptom_visit0:symptom_visit4,
                 names_to = "VisitNum",
                 names_prefix = "symptom_visit",
                 values_to = "symptoms") |>
    mutate(VisitNum = as.numeric(VisitNum))






