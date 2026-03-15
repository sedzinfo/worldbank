##########################################################################################
# DATA DOCUMENTATION
##########################################################################################
#' World Bank Indicators Dataset
#'
#' A cleaned dataset of key indicators from the World Bank for various countries across years.
#'
#' @format A data frame with one row per country-year-indicator combination:
#' \describe{
#'   \item{Country Code}{3-letter ISO country code (e.g., "ABW" for Aruba)}
#'   \item{Country Name}{Full country name (e.g., "Aruba")}
#'   \item{Indicator Name}{The name of the World Bank indicator (e.g., "School enrollment, primary, female (% gross)")}
#'   \item{Year}{Observation year}
#'   \item{value}{Numeric value for the indicator in that country and year}
#' }
#'
#' @details This dataset supports multiple development indicators (social, economic, demographic),
#' covering multiple years and countries. It is used across various tabs in the World Bank Shiny app
#' for data visualization.
#'
#' @source World Bank Open Data via [worldbank.org](https://data.worldbank.org)
"mfi"
##########################################################################################
# DATA DOCUMENTATION
##########################################################################################
#' Age-Sex Specific Population Percentages
#'
#' A dataset containing age- and sex-specific population percentages for countries, based on World Bank data.
#' Useful for creating population pyramids and analyzing demographic structures.
#'
#' @format A data frame with one row per country-year-age-sex group:
#' \describe{
#'   \item{Country Name}{Full country name (e.g., "Aruba")}
#'   \item{Indicator Name}{The full indicator name (e.g., "Population ages 65-69, female (% of female population)")}
#'   \item{Year}{Observation year}
#'   \item{value}{Percentage of population in the specified age-sex group}
#'   \item{age}{Age group (e.g., "65-69", "70-74")}
#'   \item{unit}{Unit of measurement ("Percent" or "Frequency")}
#'   \item{sex}{Sex of the population group ("Female", "Male", or "Total")}
#' }
#'
#' @details This dataset focuses on the percentage distribution of male and female populations across 5-year age groups.
#' It is suitable for demographic visualizations such as population pyramids.
#'
#' @source World Bank Open Data via [worldbank.org](https://data.worldbank.org)
"mfi_population"
##########################################################################################
# DATA DOCUMENTATION
##########################################################################################
#' Country Metadata (WDI Country Codes)
#'
#' Country-level metadata and classification fields from the World Bank country codes table.
#'
#' @format A data frame with one row per country/region code:
#' \describe{
#'   \item{Country Code}{3-letter World Bank / ISO-like country code}
#'   \item{Short Name}{Short country name used in visualizations}
#'   \item{Table Name}{Country name as shown in WDI tables}
#'   \item{Long Name}{Official long country name}
#'   \item{2-alpha code}{2-letter country code}
#'   \item{Region}{World Bank regional classification}
#'   \item{Income Group}{World Bank income-group classification}
#'   \item{...}{Additional source metadata columns from `WDICountry.csv`}
#' }
#'
#' @details This dataset is used to enrich and classify country-level observations in app visualizations.
#'
#' @source World Bank Open Data via [worldbank.org](https://data.worldbank.org)
"country_code"
