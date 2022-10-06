# worldbank
Worldbank data visualization

# Installation Instructions

install.packages("devtools")

library(devtools)

install_github("sedzinfo/worldbank")

# Usage

library(worldbank)

worldbank()

# Update data

In order to update the data you need to run the financial_indicators.R file and then rebuild the package using the generate_package.R script