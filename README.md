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

# Alternative installation
Since the data range from 1960 onwards and there are thousands of indicators, we use git large file storage. Since the last update where the data file became larger than 100mb git will not accept directly so large files. As a result the traditional installation may not work.
An alternative installation is to use the code "generate_package.R" script after the whole repo is downloaded as a zip file and extracted in a local directory.

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
