library(tidyverse)
library(here)
library(usethis)

colonnes =    c("catalog_number",
                "catalog_plate",
                 "year",
                 "month",
                 "day",
                 "time_greatest_eclipse",
                 "delta_t",
                 "luna_number",
                 "saros_number",
                 "eclipse_type",
                 "QLE",
                 "gamma",
                 "magnitude",
                 "latitude",
                 "longitude",
                 "sun_altitude",
                 "sun_azimuth",
                 "path_width_km",
                 "central_duration")
eclipse <- read_fwf(here("data-raw","5MKSEcatalog.txt"), skip = 10, col_types = "iii?i?iiiccddcciiic")
colnames(eclipse) <- colonnes
eclipse <- eclipse %>%
  mutate(
    type = case_when(
      str_detect(eclipse_type, "A") ~ "Éclipse annulaire",
      str_detect(eclipse_type, "P") ~ "Éclipse partielle",
      str_detect(eclipse_type, "T") ~ "Éclipse totale",
      str_detect(eclipse_type, "H") ~ "Éclipse hybride",
    )) %>%
  mutate(
    month_number = case_when(
      month == "Jan" ~ 1,
      month == "Feb" ~ 2,
      month == "Mar" ~ 3,
      month == "Apr" ~ 4,
      month == "May" ~ 5,
      month == "Jun" ~ 6,
      month == "Jul" ~ 7,
      month == "Aug" ~ 8,
      month == "Sep" ~ 9,
      month == "Oct" ~ 10,
      month == "Nov" ~ 11,
      month == "Dec" ~ 12,
    )
  ) %>%
  mutate(
    date = make_date(year = year, month = month_number, day = day)
  ) %>%
  mutate(
    month = case_when(
      month == "Jan" ~ "Janvier",
      month == "Feb" ~ "Février",
      month == "Mar" ~ "Mars",
      month == "Apr" ~ "Avril",
      month == "May" ~ "Mai",
      month == "Jun" ~ "Juin",
      month == "Jul" ~ "Juillet",
      month == "Aug" ~ "Août",
      month == "Sep" ~ "Septembre",
      month == "Oct" ~ "Octobre",
      month == "Nov" ~ "Novembre",
      month == "Dec" ~ "Décembre",
    )
  ) %>%
  rename(mois = month)
eclipse$mois <- factor(eclipse$mois, levels = c("Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"))
save(eclipse, file = here("data","eclipse.RData"))

