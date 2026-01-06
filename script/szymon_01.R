# paczki
library(dplyr)
library(readxl)
library(readr)

# Wczytywanie z csv
dane <- readr::read_csv(
    "dane/annual-enterprise-survey-2024-financial-year-provisional.csv"
)

# Wczytywanie danych z excela
danexl <- readxl::read_excel("dane/data_msu.xlsx", sheet = "elemental")

# Wylistowanie arkuszy w excelu
readxl::excel_sheets("dane/data_msu.xlsx")

# Wczytaj wszystkie 3 arkusze
# Zdefiniuj ścieżkę
sciezka <- "dane/data_msu.xlsx"

readxl::read_excel(sciezka, sheet = 1)

data_1 <- readxl::read_excel("dane/data_msu.xlsx", sheet = 1)

data_2 <- read_excel("dane/data_msu.xlsx", sheet = 2)

data_3 <- readxl::read_excel("dane/data_msu.xlsx", sheet = 3)


dplyr::left_join(suffix = )

tidyr::drop_na()
pak::pkg_install(unname(old.packages()[, "Package"]))
