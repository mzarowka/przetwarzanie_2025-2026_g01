# Paczki
library(dplyr)

# 15.01.25

# Paczki
library(tidyverse)

# Wczytanie danych
data_1 <- readxl::read_excel("R/data/data_msu.xlsx", sheet = "loi")

data_2 <- readxl::read_excel("R/data/data_msu.xlsx", sheet = "elemental")

data_3 <- readxl::read_excel("R/data/data_msu.xlsx", sheet = "bsi")

# Wylistowanie dostępnych arkuszy w pliku excel
readxl::excel_sheets("R/data/data_msu.xlsx")

# Łączenie ramek (mutating join)
# Left join
dane_left_1 <- dplyr::left_join(x = data_1, y = data_2)

dane_left_2 <- dplyr::left_join(x = data_1, y = data_3)

dane_left_3 <- dplyr::left_join(
  x = data_1,
  y = data_3,
  by = dplyr::join_by(sample.id == sample.id)
)

dane_left_4 <- dplyr::left_join(
  dplyr::select(data_1, -mass.mg),
  dplyr::rename(data_3, nazwa.id = sample.id),
  by = dplyr::join_by(sample.id == nazwa.id)
)

data_left_5 <- dplyr::left_join(
  data_1,
  data_2,
  by = dplyr::join_by(sample.id)
) |>
  dplyr::left_join(x = _, y = data_3, by = dplyr::join_by(sample.id))

# Łączenie do prawej ramki
data_right_1 <- dplyr::right_join(x = data_1, y = data_2)

data_right_2 <- dplyr::right_join(
  data_3,
  data_1,
  by = dplyr::join_by(sample.id)
) |>
  dplyr::right_join(data_2, by = dplyr::join_by(sample.id))

# Łączenie wszystkiego - inner
data_inner_1 <- dplyr::inner_join(x = data_1, y = data_2)

# Szalone nutki
data_szalone <- dplyr::inner_join(
  data_1,
  data_3,
  by = dplyr::join_by(sample.id)
) |>
  dplyr::right_join(data_right_1)

# Łączenie wszystkiego - full join
data_full_1 <- dplyr::full_join(data_1, data_2)

# Semi join
data_semi_1 <- dplyr::semi_join(data_1, data_2)

# Anti join
data_anti_1 <- dplyr::anti_join(data_3, data_1)


############################################################
# Tytuł: dplyr joins & operacje zbiorów
# Autor: Maurycy Żarczyński
# Data: 2026-01-07
############################################################

# ──────────────────────────────────────────────────────────
# 1) Przygotowanie: pakiety + import danych
# ──────────────────────────────────────────────────────────

# tidyverse (w tym dplyr) + readxl do plików Excel
library(tidyverse)
library(readxl)

# Ustal ścieżkę do pliku
excel_path <- "dane/data_msu.xlsx"

# Podgląd dostępnych arkuszy (pomocne na żywo)
# Oczekiwane arkusze: "loi", "elemental", "bsi"
readxl::excel_sheets(excel_path)


# Wczytanie ramek danych
# Dane LOI, straty na prazeniu
loi <- readxl::read_excel(excel_path, sheet = "loi")

# Dane elementarne CNS
elemental <- readxl::read_excel(excel_path, sheet = "elemental")

# Dane krzemionka biogeniczna
bsi <- readxl::read_excel(excel_path, sheet = "bsi")

# Sprawdźmy nazwy kolumn i upewnijmy się, że mamy wspólny klucz 'sample_id'
names(loi)
names(elemental)
names(bsi)

# Szybki test duplikatów klucza (ważne dla przewidywanego wyniku joinów)
loi |>
  dplyr::count(sample_id) |>
  dplyr::filter(n > 1)

elemental |>
  dplyr::count(sample_id) |>
  dplyr::filter(n > 1)

bsi |>
  dplyr::count(sample_id) |>
  dplyr::filter(n > 1)

# ──────────────────────────────────────────────────────────
# 2) Mentalny model joinów
# ──────────────────────────────────────────────────────────
# Dwa zbiory ID: X (lewa tabela) i Y (prawa tabela)
#
# dplyr::left_join(X, Y):   zachowuje wszystkie wiersze z X; dołącza kolumny z Y
#                   dla pasujących kluczy; brak dopasowań -> NA po stronie Y
# dplyr::right_join(X, Y):  zachowuje wszystkie wiersze z Y; dołącza kolumny z X
# dplyr::inner_join(X, Y):  tylko część wspólna (X ∩ Y)
# dplyr::full_join(X, Y):   wszystko (X ∪ Y), z NA tam, gdzie brak dopasowania
# dplyr::semi_join(X, Y):   filtruje X do wierszy mających dopasowanie w Y (tylko kolumny X)
# dplyr::anti_join(X, Y):   filtruje X do wierszy bez dopasowania w Y (tylko kolumny X)

# ──────────────────────────────────────────────────────────
# 3) Joiny mutujące (dodają kolumny)
# ──────────────────────────────────────────────────────────

# --- LEFT JOIN ---
# Dla dorosłych: Zwraca wszystkie wiersze z lewego wejścia; dla kluczy z dopasowaniem
#                dokleja kolumny z prawego. Braki po prawej -> NA.
# ELI5:          Lewa tabela to lista główna; dla każdego ID szukamy w prawej.
#                Jest? Dopisujemy szczegóły. Nie ma? Zostawiamy puste (NA).
left_loi_elemental <- dplyr::left_join(
  loi,
  elemental,
  by = dplyr::join_by(sample_id)
)

# Podgląd
dplyr::glimpse(left_loi_elemental)

# Łańcuch kilku left_join i zarządzanie nakładającymi się nazwami (sufiksy):
left_all <- loi |>
  dplyr::left_join(elemental, by = dplyr::join_by(sample_id)) |>
  dplyr::left_join(bsi, by = dplyr::join_by(sample_id), suffix = c("", ".bsi"))

# Uwaga: 'mass_mg' występuje w 'loi' i 'bsi'. Sufiks '.bsi' odróżnia kolumnę z prawej.

# --- RIGHT JOIN ---
# Dla dorosłych: Zwraca wszystkie wiersze z prawego wejścia; wzbogaca o kolumny z lewego.
# ELI5:          Prawa tabela jest „listą nadrzędną”; dociągamy z lewej dane dla pasujących ID.
right_loi_elemental <- dplyr::right_join(
  loi,
  elemental,
  by = dplyr::join_by(sample_id)
)
dplyr::glimpse(right_loi_elemental)

# --- INNER JOIN ---
# Dla dorosłych: Przecięcie — tylko wiersze, których klucze istnieją w obu wejściach; bez nowych NA.
# ELI5:          Zostają tylko te ID, które oba zbiory mają wspólne.
inner_loi_elemental <- dplyr::inner_join(
  loi,
  elemental,
  by = dplyr::join_by(sample_id)
)

# Podgląd
dplyr::glimpse(inner_loi_elemental)

# Kombinacja: najpierw inner, potem right (na bazie Twojego przykładu)
inner_loi_bsi_then_right <- dplyr::inner_join(
  loi,
  bsi,
  by = dplyr::join_by(sample_id)
) |>
  dplyr::right_join(elemental, by = dplyr::join_by(sample_id))

# Podgląd
dplyr::glimpse(inner_loi_bsi_then_right)

# --- FULL JOIN ---
# Dla dorosłych: Suma zbiorów kluczy — zachowuje wszystkie wiersze z obu tabel; braki uzupełnia NA.
# ELI5:          Sklejamy obie listy tak, aby nikt „nie wypadł”; puste pola wstawiamy jako NA.
full_loi_elemental <- dplyr::full_join(
  loi,
  elemental,
  by = dplyr::join_by(sample_id)
)

# Podgląd
dplyr::glimpse(full_loi_elemental)

# ──────────────────────────────────────────────────────────
# 4) Joiny filtrujące (nie dodają kolumn — tylko filtrują wiersze)
# ──────────────────────────────────────────────────────────

# --- SEMI JOIN ---
# Dla dorosłych: Zwraca wiersze z X, których klucze mają co najmniej jedno dopasowanie w Y.
#                Zwraca kolumny tylko z X.
# ELI5:          Z lewej tabeli zostaw te wiersze, których ID występują w prawej.
semi_loi_in_elemental <- dplyr::semi_join(
  loi,
  elemental,
  by = dplyr::join_by(sample_id)
)

# Podgląd
dplyr::glimpse(semi_loi_in_elemental)

# --- ANTI JOIN ---
# Dla dorosłych: Zwraca wiersze z X, których klucze NIE mają dopasowania w Y.
#                Zwraca kolumny tylko z X.
# ELI5:          Z lewej tabeli zostaw te wiersze, których ID nie występują w prawej.
anti_bsi_not_in_loi <- dplyr::anti_join(
  bsi,
  loi,
  by = dplyr::join_by(sample_id)
)

# Podgląd
dplyr::glimpse(anti_bsi_not_in_loi)

# ──────────────────────────────────────────────────────────
# 5) Operacje zbiorów (na kluczach) vs. joiny filtrujące
# ──────────────────────────────────────────────────────────
# Myśl: operacje zbiorów liczą relacje między zbiorami ID; joiny filtrujące
# działają na całych wierszach X, bazując na obecności/nieobecności kluczy w Y.

# Zbuduj wektory ID dla przejrzystości
ids_loi <- loi$sample_id
ids_elemental <- elemental$sample_id
ids_bsi <- bsi$sample_id

# UNION: wszystkie unikalne ID z obu zbiorów (jak klucze full join)
ids_union <- dplyr::union(ids_loi, ids_elemental) # unikalna suma
ids_union_all <- dplyr::union_all(ids_loi, ids_elemental) # zachowuje duplikaty, jeśli były
length(ids_union)
length(ids_union_all)

# INTERSECT: ID wspólne (jak klucze inner join)
ids_intersect <- dplyr::intersect(ids_loi, ids_elemental)

# SETDIFF: ID w A, których nie ma w B (jak klucze anti join)
ids_only_in_loi <- dplyr::setdiff(ids_loi, ids_elemental)

# Porównanie z joinami filtrującymi:
# dplyr::semi_join(loi, elemental) -> wiersze 'loi' z ID obecnym w 'elemental' (≈ intersect na wierszach)
# dplyr::anti_join(loi, elemental) -> wiersze 'loi' z ID NIEobecnym w 'elemental' (≈ setdiff na wierszach)

# ──────────────────────────────────────────────────────────
# 6) Różne nazwy klucza & selekcja kolumn
# ──────────────────────────────────────────────────────────

# Przykład: chcemy pominąć 'mass_mg' z 'loi' i pokazać join na różnych nazwach kluczy.
loi_no_mass <- dplyr::select(loi, -mass_mg)

# Zmieniamy nazwę klucza w 'bsi', aby zademonstrować join_by z równaniem różnych nazw:
bsi_renamed <- bsi |> dplyr::rename(sample_code = sample_id)

# Łączenie po różnych nazwach kluczy:
left_loi_bsi_renamed <- dplyr::left_join(
  loi_no_mass,
  bsi_renamed,
  by = dplyr::join_by(sample_id == sample_code),
  suffix = c("", ".bsi")
)
dplyr::glimpse(left_loi_bsi_renamed)

# ──────────────────────────────────────────────────────────
# 7) Diagnozy & dobre praktyki
# ──────────────────────────────────────────────────────────

# i) Sprawdź typy i unikalność kluczy
loi |> dplyr::summarize(n_keys = dplyr::n_distinct(sample_id))
elemental |> dplyr::summarize(n_keys = dplyr::n_distinct(sample_id))
bsi |> dplyr::summarize(n_keys = dplyr::n_distinct(sample_id))

# ii) Porównaj liczby wierszy — zrozumiesz, co robi każdy join
dplyr::tibble(
  rows_loi = nrow(loi),
  rows_elemental = nrow(elemental),
  rows_bsi = nrow(bsi),
  rows_left = nrow(left_loi_elemental),
  rows_right = nrow(right_loi_elemental),
  rows_inner = nrow(inner_loi_elemental),
  rows_full = nrow(full_loi_elemental),
  rows_semi = nrow(semi_loi_in_elemental),
  rows_anti = nrow(anti_bsi_not_in_loi)
)

# iii) Radzenie sobie z nakładającymi się nazwami kolumn: 'suffix', albo pre‑select/rename.

# iv) Szybki przegląd NA po joinie
left_loi_elemental |> 
  dplyr::summarize(dplyr::across(dplyr::everything(), ~ sum(is.na(.))))
# Omów czy braki są spodziewane (np. nie każdy próbkowany dla każdej metody),
# i jak podejść do imputacji vs. filtrowania.

# ──────────────────────────────────────────────────────────
# 8) Mini‑zadania (do live codingu)
# ──────────────────────────────────────────────────────────

# A) Weź 'elemental' jako listę referencyjną; wzbogac ją o 'om_p' z 'loi' i 'bsi_p' z 'bsi'.
#    Zachowaj obie kolumny 'mass_mg' (z sufiksami).
exercise_A <- elemental |>
  dplyr::left_join(
    dplyr::select(loi, sample_id, om_p, mass_mg),
    by = dplyr::join_by(sample_id)
  ) |>
  dplyr::left_join(
    dplyr::select(bsi, sample_id, bsi_p, mass_mg),
    by = dplyr::join_by(sample_id),
    suffix = c("", ".bsi")
  )
dplyr::glimpse(exercise_A)

# B) Próbki obecne w 'bsi', a nieobecne w 'loi' (dwa sposoby):
exercise_B1 <- dplyr::anti_join(bsi, loi, by = dplyr::join_by(sample_id)) # join filtrujący
exercise_B2 <- lubridate::setdiff(bsi$sample_id, loi$sample_id) # operacja zbioru na kluczach

# C) „Ścisła część wspólna”: próbki zmierzone we WSZYSTKICH trzech metodach
overlap_ids <- Reduce(
  intersect,
  list(loi$sample_id, elemental$sample_id, bsi$sample_id)
)
exercise_C <- loi |>
  dplyr::filter(sample_id %in% overlap_ids) |>
  dplyr::inner_join(elemental, by = dplyr::join_by(sample_id)) |>
  dplyr::inner_join(bsi, by = dplyr::join_by(sample_id), suffix = c("", ".bsi"))

# D) Bonus: pokaz zarządzania sufiksami, gdy występuje więcej niż jedna wspólna kolumna
exercise_D <- dplyr::full_join(
  loi,
  bsi,
  by = dplyr::join_by(sample_id),
  suffix = c(".loi", ".bsi")
)

# ──────────────────────────────────────────────────────────
# 9) Błyskawiczna ściąga (komentarze do każdego joinu)
# ──────────────────────────────────────────────────────────
# dplyr::left_join(X,Y):   Dla dorosłych → wszystkie z X + dopasowane z Y; braki w Y → NA
#                   ELI5 → zostaw lewą listę; uzupełnij z prawej; puste gdy brak
# dplyr::right_join(X,Y):  Dla dorosłych → wszystkie z Y + dopasowane z X; braki w X → NA
#                   ELI5 → zostaw prawą listę; uzupełnij z lewej; puste gdy brak
# dplyr::inner_join(X,Y):  Dla dorosłych → tylko wspólne klucze (X ∩ Y)
#                   ELI5 → zostają ID, które obie tabele mają
# dplyr::full_join(X,Y):   Dla dorosłych → suma kluczy (X ∪ Y) z NA tam, gdzie brak pary
#                   ELI5 → nikt nie wypada; puste miejsca wstawiamy NA
# dplyr::semi_join(X,Y):   Dla dorosłych → filtr X do kluczy obecnych w Y (tylko kolumny X)
#                   ELI5 → zostaw wiersze z X, które są w Y
# dplyr::anti_join(X,Y):   Dla dorosłych → filtr X do kluczy nieobecnych w Y (tylko kolumny X)
#                   ELI5 → zostaw wiersze z X, których nie ma w Y
# lubridate::intersect(A,B):   wspólne ID
# lubridate::union(A,B):       ID w którymkolwiek zbiorze (unikalne); union_all zachowuje duplikaty
# lubridate::setdiff(A,B):     ID występujące w A, których nie ma w B
