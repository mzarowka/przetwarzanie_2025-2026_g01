# Paczki
library(tidyverse)

# Operacje na kolumnach ----
# dplyr::mutate()
nieloty <- penguins

# Podzielenie kolumny przez kolumnę
# Podejście klasyczne
# bill_len podzielić przez bill_dep
nieloty$bill_len / nieloty$bill_dep # użycie dolara

nieloty[, 3] / nieloty[, 4] # indeksowanie przez pozycję []

# Przypisać wynik dzielenia do nowej kolumny w nielotach, kolumna "dzielenie"
nieloty$dzielenie <- nieloty$bill_len / nieloty$bill_dep

# Przypisać wynik dzielenia do nowej kolumny z użyciem dplyr::mutate() - "dzielenie_2"
nieloty <- dplyr::mutate(nieloty, dzielenie_2 = bill_len / bill_dep)

# Mutowanie ramki ze wskazaniem pozycji
# nowa kolumna "dodawanie" - dodaj flipper_len do body_mass oraz nowa kolumna "logarytm" - zlogarytmuj bill_dep
nieloty <- dplyr::mutate(nieloty, dodawanie = flipper_len + body_mass, logarytm = log(bill_dep))

# podejrzeć ramkę
head(nieloty)

# Dodaj kolumnę "pierwiastek" policzony z kolumny body_mass, wstawione po kolumnie species
nieloty <- dplyr::mutate(nieloty, pierwiastek = sqrt(body_mass), .after = species)

# Mutowanie ramki poprzez wybór kolumn
# dplyr::across()

# Mutowanie na podstawie nazw i pozycji
# Zlogarytmuj wszystko pomiędzy bill_len i bill_dep oraz body_mass
dplyr::mutate(nieloty, dplyr::across(c(bill_len:bill_dep, body_mass), \(kolumna) log(kolumna)))

# Mutowanie na podstawie cechy kolumny
# Policzy pierwiastek ze wszystkich kolumn numerycznych
dplyr::mutate(nieloty, dplyr::across(dplyr::where(\(x) is.numeric(x)), \(x) sqrt(x)))

# Mutowanie z porzuceniem
# Stwórz kolumnę "logarytm" na podstawie logarytmu z kolumny bill_dep i użyj argumentu .keep = "none"


# Praca domowa - to co wyżej .keep = "used" albo "unused" albo "all"