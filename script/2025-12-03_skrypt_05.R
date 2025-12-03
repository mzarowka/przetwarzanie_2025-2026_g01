# Paczki
library(tidyverse)

# Wczytanie danych star wars
swars <- dplyr::starwars

# Kontynuacja filtrowania wierszy
# Filtrowanie z negacją wzrost > 200 i masa < 100
dplyr::filter(swars, !height > 200 & !mass < 100)

# Filtrowanie pomiędzy
# Wzrost pomiędzy 80 i 120
dplyr::filter(swars, height > 80 & height < 120)

# To samo ale z haczykiem
dplyr::filter(swars, dplyr::between(height, 80, 120))

# Filtrowanie wartości tekstowych
# Kolor postaci - brown i white
dplyr::filter(swars, skin_color == "brown") # Opcja z jedną wartością

# To daje warning - recycling
dplyr::filter(swars, skin_color == c("brown", "white"))

# To działa
dplyr::filter(swars, skin_color %in% c("brown", "white"))

# Zdefiniuj wektor z interesującymi wartościami
kolory <- c("brown", "white")

# Przefiltruj ramkę na podstawie kolory
dplyr::filter(swars, skin_color %in% kolory)

# Zmiana nazwy i przenoszenie kolumn ----
## Zmiana nazwy ----
# dplyr::rename()

# Nowy dataset - pingwiny
pingwiny <- penguins

# Zmiana nazwy jednej kolumny species na gatunek
pingwiny <- dplyr::rename(pingwiny, gatunek = species)

# Zmiana więcej niż jednej kolumny, po polsku: wyspa oraz długość dzioba
pingwiny <- dplyr::rename(pingwiny,
  wyspa = island,
  dlugosc_dzioba = bill_len)

# Zmiana za pomocą funkcji
# dplyr::rename_with()
# Zmiana wszystkich kolumn na pisane wielką literą
pingwiny <- dplyr::rename_with(pingwiny, \(x) toupper(x))

# Zmiana za pomocą funkcji, wybrane kolumny
# Zamień GATUNEK, WYSPA i DLUGOSC_DZIOBA na pisane małą literą
# Zmiana na małą - tolower()
pingwiny <- dplyr::rename_with(pingwiny, \(x) tolower(x), c(GATUNEK, WYSPA, DLUGOSC_DZIOBA))

# Zmiana za pomocą funkcji, wybrane kolumny
# Wybierz według typu - kolumny numeryczne
# Jeszcze raz tolower()
pingwiny <- dplyr::rename_with(pingwiny, \(x) tolower(x), dplyr::where(\(kolumna) is.numeric(kolumna)))

## Przenoszenie kolumny ----
# dplyr::relocate()
# Przenieś dlugosc dzioba na początek
pingwiny <- dplyr::relocate(pingwiny, dlugosc_dzioba, .before = wyspa)

# Przenieś wszystkie kolumny zawierające w nazwie "e" po kolumnie gatunek
pingwiny <- dplyr::relocate(pingwiny, dplyr::contains("e"), .after = gatunek)

# Nazwy kolumn w pingwinach
nazwy <- colnames(pingwiny)

# Nazwy kolumn alfabetycznie
nazwy_ord <- order(nazwy)

dplyr::select(pingwiny, order(colnames(pingwiny)))
