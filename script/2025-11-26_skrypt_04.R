# Załduj paczki
library(tidyverse)

# Załaduj dane
iris <- iris

# Wybór kolumny, ktora zaczyna się na Petal i zawiera "dth"
dplyr::select(iris, dplyr::starts_with("Petal") & dplyr::contains("dth"))

# 
dplyr::select(iris, dplyr::starts_with("Petal") | dplyr::contains("dth"))

# Star Wars
swars <- dplyr::starwars

# Wybór kolumny numerycznej z użyciem funkcji
dplyr::select(swars, dplyr::where(\(kolumna) is.numeric(kolumna)))

# Wybór kolumny tekstowej z "r" w nazwie
dplyr::select(swars, dplyr::where(\(kolumna) is.character(kolumna)) & dplyr::contains("r"))

# Wybór kolumny numerycznej, której średnia jest wyższa niż 100
dplyr::select(swars, dplyr::where(\(kolumna1) is.numeric(kolumna1) & mean(kolumna1, na.rm = TRUE) > 100))

# Wybór kolumny, która 1) nazwa zawiera literę "r" 2) jest kolumną numeryczną i 3) jej średnia pomiędzy 1 i 10
dplyr::select(swars,dplyr::contains("r") & dplyr::where(\(x) is.numeric(x) & mean(x, na.rm = TRUE) > 70 & mean(x, na.rm = TRUE) < 90))

# To nie zadziała, bo sprawdzi kolumny tekstowe
dplyr::select(swars,dplyr::contains("r") & dplyr::where(\(x) mean(x, na.rm = TRUE) > 70 & mean(x, na.rm = TRUE) < 90))

# Wybór wierszy
# dplyr::filter()

# Filtrowanie przez spełnienie jednego, prostego warunku - wzrost równy 182 cm
dplyr::filter(swars, height == 182)

# Filtrowanie przez spełnienie jednego warunku - wzrost wyższy niż 70 cm
dplyr::filter(swars, height > 70)

# Sprawdź wzrost mniejszy lub równy 70 cm
dplyr::filter(swars, height <= 70)

# Sprawdź wzrost, gdzie jest poniżej 70 lub powyżej 200
dplyr::filter(swars, height < 70 | height > 200)

