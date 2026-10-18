# Age-Sex Specific Population Percentages

A dataset containing age- and sex-specific population percentages for
countries, based on World Bank data. Useful for creating population
pyramids and analyzing demographic structures.

## Usage

``` r
mfi_population
```

## Format

A data frame with one row per country-year-age-sex group:

- Country Name:

  Full country name (e.g., "Aruba")

- Indicator Name:

  The full indicator name (e.g., "Population ages 65-69, female (% of
  female population)")

- Year:

  Observation year

- value:

  Percentage of population in the specified age-sex group

- age:

  Age group (e.g., "65-69", "70-74")

- unit:

  Unit of measurement ("Percent" or "Frequency")

- sex:

  Sex of the population group ("Female", "Male", or "Total")

## Source

World Bank Open Data via [worldbank.org](https://data.worldbank.org)

## Details

This dataset focuses on the percentage distribution of male and female
populations across 5-year age groups. It is suitable for demographic
visualizations such as population pyramids.
