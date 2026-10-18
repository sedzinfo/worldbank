# World Bank Indicators Dataset

A cleaned dataset of key indicators from the World Bank for various
countries across years.

## Usage

``` r
mfi
```

## Format

A data frame with one row per country-year-indicator combination:

- Country Code:

  3-letter ISO country code (e.g., "ABW" for Aruba)

- Country Name:

  Full country name (e.g., "Aruba")

- Indicator Name:

  The name of the World Bank indicator (e.g., "School enrollment,
  primary, female (% gross)")

- Year:

  Observation year

- value:

  Numeric value for the indicator in that country and year

## Source

World Bank Open Data via [worldbank.org](https://data.worldbank.org)

## Details

This dataset supports multiple development indicators (social, economic,
demographic), covering multiple years and countries. It is used across
various tabs in the World Bank Shiny app for data visualization.
