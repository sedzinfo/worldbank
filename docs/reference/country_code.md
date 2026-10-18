# Country Metadata (WDI Country Codes)

Country-level metadata and classification fields from the World Bank
country codes table.

## Usage

``` r
country_code
```

## Format

A data frame with one row per country/region code:

- Country Code:

  3-letter World Bank / ISO-like country code

- Short Name:

  Short country name used in visualizations

- Table Name:

  Country name as shown in WDI tables

- Long Name:

  Official long country name

- 2-alpha code:

  2-letter country code

- Region:

  World Bank regional classification

- Income Group:

  World Bank income-group classification

- ...:

  Additional source metadata columns from `WDICountry.csv`

## Source

World Bank Open Data via [worldbank.org](https://data.worldbank.org)

## Details

This dataset is used to enrich and classify country-level observations
in app visualizations.
