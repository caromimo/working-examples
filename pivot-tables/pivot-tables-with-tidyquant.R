# Working example for making pivot tables
# This example is using the tidyquant library
# Note that this is NOT my work
# Source: https://www.youtube.com/watch?v=K5qR-EREf_g&t=26s

rm(list = ls())

# 1. Load libraries ----

library(tidyquant)
library(tidyverse)

# 2. Get stock data ----

data <- c("AAPL", "GOOG", "NFLX", "TSLA") %>%
  tq_get(from = "2010-01-01", to = "2020-12-31") %>%
  select(symbol, date, adjusted)

# 3. Basic pivot tables ----

pivot_table_by_year <- data %>%
  pivot_table(
    .rows = c(~ symbol, ~MONTH(date, label = TRUE)),
    .columns = ~ YEAR(date),
    .values = ~ MEDIAN(adjusted)
  ) %>%
  rename_at(.vars = 1:2, ~ c("Symbol", "Month"))

View(pivot_table_by_year)

pivot_table_by_stock <- data %>%
  pivot_table(
    .rows = c(~ YEAR(date), ~MONTH(date, label = TRUE)),
    .columns = ~ symbol,
    .values = ~ MEDIAN(adjusted)
  ) %>%
  rename_at(.vars = 1:2, ~ c("Year", "Month"))

View(pivot_table_by_stock)

pivot_table_by_month <- data %>%
  pivot_table(
    .columns = ~ MONTH(date, label = TRUE),
    .rows = c(~ YEAR(date), symbol),
    .values = ~ MEDIAN(adjusted)
  ) %>%
  rename_at(.vars = 1:2, ~ c("Year", "Stock"))

View(pivot_table_by_month)

# 4. Percent change by year tables ----

stock_performance_pivot_table <- data %>%
  pivot_table(
    .rows = ~ YEAR(date),
    .columns = ~ symbol,
    .values = round(~ PCT_CHANGE_FIRSTLAST(adjusted), 4)
  ) %>%
  rename_with(.cols = 1, ~"YEAR")

View(stock_performance_pivot_table)