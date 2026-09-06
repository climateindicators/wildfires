# Provenance

Every file in this directory is reproduced unmodified from EPA's published
indicator page and its per-figure data downloads. To update the data, replace the
file and rerun `Rscript R/build_data.R`.

## Indicator page

- `source-page.html`  \
  <https://19january2025snapshot.epa.gov/climate-indicators/climate-change-indicators-wildfires/index.html>  \
  sha256 `211de3db7a430ddf6774cbb871a2b51e526ca1fbe76ec25e4b6634fd337152ce`

Technical documentation: <https://19january2025snapshot.epa.gov/system/files/documents/2024-06/wildfires_documentation.pdf>

## Figure data

- `wildfires_fig-1.csv`  \
  <https://19january2025snapshot.epa.gov/system/files/other-files/2024-06/wildfires_fig-1.csv>  \
  sha256 `1b63039a77eee4c7c188c6ccbbf7d8c0cfa4e08a1a97fe543c5fd6bd140f729e`  \
  encoding UTF-8, 40 data rows, columns: `Year`, `National Interagency Fire Center`, `Forest Service Wildfire Statistics`  \
  title: Figure 1. Wildfire Frequency in the United States, 1983-2022  \
  data source: NIFC, 2024; USDA Forest Service, 2014; web update: June 2024; units: number of fires

- `wildfires_fig-2.csv`  \
  <https://19january2025snapshot.epa.gov/system/files/other-files/2024-06/wildfires_fig-2.csv>  \
  sha256 `a6054e278a8e37c27ace874ed9f63e6ae058c491dfe9cd19726853c044c8dff8`  \
  encoding UTF-8, 40 data rows, columns: `Year`, `National Interagency Fire Center`, `Forest Service Wildfire Statistics`  \
  title: Figure 2. Wildfire Extent in the United States, 1983-2022  \
  data source: NIFC, 2024; Short, 2015; web update: June 2024; units: acres

- `wildfires_fig-3.csv`  \
  <https://19january2025snapshot.epa.gov/system/files/other-files/2024-06/wildfires_fig-3.csv>  \
  sha256 `94b4ff6434489ed03aabed018471f057eafcf7d41944024f27385867ef018281`  \
  encoding UTF-8, 38 data rows, columns: `Year`, `Low`, `Moderate`, `High`, `Unburned`, `Increased greenness`  \
  title: Figure 3. Damage Caused by Wildfires in the United States, 1984-2021  \
  data source: MTBS, 2024; web update: June 2024; units: acres

- `wildfires_fig-4.csv`  \
  <https://19january2025snapshot.epa.gov/system/files/other-files/2024-06/wildfires_fig-4.csv>  \
  sha256 `35147acc27572909b963833ae85d264bc5c460e1abb7e49bf80e30212b4caa3d`  \
  encoding UTF-8, 39 data rows, columns: `Year/Trend`, `AL`, `AK`, `AZ`, `AR`, `CA`, `CO`, `DE`, `FL`, `GA`, `HI`, `ID`, `IN`, `IA`, `KS`, `KY`, `LA`, `ME`, `MD`, `MA`, `MI`, `MN`, `MS`, `MO`, `MT`, `NE`, `NV`, `NJ`, `NM`, `NY`, `NC`, `ND`, `OH`, `OK`, `OR`, `PA`, `SC`, `SD`, `TN`, `TX`, `UT`, `VA`, `WA`, `WV`, `WI`, `WY`  \
  title: Figure 4. Average Annual Burned Acreage by State, 1984-2021  \
  data source: MTBS, 2024; web update: June 2024; units: acres per square mile of land area (trend); acres (annual data)

- `wildfires_fig-5.csv`  \
  <https://19january2025snapshot.epa.gov/system/files/other-files/2024-06/wildfires_fig-5.csv>  \
  sha256 `df6cae8eb94f6ae8cf2306ca6dbe7f9dcfbfae636def89c8169fb93cb07495bb`  \
  encoding UTF-8, 45 data rows, columns: `State`, `Change in burned acreage`  \
  title: Figure 5. Change in Annual Burned Acreage by State Between 1984-2002 and 2003-2021  \
  data source: MTBS, 2024; web update: June 2024; units: acres per square mile of land area

- `wildfires_fig-6.csv`  \
  <https://19january2025snapshot.epa.gov/system/files/other-files/2024-06/wildfires_fig-6.csv>  \
  sha256 `2845031395c0b404b698ff655683df381376c588857b771600548125632b615c`  \
  encoding UTF-8-BOM, 12 data rows, columns: `Month`, `1984-2002`, `2003-2021`  \
  title: Figure 6. Comparison of Monthly Burned Area Due to Wildfires in the United States Between 1984–2002 and 2003–2021  \
  data source: MTBS, 2023; web update: June 2024; units: burned area (millions of acres per year)

- `wildfires_fig-7.csv`  \
  <https://19january2025snapshot.epa.gov/system/files/other-files/2024-06/wildfires_fig-7.csv>  \
  sha256 `5326d82e6fee79741760fe39ca66dd7d1139efeb5db5c0e69d97bcbaf7da1317`  \
  encoding UTF-8-BOM, 12 data rows, columns: `Month`, `East (1984-2002)`, `East (2003-2021)`, `West (1984-2002)`, `West (2003-2021)`  \
  title: Figure 7. Comparison of Monthly Burned Area Due to Wildfires in the Eastern and Western United States Between 1984-2002 and 2003-2021  \
  data source: MTBS, 2023; web update: June 2024; units: burned area (millions of acres per year)
