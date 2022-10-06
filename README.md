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

In order to update the data:
1. run the financial_indicators.R script
2. run the generate_package.R script

The data updates almost yearly so there is no need for frequent updates