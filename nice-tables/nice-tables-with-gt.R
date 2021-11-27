# Working example for making nice tables
# This example is using the gt library
# Note that this is NOT my work
# Source: https://www.youtube.com/watch?v=K5qR-EREf_g&t=26s

rm(list = ls())

# 1. Load libraries ----

library(tidyverse)
library(tidyquant)
library(gt) # package for nice tables
library(phantomjs) # to save the png 
# webshot::install_phantomjs()

# 2. Get stock data ----

data <- c("AAPL", "GOOG", "NFLX", "TSLA") %>%
  tq_get(from = "2010-01-01", to = "2020-12-31") %>%
  select(symbol, date, adjusted)

# 3. Percent change by year tables ----

stock_performance_pivot_table <- data %>%
  pivot_table(
    .rows = ~ YEAR(date),
    .columns = ~ symbol,
    .values = round(~ PCT_CHANGE_FIRSTLAST(adjusted), 4)
  ) %>%
  rename_with(.cols = 1, ~"YEAR")
  
# 4. Nice tables in png ----

color_fill <- "darkseagreen"

pivot_table_gt <- stock_performance_pivot_table %>%
  gt() %>%
  tab_header("Stock Returns", subtitle = md("_Technology Portfolio_")) %>%
  fmt_percent(columns = vars(AAPL, GOOG, NFLX, TSLA)) %>%
  tab_spanner(
    label = "Performance",
    columns = vars(AAPL, GOOG, NFLX, TSLA)
  ) %>%
  tab_source_note(
    source_note = md("_Data Source:_ Stock data retreived from Yahoo! Finance via tidyquant")
  ) %>%
  tab_style(
    style = list(
      cell_fill(color = color_fill),
      cell_text(weight = "bold", color = "white")
    ),
    locations = cells_body(
      columns = vars(AAPL),
      rows = AAPL >= 0)
    ) %>%
  tab_style(
    style = list(
      cell_fill(color = color_fill),
      cell_text(weight = "bold", color = "white")
    ),
    locations = cells_body(
      columns = vars(GOOG),
      rows = GOOG >= 0)
  ) %>%
  tab_style(
    style = list(
      cell_fill(color = color_fill),
      cell_text(weight = "bold", color = "white")
    ),
    locations = cells_body(
      columns = vars(NFLX),
      rows = NFLX >= 0)
  ) %>%
  tab_style(
    style = list(
      cell_fill(color = color_fill),
      cell_text(weight = "bold", color = "white")
    ),
    locations = cells_body(
      columns = vars(TSLA),
      rows = TSLA >= 0)
  )

pivot_table_gt

pivot_table_gt %>%
  gtsave(filename = "annual-stock-return.png")