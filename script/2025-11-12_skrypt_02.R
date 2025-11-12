# Ladowanie paczek na początku skryptu
library(tidyverse)

# Ładowanie pliku z www
nowa_zelandia <- readr::read_csv("https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2024-financial-year-provisional/Download-data/annual-enterprise-survey-2024-financial-year-provisional.csv")

str(nowa_zelandia)

# Wczytywanie z dysku
nowa_zelandia2 <- readr::read_csv("dane/annual-enterprise-survey-2024-financial-year-provisional.csv")

# Scieżka bezwzględna do tego samego pliku
"C:/GitHub/teaching/przetwarzanie_2025-2026_g01/dane/annual-enterprise-survey-2024-financial-year-provisional.csv"

# Indeksowanie i operacje różne ----
# Wybór kolumny danych

nowa_zelandia2

# Wybór kolumny z rokiem

# To skutkuje wyborem ramki danych
nowa_zelandia2[1]

# To skutkuje wyborem ramki danych
nowa_zelandia2["Year"]

# Wybór kolumny - wszystkie wiersze
nowa_zelandia2[, 1]

nowa_zelandia2[, "Year"]

# Wybór kolumny - wszystkie wiersze, kolumna 1 i 3
nowa_zelandia2[, c(1, 3)]

# Wybór wierszy 2 do 100 - wszyskie kolumny
nowa_zelandia2[2:100, ]

# Wybór jednej konkretnej kolumny
nowa_zelandia2$Value

# Wybór jednej wartości z jednej kolumny
nowa_zelandia2[5, 10]

# Wybór jednej wartości z jednej kolumny z $
nowa_zelandia2$Year[30]

# Zamiana kolumny Value z chr na num
# To nie zadziała bo [] zwraca tibble - potrzebny jest wektor
as.numeric(nowa_zelandia2[, 9])

# To powinno zadziałać - zwraca wektor
as.numeric(nowa_zelandia2$Value)

# Nowa ramka danych na podstawie nowa zelandia
nowa_zelandia3 <- nowa_zelandia

# W ramce danych dokonaj zamiany wartości Value z chr na num
nowa_zelandia3$Value <- as.numeric(nowa_zelandia3$Value)

mean(nowa_zelandia3$Value, na.rm = TRUE)

# Tworzenie nowej kolumny dodaj Year do Value
nowa_zelandia3$suma <- nowa_zelandia3$Year + nowa_zelandia3$Value

# Nowa kolumna logarytm z roku
nowa_zelandia3$logarytm <- log(nowa_zelandia3$Year)

# Usuwanie obiektów
rm(tutaj_nazwa)

# Nowa ramka danych na podstawie nowa_zelandia3 bez dziwnych kolumn
nowa_zelandia4 <- nowa_zelandia3[, 1:10]
# Alternatywne opcje
nowa_zelandia3[, c(1, 2, ...)]

nowa_zelandia3[, c("Year", "Value", ...)]
