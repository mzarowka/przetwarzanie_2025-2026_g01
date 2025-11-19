# Ładowanie paczek
library("tidyverse")

# Ładowanie danych, które są w R
iris <- iris

# Średnia długość płatka (petal.len)
srednia_platka <- mean(iris$Petal.Length)

srednia_platka

# Mediana z szerokości sepal (odwołanie do pozycji)
mediana_szerokosci <- median(iris[, 2])

mediana_szerokosci

# Srednie dla gatunków ----
# Srednia dlugosc platka setosa
platek_setosa <- mean(iris[1:50, 3])

platek_setosa

platek_setosa2 <- mean(iris[iris$Species == "setosa", 3])

platek_setosa2

platek_setosa == platek_setosa2

platek_setosa3 <- mean(iris[ c("tutaj-pozycje-wierszy"), 3])

# Podsumowanie danych ----
summary(iris)

# Nowa kolumna - wynik działania
iris2 <- iris

iris2$nowa_kolumna <- iris2$Sepal.Length + iris$Sepal.Width

iris2$nowa_kolumna

# Początek z dplyr ----
# Funkcja select - wybieranie kolumn

# Wybieranie za pomocą nazwy - jedna kolumna
dplyr::select(iris, Species)

# Wybieranie za pomocą nazwy - więcej kolumn
dplyr::select(iris, c(Sepal.Length, Petal.Length, Species))

# Wybieranie za pomocą nazwy - więcej kolumn
dplyr::select(iris, Sepal.Length, Petal.Length, Species)

# Wybieranie za pomocą nazwy - wszystkie kolumny - zamiana miejsc
dplyr::select(iris, Species, Petal.Width, Petal.Length, Sepal.Length, Sepal.Width)

# Wybieranie za pomocą nazwy - wszystkie kolumny - zamiana miejsc
dplyr::select(iris, Species, Petal.Width, Petal.Length, Sepal.Length, Sepal.Width, Species)

# Wybieranie "tego czego nie chcemy" - negatywne
dplyr::select(iris, -Species)

# Wybór wszystkiego co dotyczy "Petal"
dplyr::select(iris, dplyr::contains(match = "Petal"))

# Zawiera kropkę w nazwie
dplyr::select(iris, dplyr::contains("."))

# Zaczyna się na "Pet"
dplyr::select(iris, dplyr::starts_with("Pet"))

# Kończy się na "dth"
dplyr::select(iris, dplyr::ends_with("dth"))

# Zaczyna się na "Sep" i kończy się na "dth"
dplyr::select(iris, dplyr::starts_with("Sep"), dplyr::ends_with("dth"))

dplyr::select(iris, dplyr::starts_with("Sep") & dplyr::ends_with("dth"))

dplyr::select(iris, dplyr::starts_with("Sep") | dplyr::ends_with("dth"))

# Zanegowanie po tekście - wszystko co nie jest Petal
dplyr::select(iris, -dplyr::contains("Petal"))

dplyr::select(iris, !dplyr::contains("Petal"))
