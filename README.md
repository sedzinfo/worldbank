# worldbank
Worldbank data visualization

# Installation Instructions
## install R
installation instructions can be found here: https://cran.r-project.org/  
## install RStudio IDE (optional but a good idea)  
installation instructions can be found here: https://posit.co/downloads/  

open RStudio and type in the console:
```
install.packages("devtools")
library(devtools)
install_github("sedzinfo/worldbank")
```

Note: `install_github()` may fail for this repository because package data files are tracked with Git LFS and GitHub source tarballs can contain LFS pointer files instead of binary `.rda` data.

# Alternative installation
Since the data range from 1960 onwards and there are thousands of indicators, we use git large file storage. Since the last update where the data file became larger than 100mb git will not accept directly so large files. As a result the traditional installation may not work.
Use one of the following reliable options:

1. Clone the repository with Git LFS enabled and install locally:
```
git lfs install
git clone https://github.com/sedzinfo/worldbank.git
```
Then in R:
```
devtools::install_local("worldbank")
```

2. Download the full repository and regenerate package data locally by running `financial_indicators.R` and then `generate_package.R`.

# Usage
```
library(worldbank)
worldbank()
```

# Update data

In order to update the data:
1. run the financial_indicators.R script
2. run the generate_package.R script

The data updates almost yearly so there is no need for frequent updates

### Package Structure

```
worldbank/
├── R/                     # R functions
│   ├── data.R             # Data documentation
│   └── run_shiny.R        # Shiny app code
├── data/                  # Package datasets
│   ├── mfi.rda            # Main indicators
│   ├── country_code.rda   # Country metadata and classifications
│   ├── mfi_population.rda # Age/sex population dataset for pyramids
│   ├── WDICountry.csv     # Country metadata
│   └── WDICSV.csv         # Raw data
├── data-raw/              # Data processing scripts
├── man/                   # Documentation
└── screenshot/            # Application screenshots
```

## Features

- 📊 **Country Comparison**: Compare a selected indicator across multiple countries over time
- 📈 **Indicator Comparison**: Analyze multiple indicators for a specific country
- 👥 **Population Pyramids**: Visualize demographic structures by age and gender
- 📉 **Rankings**: Bar chart rankings of countries by selected indicators
- 🔍 **Scatterplots**: Explore relationships between two indicators
- 🗺️ **Animated Maps**: Interactive choropleth maps showing temporal changes
- 📋 **Data Explorer**: Browse the complete dataset in tabular format

## Data

The package includes World Bank indicators covering:
- Economic indicators (GDP, trade, inflation)
- Social indicators (education, health, employment)
- Demographic data (population by age and gender)
- Development metrics spanning from 1960 to present

Data source: [World Bank Open Data](https://data.worldbank.org)

# Screenshots

<img src="https://raw.githubusercontent.com/sedzinfo/worldbank/master/screenshot/worldbank1.png">
<img src="https://raw.githubusercontent.com/sedzinfo/worldbank/master/screenshot/worldbank2.png">
<img src="https://raw.githubusercontent.com/sedzinfo/worldbank/master/screenshot/worldbank3.png">
<img src="https://raw.githubusercontent.com/sedzinfo/worldbank/master/screenshot/worldbank4.png">
<img src="https://raw.githubusercontent.com/sedzinfo/worldbank/master/screenshot/worldbank5.png">
<img src="https://raw.githubusercontent.com/sedzinfo/worldbank/master/screenshot/worldbank6.png">
<img src="https://raw.githubusercontent.com/sedzinfo/worldbank/master/screenshot/worldbank7.png">

---

![Stars](https://img.shields.io/github/stars/sedzinfo/worldbank)
![Watchers](https://img.shields.io/github/watchers/sedzinfo/worldbank)
![Repo Size](https://img.shields.io/github/repo-size/sedzinfo/worldbank)
![Open Issues](https://img.shields.io/github/issues/sedzinfo/worldbank)
![Forks](https://img.shields.io/github/forks/sedzinfo/worldbank)
![Last Commit](https://img.shields.io/github/last-commit/sedzinfo/worldbank)
![Contributors](https://img.shields.io/github/contributors/sedzinfo/worldbank)
![License](https://img.shields.io/github/license/sedzinfo/worldbank)
![Release](https://img.shields.io/github/v/release/sedzinfo/worldbank)
![Workflow Status](https://img.shields.io/github/actions/workflow/status/sedzinfo/worldbank/main.yml)
