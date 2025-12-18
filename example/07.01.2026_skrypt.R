# Paczki
library(dplyr)
library(readxl)

# Dane ----
# Wylistowanie dostępnych arkuszy w pliku Excel
readxl::excel_sheets("data_msu.xlsx")

# Dane ze spalania
data_1 <- readxl::read_excel("data_msu.xlsx", sheet = "loi")

# Dane elementarne
data_2 <- readxl::read_excel("data_msu.xlsx", sheet = "elemental")

# Dane krzemionka
data_3 <- readxl::read_excel("data_msu.xlsx", sheet = "bsi")

# Łączenie ramek (mutujące) ----
# dplyr::left/right/full/inner_join()
# Lewa ramka jest "nadrzędna"
dane_l_1 <- dplyr::left_join(x = data_1, y = data_2)

dane_l_2 <- dplyr::left_join(x = data_1, y = data_3)

dane_l_3 <- dplyr::left_join(
  x = data_1,
  y = data_3,
  by = dplyr::join_by(sample_id == sample_id)
)

dane_l_4 <- dplyr::left_join(
  dplyr::select(data_1, -mass_mg),
  dplyr::rename(data_3, nazwa_id = sample_id),
  by = dplyr::join_by(sample_id == nazwa_id)
)

data_l_5 <- dplyr::left_join(
  data_1,
  data_2,
  by = dplyr::join_by(sample_id)
) |>
  dplyr::left_join(y = data_3, by = dplyr::join_by(sample_id))

# Łączenie do prawej ramki
data_r_1 <- dplyr::right_join(x = data_1, y = data_2)

data_r_2 <- dplyr::right_join(
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
