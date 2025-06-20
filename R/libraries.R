##############################################################################
# LOCAL PARTITIONS MULTI-LABEL CLASSIFICATION                                #
# Copyright (C) 2025                                                         #
#                                                                            #
# This code is free software: you can redistribute it and/or modify it under #
# the terms of the GNU General Public License as published by the Free       #
# Software Foundation, either version 3 of the License, or (at your option)  #
# any later version. This code is distributed in the hope that it will be    #
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of     #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General   #
# Public License for more details.                                           #
#                                                                            #
# 1 - Prof PhD Elaine Cecilia Gatto                                          #
# 2 - Prof PhD Ricardo Cerri                                                 #
# 3 - Prof PhD Mauri Ferrandin                                               #
# 4 - Prof PhD Celine Vens                                                   #
# 5 - PhD Felipe Nakano Kenji                                                #
# 6 - Prof PhD Jesse Read                                                    #
#                                                                            #
# 1 = Federal University of São Carlos - UFSCar - https://www2.ufscar.br     #
# Campus São Carlos | Computer Department - DC - https://site.dc.ufscar.br | #
# Post Graduate Program in Computer Science - PPGCC                          # 
# http://ppgcc.dc.ufscar.br | Bioinformatics and Machine Learning Group      #
# BIOMAL - http://www.biomal.ufscar.br                                       # 
#                                                                            # 
# 1 = Federal University of Lavras - UFLA                                    #
#                                                                            # 
# 2 = State University of São Paulo - USP                                    #
#                                                                            # 
# 3 - Federal University of Santa Catarina Campus Blumenau - UFSC            #
# https://ufsc.br/                                                           #
#                                                                            #
# 4 and 5 - Katholieke Universiteit Leuven Campus Kulak Kortrijk Belgium     #
# Medicine Department - https://kulak.kuleuven.be/                           #
# https://kulak.kuleuven.be/nl/over_kulak/faculteiten/geneeskunde            #
#                                                                            #
# 6 - Ecole Polytechnique | Institut Polytechnique de Paris | 1 rue Honoré   #
# d’Estienne d’Orves - 91120 - Palaiseau - FRANCE                            #
#                                                                            #
##############################################################################


# -----------------------------------------------------------------------------
# AUTO-INSTALL AND LOAD REQUIRED PACKAGES FOR MULTI-LABEL SCRIPT (v2025)
# -----------------------------------------------------------------------------

# Load required library
if (!require("here", quietly = TRUE)) install.packages("here", dependencies = TRUE)
library(here)

# Define root folder (optional, from original script)
FolderRoot <- here::here()
FolderScripts <- here::here("R")

# -----------------------------------------------------------------------------
# List of required packages
# -----------------------------------------------------------------------------

cran_packages <- c(
  "foreign", "stringr", "parallel", "rJava", "RWeka", "utiml",
  "mldr", "foreach", "doParallel", "tidyverse", "magrittr","Matrix"
)

base_packages <- c("parallel")

# If any GitHub packages are needed later, define them here
github_packages <- list(
  # Example: "somepkg" = "user/repo"
)

# -----------------------------------------------------------------------------
# Install CRAN package if missing
# -----------------------------------------------------------------------------
install_cran_package <- function(pkg) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    message(paste("Installing CRAN package:", pkg))
    tryCatch({
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE, quietly = TRUE)
      message(paste("✅ Package", pkg, "successfully installed."))
    }, error = function(e) {
      message(paste("❌ Error installing package", pkg, ":", e$message))
    })
  } else {
    message(paste("✅ Package", pkg, "is already installed."))
  }
}

# -----------------------------------------------------------------------------
# Install GitHub package if missing
# -----------------------------------------------------------------------------
install_github_package <- function(pkg, repo) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    if (!require("devtools", character.only = TRUE, quietly = TRUE)) {
      install.packages("devtools")
      library(devtools, quietly = TRUE)
    }
    message(paste("Installing GitHub package:", pkg))
    tryCatch({
      devtools::install_github(repo)
      library(pkg, character.only = TRUE, quietly = TRUE)
      message(paste("✅ Package", pkg, "successfully installed from GitHub."))
    }, error = function(e) {
      message(paste("❌ Error installing GitHub package", pkg, ":", e$message))
    })
  } else {
    message(paste("✅ Package", pkg, "is already installed."))
  }
}

# -----------------------------------------------------------------------------
# Load base packages (no install needed)
# -----------------------------------------------------------------------------
for (pkg in base_packages) {
  library(pkg, character.only = TRUE, quietly = TRUE)
  message(paste("✅ Base package", pkg, "loaded."))
}

# -----------------------------------------------------------------------------
# Install and load CRAN packages
# -----------------------------------------------------------------------------
for (pkg in cran_packages) {
  install_cran_package(pkg)
}

# -----------------------------------------------------------------------------
# Install and load GitHub packages (if any)
# -----------------------------------------------------------------------------
for (pkg in names(github_packages)) {
  install_github_package(pkg, github_packages[[pkg]])
}

message("🎉 All packages have been successfully verified and loaded!")



##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
