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


###############################################################################
# SET WORKSAPCE                                                               #
###############################################################################
library(here)
library(stringr)
FolderRoot <- here::here()
FolderScripts <- here::here("R")


# ###############################################################################
# #
# ###############################################################################
# intersection <- function(x, y){
#   return(sum(x == 1 & y == 1))
# }
# 
# # obtem a parte de baixo da matriz
# get.lower.tree <-function(matrix){
#   matrix[upper.tri(matrix)] <- 0
#   return(matrix)
# }
# 
# # obtem a parte de cima da matriz
# get.upper.tree <- function(matrix){
#   matrix[lower.tri(matrix)]<- 0
#   return(matrix)
# }
# 
# # constroi uma matriz de similaridade para ser preenchida
# build.similarity.matrix <- function(label.space, number.labels){
#   similarity.matrix <- matrix(nrow=number.labels, ncol=number.labels, data=0)
#   colnames(similarity.matrix) <- colnames(label.space)
#   rownames(similarity.matrix) <- colnames(label.space)
#   return(similarity.matrix)
# }
# 
# # calcula a frequencia entre pares de rótulos
# frequency.pair.labels <- function(label.space){
#   
#   retorno = list()
#   
#   res = map_dfr(.x = combn(names(label.space), 2, simplify = FALSE),
#                 ~ label.space %>%
#                   # select(.x) %>%
#                   select(all_of(.x)) %>%
#                   summarise(par_a = .x[1],
#                             par_b = .x[2],
#                             n = sum(rowSums(select(., everything()) == 1) == 2)))
#   names(res)[3] = "coocurrence"  
#   total = nrow(res)
#   
#   names.pairs = c("")
#   i = 1
#   while(i<=total){
#     a = toString(res$par_a[i])
#     b = toString(res$par_b[i])
#     names.pairs[i] = paste(a, " ", b, sep="")
#     i = i + 1
#     gc()
#   }
#   
#   retorno$frequency.pairs = res
#   retorno$total.pairs = total
#   retorno$names.pairs = names.pairs
#   return(retorno)
# }
# 
# 
# dependency <- function(label.space, number.labels){  
#   
#   retorno = list()
#   
#   ########################################################################################
#   pearson.matrix <- build.similarity.matrix(label.space, number.labels)
#   i = 1
#   j = 1
#   for (i in 1:number.labels){
#     for (j in 1:number.labels){
#       pearson.matrix[i,j] = cor(label.space[,i], label.space[,j],method = 'pearson')
#       gc()
#     }
#     gc()
#   }
#   
#   pearson.matrix.2 = abs(pearson.matrix)
#   
#   ########################################################################################
#   intersection.matrix <- build.similarity.matrix(label.space, number.labels)
#   i = 1
#   j = 1
#   for (i in 1:number.labels){
#     for (j in 1:number.labels){
#       intersection.matrix[i,j] = intersection(label.space[,i], label.space[,j])
#       gc()
#     }
#     gc()
#   }
#   
#   ############################################
#   fpl = frequency.pair.labels(label.space)        
#   
#   ############################################
#   pearson.matrix.2 = get.lower.tree(data.frame(pearson.matrix.2))    
#   intersection.matrix = get.lower.tree(data.frame(intersection.matrix))    
#   
#   ############################################
#   multiplica = pearson.matrix.2 * intersection.matrix
#   
#   ############################################
#   coluna = 1
#   linha = 2
#   cima = 0
#   baixo = 0
#   x=2
#   for(coluna in 1:(number.labels-1)){
#     for(linha in 2:number.labels){
#       if(linha > coluna){
#         cima = cima + multiplica[linha,coluna]
#         baixo = baixo + intersection.matrix[linha,coluna]
#       }
#       linha = linha + 1
#     } # fim for interno
#     coluna = coluna + 1
#     gc()
#   }
#   
#   dependency = cima / baixo
#   retorno$label.dependency = dependency
#   return(retorno)
#   
# }
# 
# 
# compute.label.dependecy <- function(parameters){
#   
#   final = data.frame(fold=0, dependency.label = 0)
#   f = 1 
#   while(f<=parameters$Config.File$Number.Folds){
#     cat("\nFold", f)
#     label.space = data.frame(parameters$LabelSpace$Classes[f])
#     res = dependency(label.space, parameters$Dataset.Info$Labels)
#     final = rbind(final, data.frame(fold = f, 
#                                     dependency.label = res$label.dependency))
#     f = f + 1
#     gc()
#   }
#   setwd(parameters$Directories$FolderLocal)
#   write.csv(final[-1,], "label_dependencies.csv", row.names = FALSE)
#   
#   return(res)
# }



###########################################
#
##########################################
compute.label.dependecy <- function(parameters) {
  final <- data.frame(fold = integer(), dependency.label = numeric())
  
  for (f in seq_len(parameters$Config.File$Number.Folds)) {
    cat("\nFold", f)
    
    label.space <- as.data.frame(parameters$LabelSpace$Classes[[f]])
    res <- dependency(label.space)
    
    final <- rbind(final, data.frame(fold = f, dependency.label = res$label.dependency))
  }
  
  # Salva CSV
  write.csv(final, file.path(parameters$Directories$FolderLocal, "label_dependencies.csv"), row.names = FALSE)
  
  return(final)
}


dependency <- function(label.space) {
  retorno <- list()
  
  label.space <- as(as.matrix(label.space), "dgCMatrix")
  
  pearson.matrix <- cor(as.matrix(label.space), method = "pearson")
  pearson.matrix[is.na(pearson.matrix)] <- 0
  
  intersection.matrix <- t(label.space) %*% label.space
  intersection.matrix <- as.matrix(intersection.matrix)
  
  pearson.abs <- abs(pearson.matrix)
  pearson.abs[upper.tri(pearson.abs)] <- 0
  intersection.matrix[upper.tri(intersection.matrix)] <- 0
  
  produto <- pearson.abs * intersection.matrix
  
  soma_produto <- sum(produto)
  soma_intersecoes <- sum(intersection.matrix)
  
  retorno$label.dependency <- if (soma_intersecoes > 0) soma_produto / soma_intersecoes else 0
  return(retorno)
}


###########################################
#
##########################################
labelSpace <- function(parameters){
  
  retorno = list()
  
  # return all fold label space
  classes = list()
  
  # from the first FOLD to the last
  k = 1
  while(k<=parameters$Config.File$Number.Folds){
    
    # get the correct fold cross-validation
    nome_arquivo = paste(parameters$Directories$FolderCVTR ,
                         "/", dataset_name, 
                         "-Split-Tr-", k, ".csv", sep="")
    
    # open the file
    arquivo = data.frame(read.csv(nome_arquivo))
    
    # split label space from input space
    classes[[k]] = arquivo[,ds$LabelStart:ds$LabelEnd]
    
    # get the names labels
    namesLabels = c(colnames(classes[[k]]))
    
    # increment FOLD
    k = k + 1 
    
    # garbage collection
    gc() 
    
  } # End While of the 10-folds
  
  # return results
  retorno$NamesLabels = namesLabels
  retorno$Classes = classes
  return(retorno)
  
  gc()
  cat("\n##########################################################")
  cat("\n# FUNCTION LABEL SPACE: END                              #") 
  cat("\n##########################################################")
  cat("\n\n\n\n")
}


###############################################################################
#' Convert CSV files to ARFF format using a Java converter
#'
#' @description
#' This function calls a Java JAR file (`R_csv_2_arff.jar`) to convert a CSV dataset
#' into an ARFF file format (used by Weka and other machine learning tools).
#' It builds the system command dynamically and executes it from within R.
#'
#' @details
#' The function assumes that the Java JAR converter (`R_csv_2_arff.jar`) is located
#' in the folder specified by `FolderUtils`. The user must have Java properly installed
#' and accessible through the system PATH.
#'
#' @param arg1 Character. The path to the input CSV file to be converted.
#' @param arg2 Character. The path or name of the output ARFF file to be generated.
#' @param arg3 Character. Additional parameters to be passed to the Java converter.
#' @param FolderUtils Character. The directory containing the `R_csv_2_arff.jar` file.
#'
#' @return
#' The function prints the result of the system command execution to the console.
#' It does not return any R object (invisible return of `NULL`).
#'
#' @examples
#' \dontrun{
#' # Example usage:
#' FolderUtils <- "/home/user/utils"
#' input_csv <- "/home/user/data/sample.csv"
#' output_arff <- "/home/user/data/sample.arff"
#'
#' converteArff(input_csv, output_arff, "", FolderUtils)
#' }
#'
#' @author Elaine Cecília Gatto - Cissa
#'
#' @seealso
#' [system()] for executing system commands in R,
#' [paste()] for string concatenation.
#'
#' @note
#' Make sure Java is installed and available in your system environment.
#' The JAR file `R_csv_2_arff.jar` must exist in the specified `FolderUtils` directory.
#'
#' @export
converteArff <- function(arg1, arg2, arg3, FolderUtils){  
  str = paste("java -jar ", FolderUtils,  "/R_csv_2_arff.jar ", 
              arg1, " ", arg2, " ", arg3, sep="")
  print(system(str))
  cat("\n\n")  
}


###############################################################################
#
###############################################################################
directories <- function(parameters){
  
  retorno = list()
  
  #############################################################################
  # RESULTS FOLDER:                                                           #
  # Parameter from command line. This folder will be delete at the end of the #
  # execution. Other folder is used to store definitely the results.          #
  # Example: "/dev/shm/result"; "/scratch/result"; "/tmp/result"              #
  #############################################################################
  folderResults = parameters$Config.File$Folder.Results
  if(dir.exists(parameters$Config.File$Folder.Results) == TRUE){
    setwd(folderResults)
    dir_folderResults = dir(folderResults)
    n_folderResults = length(dir_folderResults)
  } else {
    dir.create(folderResults)
    setwd(folderResults)
    dir_folderResults = dir(folderResults)
    n_folderResults = length(dir_folderResults)
  }
  retorno$FolderResults = parameters$Config.File$Folder.Results
  
  
  
  #############################################################################
  #
  #############################################################################
  folderScripts = parameters$Config.File$FolderScripts
  if(dir.exists(parameters$Config.File$FolderScripts) == TRUE){
    setwd(folderScripts)
    dir_folderScripts = dir(folderScripts)
    n_folderScripts = length(dir_folderScripts)
  } else {
    dir.create(folderScripts)
    setwd(folderScripts)
    dir_folderScripts= dir(folderScripts)
    n_folderScripts = length(dir_folderScripts)
  }
  retorno$folderScripts = parameters$Config.File$folderScripts
  
  
  
  #############################################################################
  #
  #############################################################################
  folderUtils = paste(FolderRoot, "/Utils", sep="")
  if(dir.exists(folderUtils) == TRUE){
    setwd(folderUtils)
    dir_folderUtils = dir(folderUtils)
    n_folderUtils = length(dir_folderUtils)
  } else {
    dir.create(folderUtils)
    setwd(folderUtils)
    dir_folderUtils = dir(folderUtils)
    n_folderUtils = length(dir_folderUtils)
  }
  retorno$FolderUtils = folderUtils
  
  
  #############################################################################
  #
  #############################################################################
  folderPython = paste(FolderRoot, "/Python", sep="")
  if(dir.exists(folderPython ) == TRUE){
    setwd(folderPython )
    dir_folderPython = dir(folderPython )
    n_folderPython = length(dir_folderPython )
  } else {
    dir.create(folderPython)
    setwd(folderPython )
    dir_folderPython = dir(folderPython )
    n_folderPython = length(dir_folderPython )
  }
  retorno$folderPython = folderPython
  
  #############################################################################
  #
  #############################################################################
  folderReports = paste(FolderRoot, "/Reports", sep="")
  if(dir.exists(folderReports  ) == TRUE){
    setwd(folderReports  )
    dir_folderReports = dir(folderReports )
    n_folderReports = length(dir_folderReports )
  } else {
    dir.create(folderReports)
    setwd(folderReports  )
    dir_folderReports = dir(folderReports )
    n_folderReports = length(dir_folderReports )
  }
  retorno$folderReports = folderReports
  
  
  ###############################################################################
  #
  ###############################################################################
  folderLocal = paste(folderResults, "/Local", sep="")
  if(dir.exists(folderLocal) == TRUE){
    setwd(folderLocal)
    dir_folderLocal = dir(folderLocal)
    n_folderLocal = length(dir_folderLocal)
  } else {
    dir.create(folderLocal)
    setwd(folderLocal)
    dir_folderLocal = dir(folderLocal)
    n_folderLocal = length(dir_folderLocal)
  }
  retorno$FolderLocal = folderLocal
  
  
  ###############################################################################
  #
  ###############################################################################
  folderDataset = paste(folderResults, "/Dataset", sep="")
  if(dir.exists(folderDataset) == TRUE){
    setwd(folderDataset)
    dir_folderDataset = dir(folderDataset)
    n_folderDataset = length(dir_folderDataset)
  } else {
    dir.create(folderDataset)
    setwd(folderDataset)
    dir_folderDataset = dir(folderDataset)
    n_folderDataset = length(dir_folderDataset)
  }
  retorno$FolderDataset = folderDataset
  
  
  ###############################################################################
  #
  ###############################################################################
  folderDatasetX = paste(folderDataset, "/", dataset_name, sep="")
  if(dir.exists(folderDatasetX) == TRUE){
    setwd(folderDatasetX)
    dir_folderDatasetX = dir(folderDatasetX)
    n_folderDatasetX = length(dir_folderDatasetX)
  } else {
    dir.create(folderDatasetX)
    setwd(folderDatasetX)
    dir_folderDatasetX = dir(folderDatasetX)
    n_folderDatasetX = length(dir_folderDatasetX)
  }
  retorno$FolderDatasetX = folderDatasetX
  
  
  ###############################################################################
  #
  ###############################################################################
  folderCV = paste(folderDatasetX, "/CrossValidation", sep="")
  if(dir.exists(folderCV) == TRUE){
    setwd(folderCV)
    dir_folderCV = dir(folderCV)
    n_folderCV = length(dir_folderCV)
  } else {
    dir.create(folderCV)
    setwd(folderCV)
    dir_folderCV = dir(folderCV)
    n_folderCV = length(dir_folderCV)
  }
  retorno$FolderCV = folderCV
  
  
  ###############################################################################
  #
  ###############################################################################
  folderCVTR = paste(folderCV, "/Tr", sep="")
  if(dir.exists(folderCVTR) == TRUE){
    setwd(folderCVTR)
    dir_folderCVTR = dir(folderCVTR)
    n_folderCVTR = length(dir_folderCVTR)
  } else {
    dir.create(folderCVTR)
    setwd(folderCVTR)
    dir_folderCVTR = dir(folderCVTR)
    n_folderCVTR = length(dir_folderCVTR)
  }
  retorno$FolderCVTR = folderCVTR
  
  
  ###############################################################################
  #
  ###############################################################################
  folderCVTS = paste(folderCV, "/Ts", sep="")
  if(dir.exists(folderCVTS) == TRUE){
    setwd(folderCVTS)
    dir_folderCVTS = dir(folderCVTS)
    n_folderCVTS = length(dir_folderCVTS)
  } else {
    dir.create(folderCVTS)
    setwd(folderCVTS)
    dir_folderCVTS = dir(folderCVTS)
    n_folderCVTS = length(dir_folderCVTS)
  }
  retorno$FolderCVTS = folderCVTS
  
  
  ###############################################################################
  #
  ###############################################################################
  folderCVVL = paste(folderCV, "/Vl", sep="")
  if(dir.exists(folderCVVL) == TRUE){
    setwd(folderCVVL)
    dir_folderCVVL = dir(folderCVVL)
    n_folderCVVL = length(dir_folderCVVL)
  } else {
    dir.create(folderCVVL)
    setwd(folderCVVL)
    dir_folderCVVL = dir(folderCVVL)
    n_folderCVVL = length(dir_folderCVVL)
  }
  retorno$FolderCVVL = folderCVVL
  
  ###############################################################################
  #
  ###############################################################################
  folderLabelSpace = paste(folderDatasetX, "/LabelSpace", sep="")
  if(dir.exists(folderLabelSpace) == TRUE){
    setwd(folderLabelSpace)
    dir_folderLabelSpace = dir(folderLabelSpace)
    n_folderLabelSpace = length(dir_folderLabelSpace)
  } else {
    dir.create(folderLabelSpace)
    setwd(folderLabelSpace)
    dir_folderLabelSpace = dir(folderLabelSpace)
    n_folderLabelSpace = length(dir_folderLabelSpace)
  }
  retorno$FolderLabelSpace = folderLabelSpace
  
  
  ###############################################################################
  #
  ###############################################################################
  folderNamesLabels = paste(folderDatasetX, "/NamesLabels", sep="")
  if(dir.exists(folderNamesLabels) == TRUE){
    setwd(folderNamesLabels)
    dir_folderNamesLabels = dir(folderNamesLabels)
    n_folderNamesLabels = length(dir_folderNamesLabels)
  } else {
    dir.create(folderNamesLabels)
    setwd(folderNamesLabels)
    dir_folderNamesLabels = dir(folderNamesLabels)
    n_folderNamesLabels = length(dir_folderNamesLabels)
  }
  retorno$FolderNamesLabels = folderNamesLabels
  
  
  ############################################################################
  return(retorno)
  gc()
  
}



##############################################################################
# 
##############################################################################
infoDataSet <- function(dataset){
  retorno = list()
  retorno$id = dataset$ID
  retorno$name = dataset$Name
  retorno$instances = dataset$Instances
  retorno$inputs = dataset$Inputs
  retorno$labels = dataset$Labels
  retorno$LabelsSets = dataset$LabelsSets
  retorno$single = dataset$Single
  retorno$maxfreq = dataset$MaxFreq
  retorno$card = dataset$Card
  retorno$dens = dataset$Dens
  retorno$mean = dataset$Mean
  retorno$scumble = dataset$Scumble
  retorno$tcs = dataset$TCS
  retorno$attStart = dataset$AttStart
  retorno$attEnd = dataset$AttEnd
  retorno$labStart = dataset$LabelStart
  retorno$labEnd = dataset$LabelEnd
  return(retorno)
  gc()
}



#########################################################################################################
#' Evaluate multilabel classification results and save performance metrics
#'
#' @description
#' This function performs multilabel model evaluation by computing confusion matrices
#' and derived performance measures. It saves the main evaluation results to CSV files
#' for further analysis and reporting.
#'
#' @details
#' The function uses `multilabel_confusion_matrix()` to generate per-label confusion
#' matrices from the true and predicted multilabel sets. Then, it computes overall
#' evaluation metrics using `multilabel_evaluate()` and organizes the results in
#' structured tables. Summary information, including true/false positives and negatives,
#' is saved in CSV format.
#'
#' @param f Integer or character. Identifier for the current fold (used in cross-validation).
#' It is appended to column names in the output.
#' @param y_true Data frame or list. Ground truth labels for the multilabel task.
#' Must contain one column per label.
#' @param y_pred Data frame or list. Predicted labels with the same structure as `y_true`.
#' @param salva Character. Directory path where result files will be saved.
#' @param nome Character. Base name used to name the output CSV files.
#'
#' @return
#' This function writes the following files to disk:
#' \itemize{
#'   \item `<nome>.csv` — evaluation metrics for the given fold.
#'   \item `<nome>-utiml.csv` — detailed confusion matrix statistics (optional, currently commented).
#' }
#' The function does not return an object in R (invisible `NULL`).
#'
#' @examples
#' \dontrun{
#' # Example: evaluating multilabel predictions for one fold
#' y_true <- data.frame(L1 = c(1,0,1,0), L2 = c(0,1,1,0))
#' y_pred <- data.frame(L1 = c(1,0,0,0), L2 = c(1,1,0,0))
#' output_dir <- "results"
#' dir.create(output_dir, showWarnings = FALSE)
#'
#' avaliacao(f = 1, y_true = y_true, y_pred = y_pred,
#'           salva = output_dir, nome = "Fold1_results")
#' }
#'
#' @author Elaine Cecília Gatto - Cissa
#'
#' @seealso
#' [multilabel_confusion_matrix()], [multilabel_evaluate()],
#' [write.csv()] for saving structured outputs.
#'
#' @note
#' The helper functions `multilabel_confusion_matrix()` and `multilabel_evaluate()`
#' must be available in the environment or loaded from the appropriate library.
#'
#' @export
avaliacao <- function(f, y_true, y_pred, salva, nome){
  
  #salva.0 = paste(salva, "/", nome, "-conf-mat.txt", sep="")
  #sink(file=salva.0, type="output")
  confmat = multilabel_confusion_matrix(y_true, y_pred)
  #print(confmat)
  #sink()
  
  resConfMat = multilabel_evaluate(confmat)
  resConfMat = data.frame(resConfMat)
  names(resConfMat) = paste("Fold-", f, sep="")
  Measure = rownames(resConfMat)
  resConfMat = data.frame(Measure, resConfMat)
  rownames(resConfMat) = NULL
  salva.1 = paste(salva, "/", nome, ".csv", sep="")
  write.csv(resConfMat, salva.1, row.names = FALSE)
  
  conf.mat = data.frame(confmat$TPl, confmat$FPl,
                        confmat$FNl, confmat$TNl)
  names(conf.mat) = c("TP", "FP", "FN", "TN")
  conf.mat.perc = data.frame(conf.mat/nrow(y_true$dataset))
  names(conf.mat.perc) = c("TP.perc", "FP.perc", "FN.perc", "TN.perc")
  wrong = conf.mat$FP + conf.mat$FN
  wrong.perc = wrong/nrow(y_true$dataset)
  correct = conf.mat$TP + conf.mat$TN
  correct.perc = correct/nrow(y_true$dataset)
  conf.mat.2 = data.frame(conf.mat, conf.mat.perc, wrong, correct, 
                          wrong.perc, correct.perc)
  salva.2 = paste(salva, "/", nome, "-utiml.csv", sep="")
  #write.csv(conf.mat.2, salva.2)
  
  
}


#########################################################################################################
#' Compute and export ROC curve evaluation for multilabel classification
#'
#' @description
#' This function evaluates the ROC (Receiver Operating Characteristic) metrics
#' for multilabel classification results and exports the computed metrics to a CSV file.
#' Optionally, the function can also plot and save the ROC curve (the plotting code
#' is currently commented out but preserved for reference).
#'
#' @details
#' The function uses \code{mldr_evaluate()} to compute performance metrics and
#' ROC-related statistics for multilabel models. The results are converted into a
#' clean data frame and saved to disk. If the ROC object is available, its AUC
#' (Area Under the Curve) is extracted and appended to the output.
#'
#' @param f Integer or character. Identifier of the fold being evaluated (used in cross-validation).
#' @param y_pred Data frame or list. Predicted label scores or probabilities from the model.
#' @param test Data frame or list. True labels for the test partition.
#' @param Folder Character. Directory path where output files (e.g., plots or CSVs) will be saved.
#' @param nome Character. The name of the output CSV file (including path if needed).
#'
#' @return
#' A CSV file is written to disk containing all evaluation metrics derived from
#' \code{mldr_evaluate()}, including (if available) the ROC AUC value.
#' The function does not return an R object (invisible \code{NULL}).
#'
#' @examples
#' \dontrun{
#' test <- data.frame(L1 = c(1, 0, 1, 0), L2 = c(0, 1, 1, 0))
#' y_pred <- data.frame(L1 = c(0.9, 0.2, 0.8, 0.3),
#'                      L2 = c(0.1, 0.7, 0.6, 0.4))
#' output_dir <- "results"
#' dir.create(output_dir, showWarnings = FALSE)
#'
#' roc.curve(f = 1, y_pred = y_pred, test = test,
#'           Folder = output_dir,
#'           nome = paste0(output_dir, "/fold1_roc.csv"))
#' }
#'
#' @author Elaine Cecília Gatto - Cissa
#'
#' @seealso
#' [mldr_evaluate()] for multilabel evaluation,
#' [plot()] for ROC curve visualization,
#' and [write.csv()] for saving structured metrics.
#'
#' @note
#' Ensure that the \code{mldr} package (or any library providing \code{mldr_evaluate})
#' is loaded in your environment. The commented ROC plotting section can be re-enabled
#' if graphical outputs are required.
#'
#' @export
roc.curve <- function(f, y_pred, test, Folder, nome){
  
  res = mldr_evaluate(test, y_pred)
  
  ###############################################################
  # PLOTANDO ROC CURVE
  #name = paste(Folder, "/roc.pdf", sep="")
  #pdf(name, width = 10, height = 8)
  #print(plot(res$roc, print.thres = 'best', print.auc=TRUE, 
  #            print.thres.cex=0.7, grid = TRUE, identity=TRUE,
  #            axes = TRUE, legacy.axes = TRUE, 
  #            identity.col = "#a91e0e", col = "#1161d5",
  #            main = paste("fold ", f, " ", nome, sep="")))
  #dev.off()
  #cat("\n")
  
  ###############################################################
  # Transformar a lista em data frame, removendo 'roc' para evitar problemas
  df_res <- res
  if("roc" %in% names(df_res)) df_res$roc <- NULL
  
  df_metrics <- data.frame(
    metric = names(df_res),
    value = unlist(df_res)
  )
  
  # Se quiser, também adiciona a AUC do objeto ROC
  if(!is.null(res$roc)) {
    df_metrics <- rbind(df_metrics, data.frame(
      metric = "roc_auc",
      value = res$roc$auc
    ))
  }
  
  colnames(df_metrics) = c("Measure", "Value")
  write.csv(df_metrics, nome, row.names = FALSE)
  
}



#' Compute and export AUPRC (Precision-Recall) metrics for multilabel classification
#'
#' @description
#' This function computes the AUPRC (Area Under the Precision-Recall Curve)
#' for each label in a multilabel classification problem. It also calculates
#' macro and micro AUPRC scores and exports the results as CSV files.
#' Optional plotting code for PR curves is included (commented out).
#'
#' @details
#' The function evaluates per-label and aggregated AUPRC metrics using
#' the \code{PRROC} package. For each label, a precision-recall curve is
#' generated when possible (skipping labels with only one class present).
#' It writes two CSV outputs:
#' \itemize{
#'   \item \code{r-auprc-per-label.csv}: AUPRC values for each label.
#'   \item A file specified by \code{nome}: macro and micro AUPRC scores.
#' }
#'
#' @param y_true Matrix or data frame. True binary labels (0 or 1) for each class.
#' @param y_proba Matrix or data frame. Predicted probabilities or confidence scores for each class.
#' @param Folder Character. Directory where output CSV files will be saved.
#' @param nome Character. The name of the main output CSV file containing macro and micro AUPRC values.
#'
#' @return
#' Two CSV files are written to disk:
#' \enumerate{
#'   \item \code{r-auprc-per-label.csv}: per-label AUPRC values.
#'   \item The file specified in \code{nome}: overall macro and micro AUPRC values.
#' }
#' The function does not return an R object (invisible \code{NULL}).
#'
#' @examples
#' \dontrun{
#' # Example data
#' y_true <- data.frame(
#'   L1 = c(1, 0, 1, 0),
#'   L2 = c(0, 1, 1, 0)
#' )
#' y_proba <- data.frame(
#'   L1 = c(0.9, 0.2, 0.8, 0.3),
#'   L2 = c(0.1, 0.7, 0.6, 0.4)
#' )
#'
#' # Output directory and filenames
#' Folder <- "results"
#' dir.create(Folder, showWarnings = FALSE)
#'
#' auprc.curve(y_true = y_true, y_proba = y_proba,
#'             Folder = Folder,
#'             nome = paste0(Folder, "/auprc-summary.csv"))
#' }
#'
#' @author Elaine Cecília Gatto - Cissa
#'
#' @seealso
#' [PRROC::pr.curve()] for PR curve and AUPRC computation,
#' [write.csv()] for saving structured metrics.
#'
#' @note
#' This function requires the \code{PRROC} package.
#' Labels with no positive or negative instances are skipped (AUPRC = NA).
#' The commented plotting code can be re-enabled to generate per-label
#' and global PR curve visualizations.
#'
#' @export
auprc.curve <- function(y_true, y_proba, Folder, nome){
  library(PRROC)
  
  # Garantindo que y_true e y_score sejam matrizes
  y_true <- as.matrix(y_true)
  y_score <- as.matrix(y_proba)
  
  auprc_list <- c()
  
  for(i in 1:ncol(y_true)){
    cat("\n", i)
    # Evita erro quando não houver positivos ou negativos
    if(sum(y_true[, i] == 1) == 0 | sum(y_true[, i] == 0) == 0) {
      auprc_list[i] <- NA
      next
    }
    
    pr_obj <- pr.curve(
      scores.class0 = y_score[y_true[, i] == 1, i],
      scores.class1 = y_score[y_true[, i] == 0, i],
      curve = TRUE
    )
    
    auprc_list[i] <- pr_obj$auc.integral
    
    #nome = paste("AUPRC-Label", i, ".pdf", sep="")
    #pdf(file = paste0(Folder, "/", nome), width = 8, height = 6)
    #plot(pr_obj, main = paste("PR Curve label", i))
    #dev.off()
  }
  
  auprc_per_labels = data.frame(t(auprc_list))
  colnames(auprc_per_labels) = colnames(y_true)
  nome1 = paste(Folder, "/r-auprc-per-label.csv", sep="")
  write.csv(auprc_per_labels, nome1, row.names = FALSE)
  
  # Macro AUPRC
  auprc_macro <- mean(auprc_list, na.rm = TRUE)
  
  # Micro AUPRC: achata tudo
  y_true_vec <- as.vector(y_true)
  y_score_vec <- as.vector(y_score)
  pr_micro <- pr.curve(
    scores.class0 = y_score_vec[y_true_vec == 1],
    scores.class1 = y_score_vec[y_true_vec == 0],
    curve = TRUE
  )
  auprc_micro <- pr_micro$auc.integral
  
  auprc = data.frame(auprc_micro, auprc_macro)
  auprc = data.frame(t(auprc))
  Measure = rownames(auprc)
  auprc = data.frame(Measure, auprc)
  rownames(auprc) = NULL
  colnames(auprc) = c("Measure", "Value")
  write.csv(auprc, nome, row.names = FALSE)
  
  # Salvar gráfico
  # pdf("PR_micro.pdf", width = 8, height = 6)
  # plot(pr_micro, main = "Micro-PR Curve (AUPRC Global)")
  # dev.off()
  
}






###############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                #
# Thank you very much!                                                        #
###############################################################################


