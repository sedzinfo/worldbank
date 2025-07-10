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
#'   \item{Region}{World Bank regional classification (e.g., "Latin America & Caribbean")}
#'   \item{Country Name}{Full country name (e.g., "Aruba")}
#'   \item{Indicator Name}{The name of the World Bank indicator (e.g., "School enrollment, primary, female (% gross)")}
#'   \item{Year}{Observation year (numeric)}
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
#' Financial Indicators
#'
#' A dataset containing demographics
#'
#' \itemize{
#'   \item{Country Code}{3-letter ISO country code (e.g., "ABW" for Aruba)}
#'   \item{Region}{World Bank regional classification (e.g., "Latin America & Caribbean")}
#'   \item{Country Name}{Full country name (e.g., "Aruba")}
#'   \item{Year}{Observation year (numeric)}
#' }
#'
#' @source World Bank Open Data via [worldbank.org](https://data.worldbank.org)
"mfi_cor"
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
#'   \item{Year}{Observation year (numeric)}
#'   \item{value}{Percentage of population in the specified age-sex group}
#'   \item{age}{Age group (e.g., "65-69", "70-74")}
#'   \item{unit}{Unit of measurement (always "Percent")}
#'   \item{sex}{Sex of the population group ("Female" or "Male")}
#' }
#'
#' @details This dataset focuses on the percentage distribution of male and female populations across 5-year age groups. It is suitable for demographic visualizations such as population pyramids.
#'
#' @source World Bank Open Data via [worldbank.org](https://data.worldbank.org)
"mfi_population"
