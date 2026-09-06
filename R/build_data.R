# Build tidy long-format data for the Wildfires indicator.
#
#   Rscript R/build_data.R
#
# Reads EPA's published figure CSVs in data-raw/ and writes data/*.csv plus
# data/meta.yml. Rerunning with unchanged inputs produces byte-identical output.
# Nothing here touches the network.
#
# TO UPDATE THE DATA: drop replacement CSVs into data-raw/ and rerun. Headers
# are asserted, not assumed, so a renamed or reordered column stops the build.
#
# Row order is set with match() against an explicit level vector everywhere, so
# no output depends on the machine's collation locale. Values stay character
# from source to output: EPA publishes up to 10 significant digits and they must
# survive byte for byte.
#
# Column names follow the contract the website reads through: the measured
# column is `value`, a charted series is the pair `series_key` (stable, safe to
# hard-code in chart code) and `series_label` (what a legend prints), and the
# unit belongs to the file, recorded once in meta.yml rather than per row.

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
})

root <- here::here()
source(file.path(root, "R/utils/epa_csv.R"))
source(file.path(root, "R/utils/write_stable.R"))

raw_dir <- file.path(root, "data-raw")
out_dir <- file.path(root, "data")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

#' Attach series_key/series_label from a named vector of source headers.
#'
#' `series` maps key -> the header string EPA prints. The header is the label,
#' so the pair is derived from one declaration and the two cannot fall out of
#' step with each other.
pivot_series <- function(df, series, id_col) {
  df |>
    pivot_longer(all_of(unname(series)), names_to = "series_label", values_to = "value") |>
    mutate(series_key = names(series)[match(series_label, series)]) |>
    arrange(match(series_key, names(series)), match(.data[[id_col]], df[[id_col]]))
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

f1_series <- c(
  nifc = "National Interagency Fire Center",
  usfs = "Forest Service Wildfire Statistics"
)

assert_headers(
  f1_raw,
  id_cols          = "Year",
  expected_headers = unname(f1_series),
  what             = "wildfires_fig-1.csv"
)

# The two series do not cover the same years: EPA prints the Forest Service
# counts only where that record runs, leaving the rest of the column empty. A
# blank here is "this series does not report that year", not a missing value, so
# the blanks are dropped rather than carried as NA, and the output is one row per
# value EPA actually published. assert_conservation() holds those counts equal.
f1 <- f1_raw |>
  pivot_series(f1_series, "Year") |>
  filter(trimws(value) != "") |>
  rename(year = Year) |>
  select(year, series_key, series_label, value)

assert_conservation(f1_raw, unname(f1_series), nrow(f1), "wildfires_fig-1.csv")

write_csv_stable(f1, file.path(out_dir, "wildfires_frequency.csv"))

# ---- Figure 2: Wildfire Extent in the United States, 1983-2022 ----

f2_path <- file.path(raw_dir, "wildfires_fig-2.csv")
f2_meta <- read_epa_preamble(f2_path)
f2_raw  <- read_epa_csv(f2_path)

f2_series <- c(
  nifc = "National Interagency Fire Center",
  usfs = "Forest Service Wildfire Statistics"
)

assert_headers(
  f2_raw,
  id_cols          = "Year",
  expected_headers = unname(f2_series),
  what             = "wildfires_fig-2.csv"
)

# Same partial coverage as figure 1; see the note there.
f2 <- f2_raw |>
  pivot_series(f2_series, "Year") |>
  filter(trimws(value) != "") |>
  rename(year = Year) |>
  select(year, series_key, series_label, value)

assert_conservation(f2_raw, unname(f2_series), nrow(f2), "wildfires_fig-2.csv")

write_csv_stable(f2, file.path(out_dir, "wildfires_extent.csv"))

# ---- Figure 3: Damage Caused by Wildfires in the United States, 1984-2021 ----

f3_path <- file.path(raw_dir, "wildfires_fig-3.csv")
f3_meta <- read_epa_preamble(f3_path)
f3_raw  <- read_epa_csv(f3_path)

# Burn-severity classes, kept in EPA's published column order rather than
# alphabetised, because the order is the severity gradient the figure stacks.
f3_severity <- c(
  low                 = "Low",
  moderate            = "Moderate",
  high                = "High",
  unburned            = "Unburned",
  increased_greenness = "Increased greenness"
)

assert_headers(
  f3_raw,
  id_cols          = "Year",
  expected_headers = unname(f3_severity),
  what             = "wildfires_fig-3.csv"
)

f3 <- f3_raw |>
  pivot_series(f3_severity, "Year") |>
  rename(year = Year) |>
  select(year, series_key, series_label, value)

assert_conservation(f3_raw, unname(f3_severity), nrow(f3), "wildfires_fig-3.csv")

write_csv_stable(f3, file.path(out_dir, "wildfires_burn_severity.csv"))

# ---- Figure 4: Average Annual Burned Acreage by State, 1984-2021 ----

f4_path <- file.path(raw_dir, "wildfires_fig-4.csv")
f4_meta <- read_epa_preamble(f4_path)
f4_raw  <- read_epa_csv(f4_path)

# One column per state, in EPA's published order. Not all 50 appear: states with
# too little burned area for a reliable trend are absent from the source file.
f4_states <- c(
  "AL", "AK", "AZ", "AR", "CA", "CO", "DE", "FL", "GA", "HI", "ID", "IN", "IA",
  "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV",
  "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "SC", "SD", "TN", "TX",
  "UT", "VA", "WA", "WV", "WI", "WY"
)

assert_headers(
  f4_raw,
  id_cols          = "Year/Trend",
  expected_headers = f4_states,
  what             = "wildfires_fig-4.csv"
)

# This file stacks two different measures under one header row. Its first row is
# labelled "Trend" and carries a rate in acres per square mile of land area; the
# 38 rows below it carry annual burned acreage in acres. They are different
# quantities on different keys, and a file's unit is recorded once in meta.yml,
# so they are written as two files rather than one file with a unit column.
F4_TREND_ROW <- "Trend"
f4_years <- setdiff(f4_raw[["Year/Trend"]], F4_TREND_ROW)

if (!identical(f4_raw[["Year/Trend"]][1], F4_TREND_ROW)) {
  stop(
    "wildfires_fig-4.csv no longer starts with its '", F4_TREND_ROW, "' row.",
    call. = FALSE
  )
}

f4_long <- f4_raw |>
  rename(period = `Year/Trend`) |>
  pivot_longer(all_of(f4_states), names_to = "state", values_to = "value")

f4_trend <- f4_long |>
  filter(period == F4_TREND_ROW) |>
  arrange(match(state, f4_states)) |>
  select(state, value)

f4_annual <- f4_long |>
  filter(period != F4_TREND_ROW) |>
  rename(year = period) |>
  arrange(match(state, f4_states), match(year, f4_years)) |>
  select(state, year, value)

assert_conservation(
  f4_raw, f4_states, nrow(f4_trend) + nrow(f4_annual), "wildfires_fig-4.csv"
)

write_csv_stable(f4_trend, file.path(out_dir, "wildfires_burned_acreage_trend_by_state.csv"))
write_csv_stable(f4_annual, file.path(out_dir, "wildfires_burned_acreage_by_state.csv"))

# EPA's own Units: line names both units, one per measure, separated by a
# semicolon: "acres per square mile of land area (trend); acres (annual data)".
# Splitting it here keeps both strings sourced from the file's preamble instead
# of retyped, so a change upstream still cannot drift past this build.
f4_units <- trimws(strsplit(f4_meta$units, ";", fixed = TRUE)[[1]])
if (length(f4_units) != 2L) {
  stop("wildfires_fig-4.csv: expected two units on its Units: line, got ",
       length(f4_units), ".", call. = FALSE)
}
f4_trend_unit  <- trimws(sub("\\(trend\\)$", "", f4_units[1]))
f4_annual_unit <- trimws(sub("\\(annual data\\)$", "", f4_units[2]))

# ---- Figure 5: Change in Annual Burned Acreage by State Between 1984-2002 and 2003-2021 ----

f5_path <- file.path(raw_dir, "wildfires_fig-5.csv")
f5_meta <- read_epa_preamble(f5_path)
f5_raw  <- read_epa_csv(f5_path)

assert_headers(
  f5_raw,
  id_cols          = "State",
  expected_headers = "Change in burned acreage",
  what             = "wildfires_fig-5.csv"
)

# Already one row per state, so the reshape is a rename. State order is EPA's
# published order, preserved with match() rather than sorted, so no collation
# locale can reorder it.
f5 <- f5_raw |>
  arrange(match(State, f5_raw$State)) |>
  select(state = State, value = `Change in burned acreage`)

assert_conservation(f5_raw, "Change in burned acreage", nrow(f5), "wildfires_fig-5.csv")

write_csv_stable(f5, file.path(out_dir, "wildfires_burned_acreage_change_by_state.csv"))

# ---- Figure 6: Comparison of Monthly Burned Area Due to Wildfires in the United States Between 1984-2002 and 2003-2021 ----

f6_path <- file.path(raw_dir, "wildfires_fig-6.csv")
f6_meta <- read_epa_preamble(f6_path)
f6_raw  <- read_epa_csv(f6_path)

f6_periods <- c(
  early = "1984-2002",
  late  = "2003-2021"
)

assert_headers(
  f6_raw,
  id_cols          = "Month",
  expected_headers = unname(f6_periods),
  what             = "wildfires_fig-6.csv"
)

f6 <- f6_raw |>
  pivot_series(f6_periods, "Month") |>
  rename(month = Month) |>
  select(month, series_key, series_label, value)

assert_conservation(f6_raw, unname(f6_periods), nrow(f6), "wildfires_fig-6.csv")

write_csv_stable(f6, file.path(out_dir, "wildfires_monthly_burned_area.csv"))

# ---- Figure 7: Comparison of Monthly Burned Area Due to Wildfires in the Eastern and Western United States Between 1984-2002 and 2003-2021 ----

f7_path <- file.path(raw_dir, "wildfires_fig-7.csv")
f7_meta <- read_epa_preamble(f7_path)
f7_raw  <- read_epa_csv(f7_path)

# Each header encodes a region and a period. They are split through this explicit
# lookup rather than parsed out of the string, so a header EPA rewords fails the
# assertion above instead of being silently re-parsed into the wrong cell. The
# charted series is the period; the region is what the figure splits on, and it
# keeps the same two keys as figure 6 so both read off one colour mapping.
f7_series <- data.frame(
  header       = c("East (1984-2002)", "East (2003-2021)", "West (1984-2002)", "West (2003-2021)"),
  region       = c("East", "East", "West", "West"),
  series_key   = c("early", "late", "early", "late"),
  series_label = c("1984-2002", "2003-2021", "1984-2002", "2003-2021"),
  stringsAsFactors = FALSE
)

assert_headers(
  f7_raw,
  id_cols          = "Month",
  expected_headers = f7_series$header,
  what             = "wildfires_fig-7.csv"
)

f7 <- f7_raw |>
  pivot_longer(all_of(f7_series$header), names_to = "header", values_to = "value") |>
  left_join(f7_series, by = "header") |>
  rename(month = Month) |>
  arrange(match(header, f7_series$header), match(month, f7_raw$Month)) |>
  select(month, region, series_key, series_label, value)

assert_conservation(f7_raw, f7_series$header, nrow(f7), "wildfires_fig-7.csv")

write_csv_stable(f7, file.path(out_dir, "wildfires_monthly_burned_area_by_region.csv"))

# ---- Data dictionary ---------------------------------------------------------

col <- function(name, type, description) {
  list(name = name, type = type, description = description)
}

# Every key column any output file uses, documented once. `value` is documented
# per dataset instead, in the describe() call below, because it is a different
# quantity in each file.
COLUMN_DOC <- list(
  year = col(
    "year", "integer",
    "Calendar year, as published."
  ),
  month = col(
    "month", "string",
    "Calendar month name, in January-to-December order."
  ),
  state = col(
    "state", "string",
    "U.S. state. Two-letter postal abbreviation where the source uses one, full name where it does not."
  ),
  region = col(
    "region", "string",
    "Half of the country the value covers, East or West."
  ),
  series_key = col(
    "series_key", "string",
    "Stable identifier for the series, safe to reference from chart code."
  ),
  series_label = col(
    "series_label", "string",
    "The series as a legend should print it, in EPA's own wording."
  )
)

describe <- function(df, what, value) {
  lapply(names(df), function(nm) {
    if (identical(nm, "value")) {
      return(col("value", "number", value))
    }
    entry <- COLUMN_DOC[[nm]]
    if (is.null(entry)) {
      stop("Column '", nm, "' of ", what,
           " has no entry in COLUMN_DOC in R/build_data.R.", call. = FALSE)
    }
    entry
  })
}

meta <- list(
  indicator = INDICATOR,
  datasets = list(
    list(
      file            = "wildfires_frequency.csv",
      figure          = "Figure 1",
      figure_title    = f1_meta$title,
      source_file     = "wildfires_fig-1.csv",
      source_sha256   = file_sha256(f1_path),
      source_encoding = "UTF-8",
      data_source     = f1_meta$data_source,
      web_update      = f1_meta$web_update,
      unit            = f1_meta$units,
      rows            = nrow(f1),
      columns         = describe(
        f1, "wildfires_frequency.csv",
        "Number of wildfires reported that year by that series. The two series are not directly comparable and do not cover the same years."
      )
    ),
    list(
      file            = "wildfires_extent.csv",
      figure          = "Figure 2",
      figure_title    = f2_meta$title,
      source_file     = "wildfires_fig-2.csv",
      source_sha256   = file_sha256(f2_path),
      source_encoding = "UTF-8",
      data_source     = f2_meta$data_source,
      web_update      = f2_meta$web_update,
      unit            = f2_meta$units,
      rows            = nrow(f2),
      columns         = describe(
        f2, "wildfires_extent.csv",
        "Wildfire-burned area in acres for that year, from that series. The two series are not directly comparable and do not cover the same years."
      )
    ),
    list(
      file            = "wildfires_burn_severity.csv",
      figure          = "Figure 3",
      figure_title    = f3_meta$title,
      source_file     = "wildfires_fig-3.csv",
      source_sha256   = file_sha256(f3_path),
      source_encoding = "UTF-8",
      data_source     = f3_meta$data_source,
      web_update      = f3_meta$web_update,
      unit            = f3_meta$units,
      rows            = nrow(f3),
      columns         = describe(
        f3, "wildfires_burn_severity.csv",
        "Burned area in acres falling in that MTBS severity class that year."
      )
    ),
    list(
      file            = "wildfires_burned_acreage_trend_by_state.csv",
      figure          = "Figure 4",
      figure_title    = f4_meta$title,
      source_file     = "wildfires_fig-4.csv",
      source_sha256   = file_sha256(f4_path),
      source_encoding = "UTF-8",
      data_source     = f4_meta$data_source,
      web_update      = f4_meta$web_update,
      unit            = f4_trend_unit,
      rows            = nrow(f4_trend),
      columns         = describe(
        f4_trend, "wildfires_burned_acreage_trend_by_state.csv",
        "Trend in annual burned acreage over 1984-2021, in acres per square mile of land area."
      )
    ),
    list(
      file            = "wildfires_burned_acreage_by_state.csv",
      figure          = "Figure 4",
      figure_title    = f4_meta$title,
      source_file     = "wildfires_fig-4.csv",
      source_sha256   = file_sha256(f4_path),
      source_encoding = "UTF-8",
      data_source     = f4_meta$data_source,
      web_update      = f4_meta$web_update,
      unit            = f4_annual_unit,
      rows            = nrow(f4_annual),
      columns         = describe(
        f4_annual, "wildfires_burned_acreage_by_state.csv",
        "Burned acreage in that state that year, in acres."
      )
    ),
    list(
      file            = "wildfires_burned_acreage_change_by_state.csv",
      figure          = "Figure 5",
      figure_title    = f5_meta$title,
      source_file     = "wildfires_fig-5.csv",
      source_sha256   = file_sha256(f5_path),
      source_encoding = "UTF-8",
      data_source     = f5_meta$data_source,
      web_update      = f5_meta$web_update,
      unit            = f5_meta$units,
      rows            = nrow(f5),
      columns         = describe(
        f5, "wildfires_burned_acreage_change_by_state.csv",
        "Change in average annual burned acreage between 1984-2002 and 2003-2021, in acres per square mile of land area. Negative values are decreases."
      )
    ),
    list(
      file            = "wildfires_monthly_burned_area.csv",
      figure          = "Figure 6",
      figure_title    = f6_meta$title,
      source_file     = "wildfires_fig-6.csv",
      source_sha256   = file_sha256(f6_path),
      source_encoding = "UTF-8-BOM",
      data_source     = f6_meta$data_source,
      web_update      = f6_meta$web_update,
      unit            = f6_meta$units,
      rows            = nrow(f6),
      columns         = describe(
        f6, "wildfires_monthly_burned_area.csv",
        "Average burned area for that month over that period, in millions of acres per year."
      )
    ),
    list(
      file            = "wildfires_monthly_burned_area_by_region.csv",
      figure          = "Figure 7",
      figure_title    = f7_meta$title,
      source_file     = "wildfires_fig-7.csv",
      source_sha256   = file_sha256(f7_path),
      source_encoding = "UTF-8-BOM",
      data_source     = f7_meta$data_source,
      web_update      = f7_meta$web_update,
      unit            = f7_meta$units,
      rows            = nrow(f7),
      columns         = describe(
        f7, "wildfires_monthly_burned_area_by_region.csv",
        "Average burned area for that month over that period, in millions of acres per year, for that half of the country."
      )
    )
  )
)

write_yaml_stable(meta, file.path(out_dir, "meta.yml"))

# ---- Verify what was written -------------------------------------------------

written <- list.files(out_dir, pattern = "[.](csv|yml)$", full.names = TRUE)
invisible(lapply(written, assert_clean_output))

cat("\nWrote:\n")
for (p in written) {
  cat(sprintf("  %-46s %8d bytes  %s\n", basename(p), file.size(p), substr(file_sha256(p), 1, 12)))
}
