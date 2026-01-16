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


# =============================================================================
# ŁĄCZENIE RAMEK DANYCH W R (dplyr joins)
# Materiały do zajęć z programowania w R
# =============================================================================

# -----------------------------------------------------------------------------
# PRZYGOTOWANIE ŚRODOWISKA
# -----------------------------------------------------------------------------

# Ładowanie pakietów
library(dplyr)
library(readxl)

# -----------------------------------------------------------------------------
# WCZYTANIE DANYCH
# -----------------------------------------------------------------------------

# Wylistowanie dostępnych arkuszy w pliku Excel
# Funkcja excel_sheets() zwraca wektor nazw wszystkich arkuszy
# w pliku .xlsx/.xls. Przydatne gdy nie znamy struktury pliku.
# [ELI5] To jak spis treści w książce - pokazuje jakie "rozdziały" są w pliku.

readxl::excel_sheets("dane/data_msu.xlsx")

# Wczytanie trzech arkuszy jako osobne ramki danych
data_loi <- readxl::read_excel("dane/data_msu.xlsx", sheet = "loi")
data_elem <- readxl::read_excel("dane/data_msu.xlsx", sheet = "elemental")
data_bsi <- readxl::read_excel("dane/data_msu.xlsx", sheet = "bsi")

# Podgląd danych (sprawdźmy co mamy)
head(data_loi)
head(data_elem)
head(data_bsi)

# =============================================================================
# CZĘŚĆ 1: JOINY MUTUJĄCE (MUTATING JOINS)
# =============================================================================

# Joiny mutujące dodają kolumny z jednej ramki do drugiej na
# podstawie dopasowania kluczy. Wynikowa ramka ma więcej kolumn niż wejściowa.
# [ELI5] To jak doklejanie nowych kartek do zeszytu - masz więcej informacji
# o tych samych rzeczach.

# -----------------------------------------------------------------------------
# LEFT JOIN - łączenie do lewej ramki
# -----------------------------------------------------------------------------

# left_join(x, y) zachowuje WSZYSTKIE wiersze z ramki x (lewej)
# i dołącza pasujące kolumny z ramki y. Jeśli w y nie ma dopasowania,
# wstawiane są wartości NA. Kolejność wierszy z x jest zachowana.
# [ELI5] Masz listę uczniów (x) i chcesz dopisać ich oceny (y). Każdy uczeń
# zostaje na liście, nawet jeśli nie ma jeszcze oceny - wtedy wpisujesz "brak".

# Podstawowy left_join - dplyr automatycznie szuka wspólnych kolumn
dane_left_1 <- dplyr::left_join(x = data_loi, y = data_elem)

# Sprawdźmy wymiary - ile wierszy i kolumn?
dim(data_loi)
dim(data_elem)
dim(dane_left_1)

# Left join z inną ramką
dane_left_2 <- dplyr::left_join(x = data_loi, y = data_bsi)

# -----------------------------------------------------------------------------
# Jawne określenie klucza łączenia (join_by)
# -----------------------------------------------------------------------------

# Argument 'by' z funkcją join_by() pozwala explicite określić,
# które kolumny mają być kluczem łączenia. To dobra praktyka - kod jest
# czytelniejszy i nie zależy od automatycznego wykrywania wspólnych nazw.
# [ELI5] To jak powiedzenie: "Łącz kartki po numerze albumu, a nie zgaduj
# po czym je łączyć".

dane_left_3 <- dplyr::left_join(
  x = data_loi,
  y = data_bsi,
  by = dplyr::join_by(sample_id == sample_id)
)

# -----------------------------------------------------------------------------
# Łączenie gdy kolumny mają różne nazwy
# -----------------------------------------------------------------------------

# Gdy kolumna-klucz ma inną nazwę w każdej ramce, używamy składni
# join_by(kolumna_x == kolumna_y). Można też najpierw przemianować kolumnę
# funkcją rename().
# [ELI5] W jednym zeszycie piszesz "Imię", w drugim "Nazwa ucznia" - to to
# samo, tylko inaczej nazwane. Musisz powiedzieć R-owi, że to ta sama rzecz.

# Najpierw przygotujmy ramkę z inną nazwą kolumny
data_bsi_renamed <- dplyr::rename(data_bsi, nazwa_id = sample_id)

# Teraz łączymy z różnymi nazwami kluczy
dane_left_4 <- dplyr::left_join(
  x = data_loi,
  y = data_bsi_renamed,
  by = dplyr::join_by(sample_id == nazwa_id)
)

# -----------------------------------------------------------------------------
# Łączenie wielu ramek (bez użycia pipe)
# -----------------------------------------------------------------------------

# Gdy chcemy połączyć więcej niż dwie ramki, wykonujemy joiny
# sekwencyjnie - wynik pierwszego joina staje się wejściem dla drugiego.
# Bez operatora pipe robimy to przez przypisanie do zmiennych pośrednich.
# [ELI5] Najpierw sklejasz dwie kartki, potem do tej sklejonej doklejasz
# trzecią. Krok po kroku.

# Krok 1: łączymy loi z elem
dane_krok1 <- dplyr::left_join(
  x = data_loi,
  y = data_elem,
  by = dplyr::join_by(sample_id)
)

# Krok 2: do wyniku doklejamy bsi
dane_kompletne <- dplyr::left_join(
  x = dane_krok1,
  y = data_bsi,
  by = dplyr::join_by(sample_id)
)

# Sprawdźmy wynik
dim(dane_kompletne)
names(dane_kompletne)

# -----------------------------------------------------------------------------
# RIGHT JOIN - łączenie do prawej ramki
# -----------------------------------------------------------------------------

# right_join(x, y) to lustrzane odbicie left_join - zachowuje
# WSZYSTKIE wiersze z ramki y (prawej) i dołącza pasujące dane z x.
# W praktyce: right_join(a, b) == left_join(b, a), więc right_join używa
# się rzadziej.
# [ELI5] Teraz lista ocen (y) jest ważniejsza - zostawiasz wszystkie oceny,
# nawet jeśli nie wiesz czyje są. Brakujące imiona = NA.

dane_right_1 <- dplyr::right_join(x = data_loi, y = data_elem)

# Porównaj wymiary z left_join
dim(dane_left_1)
dim(dane_right_1)

# Sekwencyjne right joiny
dane_right_krok1 <- dplyr::right_join(
  x = data_bsi,
  y = data_loi,
  by = dplyr::join_by(sample_id)
)

dane_right_krok2 <- dplyr::right_join(
  x = dane_right_krok1,
  y = data_elem,
  by = dplyr::join_by(sample_id)
)

# -----------------------------------------------------------------------------
# INNER JOIN - tylko wspólne obserwacje
# -----------------------------------------------------------------------------

# inner_join(x, y) zwraca TYLKO te wiersze, które mają dopasowanie
# w OBU ramkach. To najbardziej restrykcyjny join - usuwa wszystkie wiersze
# bez pełnego dopasowania. Liczba wierszy wyniku <= min(nrow(x), nrow(y)).
# [ELI5] Zostawiasz tylko uczniów, którzy są ZARÓWNO na liście obecności
# JAK I mają wystawione oceny. Kto nie ma obu - odpada.

dane_inner_1 <- dplyr::inner_join(x = data_loi, y = data_elem)

# Porównanie liczby wierszy
nrow(data_loi)
nrow(data_elem)
nrow(dane_inner_1)

# Inner join z jawnym kluczem
dane_inner_2 <- dplyr::inner_join(
  x = data_loi,
  y = data_bsi,
  by = dplyr::join_by(sample_id)
)

# -----------------------------------------------------------------------------
# FULL JOIN - wszystko ze wszystkim
# -----------------------------------------------------------------------------

# full_join(x, y) zachowuje WSZYSTKIE wiersze z OBU ramek.
# Gdzie nie ma dopasowania - wstawia NA. To najbardziej "zachowawczy" join,
# nie traci żadnych danych. Liczba wierszy wyniku >= max(nrow(x), nrow(y)).
# [ELI5] Robisz jedną wielką listę - wszyscy uczniowie i wszystkie oceny.
# Nie wiesz czyja ocena? Wpisujesz NA przy imieniu. Nie ma oceny? NA przy ocenie.

dane_full_1 <- dplyr::full_join(x = data_loi, y = data_elem)

# Porównanie liczby wierszy
nrow(data_loi)
nrow(data_elem)
nrow(dane_full_1)

dane_full_2 <- dplyr::full_join(
  x = data_loi,
  y = data_bsi,
  by = dplyr::join_by(sample_id)
)

# =============================================================================
# CZĘŚĆ 2: JOINY FILTRUJĄCE (FILTERING JOINS)
# =============================================================================

# Joiny filtrujące NIE dodają kolumn - służą tylko do filtrowania
# wierszy ramki x na podstawie tego, czy mają dopasowanie w y. Wynikowa
# ramka ma te same kolumny co x, ale potencjalnie mniej wierszy.
# [ELI5] To jak filtr do kawy - nie dodajesz nic nowego, tylko wybierasz
# które ziarna (wiersze) przepuścić, a które zatrzymać.

# -----------------------------------------------------------------------------
# SEMI JOIN - zostaw tylko pasujące
# -----------------------------------------------------------------------------

# semi_join(x, y) zwraca wiersze z x, które MAJĄ dopasowanie w y.
# Działa jak filtr - sprawdza "czy ten wiersz z x ma odpowiednik w y?".
# Jeśli tak - zostaje. Kolumny z y NIE są dodawane do wyniku.
# [ELI5] Masz listę wszystkich uczniów (x) i listę obecności (y).
# Semi join daje ci listę uczniów którzy BYLI obecni - ale tylko ich imiona,
# bez informacji z listy obecności.

dane_semi_1 <- dplyr::semi_join(x = data_loi, y = data_elem)

# Porównaj z oryginałem - te same kolumny, potencjalnie mniej wierszy
names(data_loi)
names(dane_semi_1)
nrow(data_loi)
nrow(dane_semi_1)

# Semi join z jawnym kluczem
dane_semi_2 <- dplyr::semi_join(
  x = data_loi,
  y = data_bsi,
  by = dplyr::join_by(sample_id)
)

# -----------------------------------------------------------------------------
# ANTI JOIN - zostaw tylko NIEpasujące
# -----------------------------------------------------------------------------

# anti_join(x, y) zwraca wiersze z x, które NIE MAJĄ dopasowania
# w y. To odwrotność semi_join. Przydatne do znajdowania "sierot" - rekordów
# które powinny mieć dopasowanie, ale go nie mają (np. błędy w danych).
# [ELI5] Z listy wszystkich uczniów (x) zostawiasz tylko tych, których
# NIE MA na liście obecności (y) - czyli wagarowiczów!

dane_anti_1 <- dplyr::anti_join(x = data_bsi, y = data_loi)

# Sprawdźmy kto "zaginął"
print(dane_anti_1)

# Anti join w drugą stronę - inne wyniki!
dane_anti_2 <- dplyr::anti_join(x = data_loi, y = data_bsi)

# Ile próbek z loi nie ma odpowiednika w bsi?
nrow(dane_anti_2)

# =============================================================================
# CZĘŚĆ 3: OPERACJE ZBIOROWE (SET OPERATIONS)
# =============================================================================

# Operacje zbiorowe z dplyr działają na całych ramkach danych,
# traktując każdy wiersz jako element zbioru. Wymagają IDENTYCZNYCH kolumn
# (tych samych nazw i typów) w obu ramkach. Odpowiadają operacjom
# matematycznym na zbiorach: suma, przecięcie, różnica.
# [ELI5] To jak zabawy z klockami dwóch kolorów. Możesz: wziąć wszystkie
# klocki (union), tylko te które masz w obu kolorach (intersect), albo
# tylko czerwone których nie masz w niebieskich (setdiff).

# Przygotujmy dane demonstracyjne - dwie ramki z tymi samymi kolumnami
# ale częściowo różnymi wierszami

# Wybierzmy część próbek z data_loi
zbior_A <- dplyr::filter(
  data_loi,
  sample_id %in%
    c(
      "stl14-1b-01c-01 000.50",
      "stl14-1b-01c-01 037.50",
      "stl14-1b-01c-01 095.50",
      "stl14-1b-01c-01 106.50"
    )
)
zbior_B <- dplyr::filter(
  data_loi,
  sample_id %in%
    c(
      "stl14-1b-01c-01 095.50",
      "stl14-1b-01c-01 106.50",
      "stl14-1b-01c-01 114.00",
      "stl14-1b-01c-01 117.50"
    )
)

# Podgląd
print(zbior_A)
print(zbior_B)

# -----------------------------------------------------------------------------
# UNION - suma zbiorów (wszystkie unikalne wiersze)
# -----------------------------------------------------------------------------

# union(x, y) zwraca wszystkie unikalne wiersze występujące
# w x LUB w y (lub w obu). Duplikaty są usuwane. Odpowiada matematycznej
# sumie zbiorów (A ∪ B).
# [ELI5] Wrzucasz wszystkie klocki z obu pudełek do jednego, ale jeśli
# masz dwa takie same - zostawiasz tylko jeden.

zbior_union <- dplyr::union(zbior_A, zbior_B)

nrow(zbior_A)
nrow(zbior_B)
nrow(zbior_union)

print(zbior_union)

# -----------------------------------------------------------------------------
# UNION_ALL - suma z duplikatami
# -----------------------------------------------------------------------------

# union_all(x, y) łączy wszystkie wiersze z x i y BEZ usuwania
# duplikatów. Szybsze niż union() gdy wiemy, że nie ma powtórzeń lub
# gdy chcemy je zachować.
# [ELI5] Wrzucasz wszystkie klocki z obu pudełek - nawet jeśli masz
# dwa takie same, zostawiasz oba.

zbior_union_all <- dplyr::union_all(zbior_A, zbior_B)

nrow(zbior_union_all)

# -----------------------------------------------------------------------------
# INTERSECT - część wspólna
# -----------------------------------------------------------------------------

# intersect(x, y) zwraca tylko wiersze występujące ZARÓWNO w x
# JAK I w y. Odpowiada matematycznemu przecięciu zbiorów (A ∩ B).
# [ELI5] Zostawiasz tylko te klocki, które masz w OBU pudełkach -
# takie same w czerwonym i niebieskim.

zbior_intersect <- dplyr::intersect(zbior_A, zbior_B)

print(zbior_intersect)
nrow(zbior_intersect)

# -----------------------------------------------------------------------------
# SETDIFF - różnica zbiorów
# -----------------------------------------------------------------------------

# setdiff(x, y) zwraca wiersze występujące w x, ale NIE w y.
# Uwaga: kolejność argumentów ma znaczenie! setdiff(A,B) != setdiff(B,A).
# Odpowiada matematycznej różnicy zbiorów (A \ B).
# [ELI5] Z czerwonego pudełka wyrzucasz wszystkie klocki, które masz też
# w niebieskim. Zostają tylko "czysto czerwone".

# A minus B
zbior_diff_AB <- dplyr::setdiff(zbior_A, zbior_B)
print(zbior_diff_AB)

# B minus A - inny wynik!
zbior_diff_BA <- dplyr::setdiff(zbior_B, zbior_A)
print(zbior_diff_BA)

# -----------------------------------------------------------------------------
# SYMDIFF - różnica symetryczna (od dplyr 1.1.0)
# -----------------------------------------------------------------------------

# symdiff(x, y) zwraca wiersze występujące w x LUB w y, ale NIE
# w obu jednocześnie. To suma różnic: (A \ B) ∪ (B \ A). Odpowiada
# matematycznej różnicy symetrycznej (A △ B).
# [ELI5] Zostawiasz tylko klocki "unikalne" - które masz TYLKO w jednym
# pudełku, ale nie w obu.

zbior_symdiff <- dplyr::symdiff(zbior_A, zbior_B)
print(zbior_symdiff)

# Sprawdzenie - to to samo co union dwóch setdiff
zbior_symdiff_manual <- dplyr::union(
  dplyr::setdiff(zbior_A, zbior_B),
  dplyr::setdiff(zbior_B, zbior_A)
)

# =============================================================================
# PODSUMOWANIE - TABELA PORÓWNAWCZA
# =============================================================================

# MUTATING JOINS (dodają kolumny):
# ---------------------------------
# left_join(x, y)  - wszystkie wiersze z x + pasujące dane z y
# right_join(x, y) - wszystkie wiersze z y + pasujące dane z x
# inner_join(x, y) - tylko wiersze z dopasowaniem w OBU ramkach
# full_join(x, y)  - wszystkie wiersze z OBU ramek

# FILTERING JOINS (filtrują wiersze, nie dodają kolumn):
# ------------------------------------------------------
# semi_join(x, y)  - wiersze z x które MAJĄ dopasowanie w y
# anti_join(x, y)  - wiersze z x które NIE MAJĄ dopasowania w y

# SET OPERATIONS (wymagają identycznych kolumn):
# ----------------------------------------------
# union(x, y)      - wszystkie unikalne wiersze z x i y
# union_all(x, y)  - wszystkie wiersze z x i y (z duplikatami)
# intersect(x, y)  - wiersze wspólne dla x i y
# setdiff(x, y)    - wiersze z x których nie ma w y
# symdiff(x, y)    - wiersze występujące tylko w jednej ramce
