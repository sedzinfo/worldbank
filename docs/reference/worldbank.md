# Launch World Bank Data Shiny App

Initializes and launches a Shiny application for visualizing World Bank
data. The app includes dynamic Plotly charts for comparing countries,
indicators, and demographic statistics across time.

## Usage

``` r
worldbank()
```

## Value

A running Shiny app in the default web browser.

## Details

This function:

- Loads required datasets: `mfi`, `country_code`, and `mfi_population`.

- Builds `mfi_cor` on the fly from selected indicators in `mfi`.

- Sets formatting options for numbers and fonts.

- Defines a helper function `format_bignum` for human-readable large
  numbers (e.g., K, M, Bn, Tn).

- Launches the Shiny app using `shinyApp(ui = ui, server = server)`.

The Shiny app interface includes:

- Country Comparison:

  Compare a selected indicator across countries.

- Indicator Comparison:

  Compare multiple indicators for one country.

- Population Pyramid:

  Visualize male/female population distribution.

- Barplot:

  Rank countries by a selected indicator.

- Scatterplot:

  Show relationship between two indicators.

- Map:

  Animated choropleth map by year.

- Index:

  Tabular view of the dataset.

## Note

Ensure that the datasets `mfi`, `country_code`, and `mfi_population` are
available in your environment or loaded via a package before calling
this function.

## Examples

``` r
# worldbank()
```
