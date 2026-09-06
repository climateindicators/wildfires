# Build tidy long-format data for the Wildfires indicator.
#
#   Rscript R/build_data.R
#
# Reads EPA's published figure CSVs in data-raw/ and writes data/*.csv plus
# data/meta.yml. Rerunning with unchanged inputs produces byte-identical output.
# Nothing here touches the network.
#
# Generated as a stub by the build-indicator skill. Each figure below has a
# `todo_reshape()` call standing where its reshape belongs. Replace that line,
# then delete the todo_reshape() helper once no call to it remains.
#
# TO UPDATE THE DATA: drop replacement CSVs into data-raw/ and rerun. Headers
# are asserted, not assumed, so a renamed or reordered column stops the build.

suppressPackageStartupMessages({
  library(dplyr)
})

root <- here::here()
source(file.path(root, "R/utils/epa_csv.R"))
source(file.path(root, "R/utils/write_stable.R"))

raw_dir <- file.path(root, "data-raw")
out_dir <- file.path(root, "data")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

todo_reshape <- function(n) {
  stop(
    "R/build_data.R: the reshape for figure ", n, " has not been written yet.\n",
    "Replace the todo_reshape(", n, ") call with the pivot that produces the tidy\n",
    "long-format data frame for that figure, then remove this helper.",
    call. = FALSE
  )
}

# ---- Indicator constants -----------------------------------------------------

INDICATOR <- list(
  name                    = "Wildfires",
  slug                    = "wildfires",
  publisher               = "U.S. Environmental Protection Agency",
  source_page             = "https://19january2025snapshot.epa.gov/climate-indicators/climate-change-indicators-wildfires/index.html",
  technical_documentation = "https://19january2025snapshot.epa.gov/system/files/documents/2024-06/wildfires_documentation.pdf",
  rights                  = "Public domain, work of the U.S. Government (17 U.S.C. 105)"
)

# ---- Figure 1: Wildfire Frequency in the United States, 1983-2022 ----

f1_path <- file.path(raw_dir, "wildfires_fig-1.csv")
f1_meta <- read_epa_preamble(f1_path)
f1_raw  <- read_epa_csv(f1_path)

# All columns are listed as expected headers so a rename or reorder stops the
# build from the first run. When you write the reshape, move the identifier
# columns into id_cols so the split between keys and series is explicit.
assert_headers(
  f1_raw,
  id_cols          = character(),
  expected_headers = c("Year", "National Interagency Fire Center", "Forest Service Wildfire Statistics"),
  what             = "wildfires_fig-1.csv"
)

# TODO reshape: 40 rows, Year + 2 series.
# Source headers: Year | National Interagency Fire Center | Forest Service Wildfire Statistics
# Units line: number of fires
# Produce a tidy long-format data frame. Keep every value as character: the
# source carries up to 10 significant digits and must survive byte for byte.
f1 <- todo_reshape(1)

# The output name below is a placeholder. Rename it for what the figure
# actually carries, the way river_flooding_magnitude.csv does.
write_csv_stable(f1, file.path(out_dir, "wildfires_fig1.csv"))

# ---- Figure 2: Wildfire Extent in the United States, 1983-2022 ----

f2_path <- file.path(raw_dir, "wildfires_fig-2.csv")
f2_meta <- read_epa_preamble(f2_path)
f2_raw  <- read_epa_csv(f2_path)

# All columns are listed as expected headers so a rename or reorder stops the
# build from the first run. When you write the reshape, move the identifier
# columns into id_cols so the split between keys and series is explicit.
assert_headers(
  f2_raw,
  id_cols          = character(),
  expected_headers = c("Year", "National Interagency Fire Center", "Forest Service Wildfire Statistics"),
  what             = "wildfires_fig-2.csv"
)

# TODO reshape: 40 rows, Year + 2 series.
# Source headers: Year | National Interagency Fire Center | Forest Service Wildfire Statistics
# Units line: acres
# Produce a tidy long-format data frame. Keep every value as character: the
# source carries up to 10 significant digits and must survive byte for byte.
f2 <- todo_reshape(2)

# The output name below is a placeholder. Rename it for what the figure
# actually carries, the way river_flooding_magnitude.csv does.
write_csv_stable(f2, file.path(out_dir, "wildfires_fig2.csv"))

# ---- Figure 3: Damage Caused by Wildfires in the United States, 1984-2021 ----

f3_path <- file.path(raw_dir, "wildfires_fig-3.csv")
f3_meta <- read_epa_preamble(f3_path)
f3_raw  <- read_epa_csv(f3_path)

# All columns are listed as expected headers so a rename or reorder stops the
# build from the first run. When you write the reshape, move the identifier
# columns into id_cols so the split between keys and series is explicit.
assert_headers(
  f3_raw,
  id_cols          = character(),
  expected_headers = c("Year", "Low", "Moderate", "High", "Unburned", "Increased greenness"),
  what             = "wildfires_fig-3.csv"
)

# TODO reshape: 38 rows, Year + 5 series.
# Source headers: Year | Low | Moderate | High | Unburned | Increased greenness
# Units line: acres
# Produce a tidy long-format data frame. Keep every value as character: the
# source carries up to 10 significant digits and must survive byte for byte.
f3 <- todo_reshape(3)

# The output name below is a placeholder. Rename it for what the figure
# actually carries, the way river_flooding_magnitude.csv does.
write_csv_stable(f3, file.path(out_dir, "wildfires_fig3.csv"))

# ---- Figure 4: Average Annual Burned Acreage by State, 1984-2021 ----

f4_path <- file.path(raw_dir, "wildfires_fig-4.csv")
f4_meta <- read_epa_preamble(f4_path)
f4_raw  <- read_epa_csv(f4_path)

# All columns are listed as expected headers so a rename or reorder stops the
# build from the first run. When you write the reshape, move the identifier
# columns into id_cols so the split between keys and series is explicit.
assert_headers(
  f4_raw,
  id_cols          = character(),
  expected_headers = c("Year/Trend", "AL", "AK", "AZ", "AR", "CA", "CO", "DE", "FL", "GA", "HI", "ID", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "SC", "SD", "TN", "TX", "UT", "VA", "WA", "WV", "WI", "WY"),
  what             = "wildfires_fig-4.csv"
)

# TODO reshape: 39 rows, Year/Trend/AL/AK/AZ/AR/CA/CO/DE/FL/GA/HI/ID/IN/IA/KS/KY/LA/ME/MD/MA/MI/MN/MS/MO/MT/NE/NV/NJ/NM/NY/NC/ND/OH/OK/OR/PA/SC/SD/TN/TX/UT/VA/WA/WV/WI/WY.
# Source headers: Year/Trend | AL | AK | AZ | AR | CA | CO | DE | FL | GA | HI | ID | IN | IA | KS | KY | LA | ME | MD | MA | MI | MN | MS | MO | MT | NE | NV | NJ | NM | NY | NC | ND | OH | OK | OR | PA | SC | SD | TN | TX | UT | VA | WA | WV | WI | WY
# Units line: acres per square mile of land area (trend); acres (annual data)
# NOTE: this Units: line carries more than one unit, one per series, but the
#   meta.yml `unit:` field below is single-valued. Either carry the unit as a
#   column of the output data (as `unit`) and set `unit:` to a summary, or
#   split the figure into one output file per series.
# Produce a tidy long-format data frame. Keep every value as character: the
# source carries up to 10 significant digits and must survive byte for byte.
f4 <- todo_reshape(4)

# The output name below is a placeholder. Rename it for what the figure
# actually carries, the way river_flooding_magnitude.csv does.
write_csv_stable(f4, file.path(out_dir, "wildfires_fig4.csv"))

# ---- Figure 5: Change in Annual Burned Acreage by State Between 1984-2002 and 2003-2021 ----

f5_path <- file.path(raw_dir, "wildfires_fig-5.csv")
f5_meta <- read_epa_preamble(f5_path)
f5_raw  <- read_epa_csv(f5_path)

# All columns are listed as expected headers so a rename or reorder stops the
# build from the first run. When you write the reshape, move the identifier
# columns into id_cols so the split between keys and series is explicit.
assert_headers(
  f5_raw,
  id_cols          = character(),
  expected_headers = c("State", "Change in burned acreage"),
  what             = "wildfires_fig-5.csv"
)

# TODO reshape: 45 rows, State + 1 series.
# Source headers: State | Change in burned acreage
# Units line: acres per square mile of land area
# Produce a tidy long-format data frame. Keep every value as character: the
# source carries up to 10 significant digits and must survive byte for byte.
f5 <- todo_reshape(5)

# The output name below is a placeholder. Rename it for what the figure
# actually carries, the way river_flooding_magnitude.csv does.
write_csv_stable(f5, file.path(out_dir, "wildfires_fig5.csv"))

# ---- Figure 6: Comparison of Monthly Burned Area Due to Wildfires in the United States Between 1984–2002 and 2003–2021 ----

f6_path <- file.path(raw_dir, "wildfires_fig-6.csv")
f6_meta <- read_epa_preamble(f6_path)
f6_raw  <- read_epa_csv(f6_path)

# All columns are listed as expected headers so a rename or reorder stops the
# build from the first run. When you write the reshape, move the identifier
# columns into id_cols so the split between keys and series is explicit.
assert_headers(
  f6_raw,
  id_cols          = character(),
  expected_headers = c("Month", "1984-2002", "2003-2021"),
  what             = "wildfires_fig-6.csv"
)

# TODO reshape: 12 rows, Month + 2 series.
# Source headers: Month | 1984-2002 | 2003-2021
# Units line: burned area (millions of acres per year)
# Produce a tidy long-format data frame. Keep every value as character: the
# source carries up to 10 significant digits and must survive byte for byte.
f6 <- todo_reshape(6)

# The output name below is a placeholder. Rename it for what the figure
# actually carries, the way river_flooding_magnitude.csv does.
write_csv_stable(f6, file.path(out_dir, "wildfires_fig6.csv"))

# ---- Figure 7: Comparison of Monthly Burned Area Due to Wildfires in the Eastern and Western United States Between 1984-2002 and 2003-2021 ----

f7_path <- file.path(raw_dir, "wildfires_fig-7.csv")
f7_meta <- read_epa_preamble(f7_path)
f7_raw  <- read_epa_csv(f7_path)

# All columns are listed as expected headers so a rename or reorder stops the
# build from the first run. When you write the reshape, move the identifier
# columns into id_cols so the split between keys and series is explicit.
assert_headers(
  f7_raw,
  id_cols          = character(),
  expected_headers = c("Month", "East (1984-2002)", "East (2003-2021)", "West (1984-2002)", "West (2003-2021)"),
  what             = "wildfires_fig-7.csv"
)

# TODO reshape: 12 rows, Month + 4 series.
# Source headers: Month | East (1984-2002) | East (2003-2021) | West (1984-2002) | West (2003-2021)
# Units line: burned area (millions of acres per year)
# Produce a tidy long-format data frame. Keep every value as character: the
# source carries up to 10 significant digits and must survive byte for byte.
f7 <- todo_reshape(7)

# The output name below is a placeholder. Rename it for what the figure
# actually carries, the way river_flooding_magnitude.csv does.
write_csv_stable(f7, file.path(out_dir, "wildfires_fig7.csv"))

# ---- Data dictionary ---------------------------------------------------------

col <- function(name, type, description) {
  list(name = name, type = type, description = description)
}

# One entry per output column, in order, filled from the data frame itself so it
# cannot drift. `type` and `description` are deliberately blank: tests/test-data.R
# fails while either is empty, so every column has to be documented by hand.
describe <- function(df) lapply(names(df), function(nm) col(nm, "", ""))

meta <- list(
  indicator = INDICATOR,
  datasets = list(
    list(
      file            = "wildfires_fig1.csv",
      figure          = "Figure 1",
      figure_title    = f1_meta$title,
      source_file     = "wildfires_fig-1.csv",
      source_sha256   = file_sha256(f1_path),
      source_encoding = "UTF-8",
      data_source     = f1_meta$data_source,
      web_update      = f1_meta$web_update,
      unit            = f1_meta$units,
      rows            = nrow(f1),
      columns         = describe(f1)
    ),
    list(
      file            = "wildfires_fig2.csv",
      figure          = "Figure 2",
      figure_title    = f2_meta$title,
      source_file     = "wildfires_fig-2.csv",
      source_sha256   = file_sha256(f2_path),
      source_encoding = "UTF-8",
      data_source     = f2_meta$data_source,
      web_update      = f2_meta$web_update,
      unit            = f2_meta$units,
      rows            = nrow(f2),
      columns         = describe(f2)
    ),
    list(
      file            = "wildfires_fig3.csv",
      figure          = "Figure 3",
      figure_title    = f3_meta$title,
      source_file     = "wildfires_fig-3.csv",
      source_sha256   = file_sha256(f3_path),
      source_encoding = "UTF-8",
      data_source     = f3_meta$data_source,
      web_update      = f3_meta$web_update,
      unit            = f3_meta$units,
      rows            = nrow(f3),
      columns         = describe(f3)
    ),
    list(
      file            = "wildfires_fig4.csv",
      figure          = "Figure 4",
      figure_title    = f4_meta$title,
      source_file     = "wildfires_fig-4.csv",
      source_sha256   = file_sha256(f4_path),
      source_encoding = "UTF-8",
      data_source     = f4_meta$data_source,
      web_update      = f4_meta$web_update,
      unit            = f4_meta$units,
      rows            = nrow(f4),
      columns         = describe(f4)
    ),
    list(
      file            = "wildfires_fig5.csv",
      figure          = "Figure 5",
      figure_title    = f5_meta$title,
      source_file     = "wildfires_fig-5.csv",
      source_sha256   = file_sha256(f5_path),
      source_encoding = "UTF-8",
      data_source     = f5_meta$data_source,
      web_update      = f5_meta$web_update,
      unit            = f5_meta$units,
      rows            = nrow(f5),
      columns         = describe(f5)
    ),
    list(
      file            = "wildfires_fig6.csv",
      figure          = "Figure 6",
      figure_title    = f6_meta$title,
      source_file     = "wildfires_fig-6.csv",
      source_sha256   = file_sha256(f6_path),
      source_encoding = "UTF-8-BOM",
      data_source     = f6_meta$data_source,
      web_update      = f6_meta$web_update,
      unit            = f6_meta$units,
      rows            = nrow(f6),
      columns         = describe(f6)
    ),
    list(
      file            = "wildfires_fig7.csv",
      figure          = "Figure 7",
      figure_title    = f7_meta$title,
      source_file     = "wildfires_fig-7.csv",
      source_sha256   = file_sha256(f7_path),
      source_encoding = "UTF-8-BOM",
      data_source     = f7_meta$data_source,
      web_update      = f7_meta$web_update,
      unit            = f7_meta$units,
      rows            = nrow(f7),
      columns         = describe(f7)
    )
  )
)

write_yaml_stable(meta, file.path(out_dir, "meta.yml"))

# ---- Verify what was written -------------------------------------------------

written <- list.files(out_dir, pattern = "[.](csv|yml)$", full.names = TRUE)
invisible(lapply(written, assert_clean_output))

cat("\nWrote:\n")
for (p in written) {
  cat(sprintf("  %-34s %8d bytes  %s\n", basename(p), file.size(p), substr(file_sha256(p), 1, 12)))
}
