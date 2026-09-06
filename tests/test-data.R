# Regression checks on the generated data for the Wildfires indicator.
#
#   Rscript tests/test-data.R
#
# The checks below are shape-independent: they hold whatever the reshape in
# R/build_data.R turns each figure into. Value snapshots, which pin the actual
# numbers so a data update fails loudly instead of passing silently, are the
# TODO at the bottom.

setwd(here::here())
source("R/utils/write_stable.R")

# Keeps the dictionary check readable when a meta.yml field is absent altogether.
`%||%` <- function(a, b) if (is.null(a)) b else a

failures <- character()
check <- function(label, ok) {
  ok <- isTRUE(ok)
  cat(sprintf("  [%s] %s\n", if (ok) "PASS" else "FAIL", label))
  if (!ok) failures <<- c(failures, label)
  invisible(ok)
}

rd <- function(f) {
  readr::read_csv(file.path("data", f),
                  col_types = readr::cols(.default = readr::col_character()),
                  na = character(), progress = FALSE)
}

meta <- yaml::read_yaml("data/meta.yml")

cat("\nData dictionary\n")
# Eight, not seven: EPA's figure 4 CSV stacks a trend in acres per square mile
# on top of annual acreage in acres, and each unit gets its own file.
check("meta.yml documents 8 dataset(s)", length(meta$datasets) == 8L)
check("meta.yml has no timestamp",
      !any(grepl("\\d{4}-\\d{2}-\\d{2}T|Sys\\.time|generated_at",
                 readLines("data/meta.yml", warn = FALSE))))

for (ds in meta$datasets) {
  df   <- rd(ds$file)
  cols <- vapply(ds$columns, function(x) x$name, character(1))
  check(sprintf("%s: meta.yml lists the columns the file actually has", ds$file),
        identical(cols, names(df)))
  check(sprintf("%s: meta.yml row count matches the file", ds$file),
        identical(as.integer(ds$rows), nrow(df)))
  check(sprintf("%s: every column has a type and a description", ds$file),
        all(vapply(ds$columns, function(x) nzchar(x$type %||% "") && nzchar(x$description %||% ""), logical(1))))
  check(sprintf("%s: source file is still present and unchanged", ds$file),
        identical(file_sha256(file.path("data-raw", ds$source_file)), ds$source_sha256))
  check(sprintf("%s: no blank rows", ds$file), nrow(df) > 0L)
}

cat("\nFile hygiene\n")
for (f in list.files("data", pattern = "[.](csv|yml)$", full.names = TRUE)) {
  check(sprintf("%s is UTF-8, LF, no BOM, no mojibake", basename(f)),
        tryCatch({ assert_clean_output(f); TRUE },
                 error = function(e) { cat("      ", conditionMessage(e), "\n"); FALSE }))
}

cat("\nValue snapshots\n")
# The numbers below are EPA's, read off the source CSVs in data-raw/, not copied
# back out of data/. They are compared as strings: every one of them is
# reproduced at EPA's published precision, and a string comparison catches a
# rounding change that a numeric tolerance would wave through.
#
# A legitimate data update fails here. That is the point: read the FAIL line,
# confirm the new value against the new source file, then update the number.

#' @param rows     expected row count
#' @param first    the first row, whole, in the file's own order
#' @param last     the last row, whole
#' @param extrema  named list, one entry per value column: c(minimum, maximum)
snap <- function(file, rows, first, last, extrema) {
  df <- rd(file)
  check(sprintf("%s: %d rows", file, rows), identical(nrow(df), rows))
  check(sprintf("%s: first row unchanged", file),
        identical(unname(unlist(df[1, ], use.names = FALSE)), first))
  check(sprintf("%s: last row unchanged", file),
        identical(unname(unlist(df[nrow(df), ], use.names = FALSE)), last))
  for (nm in names(extrema)) {
    v <- df[[nm]]
    n <- suppressWarnings(as.numeric(v))
    check(sprintf("%s: %s min and max unchanged", file, nm),
          identical(c(v[which.min(n)], v[which.max(n)]), extrema[[nm]]))
  }
}

# Figure 1. 55 rows, not 80: NIFC reports all 40 years, the Forest Service series
# only its 15 (1983-1997), and the build drops the empty cells rather than
# carrying them as rows. The maximum is a Forest Service count, from 1988.
snap("wildfires_frequency.csv", 55L,
     c("1983", "nifc", "National Interagency Fire Center", "18229"),
     c("1997", "usfs", "Forest Service Wildfire Statistics", "89393"),
     list(value = c("18229", "154573")))

# Figure 2. Same 40 + 15 split. Maximum acreage is NIFC's 2015.
snap("wildfires_extent.csv", 55L,
     c("1983", "nifc", "National Interagency Fire Center", "1323666"),
     c("1997", "usfs", "Forest Service Wildfire Statistics", "3672616"),
     list(value = c("1148409", "10125149")))

# Figure 3. 38 years x 5 severity classes.
snap("wildfires_burn_severity.csv", 190L,
     c("1984", "low", "Low", "711517.381"),
     c("2021", "increased_greenness", "Increased greenness", "29433.95734"),
     list(value = c("6420.761483", "5175922.145")))

# Figure 4, trend half. One row per state, Iowa lowest, Idaho highest.
snap("wildfires_burned_acreage_trend_by_state.csv", 45L,
     c("AL", "0.063149789"),
     c("WY", "1.215852737"),
     list(value = c("0.001976346", "5.602974302")))

# Figure 4, annual half. 45 states x 38 years. The maximum is Alaska's 2004
# season; the minimum is a true zero, of which the file has many, so which.min()
# pins the first in file order rather than a unique row.
snap("wildfires_burned_acreage_by_state.csv", 1710L,
     c("AL", "1984", "0"),
     c("WY", "2021", "28327"),
     list(value = c("0", "6555388")))

# Figure 5. West Virginia fell the most, California rose the most.
snap("wildfires_burned_acreage_change_by_state.csv", 45L,
     c("Alabama", "0.040740525"),
     c("Wyoming", "-0.177441301"),
     list(value = c("-1.745922027", "4.166160847")))

# Figure 6. 12 months x 2 periods. December 1984-2002 lowest, July 2003-2021
# highest.
snap("wildfires_monthly_burned_area.csv", 24L,
     c("January", "early", "1984-2002", "0.011277263"),
     c("December", "late", "2003-2021", "0.040890684"),
     list(value = c("0.006277158", "1.788176105")))

# Figure 7. 12 months x 2 regions x 2 periods. Both extremes are December East
# 1984-2002 and July West 2003-2021.
snap("wildfires_monthly_burned_area_by_region.csv", 48L,
     c("January", "East", "early", "1984-2002", "0.002234421"),
     c("December", "West", "late", "2003-2021", "0.038902947"),
     list(value = c("0.001898632", "1.773265421")))

cat("\n")
if (length(failures)) {
  cat(sprintf("%d FAILED:\n", length(failures)))
  for (f in failures) cat("  -", f, "\n")
  quit(status = 1L)
}
cat("All data checks passed.\n")
