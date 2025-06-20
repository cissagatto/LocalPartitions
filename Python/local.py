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

import sys
import platform
import os
import io

import joblib

FolderRoot = os.path.expanduser('~/LocalPartitions/Python')
os.chdir(FolderRoot)
current_directory = os.getcwd()
sys.path.append('..')

import pickle
import time
import importlib

from joblib import dump
import pandas as pd
import numpy as np

from skmultilearn.problem_transform import BinaryRelevance
from sklearn.ensemble import RandomForestClassifier  

import evaluation as eval
importlib.reload(eval)
import measures as ms
importlib.reload(ms)

if __name__ == '__main__':
    
    train = pd.read_csv(sys.argv[1])
    valid = pd.read_csv(sys.argv[2])
    test = pd.read_csv(sys.argv[3])
    start = int(sys.argv[4])
    end = int(sys.argv[5])
    diretorio = sys.argv[6]    
    
    # juntando treino com validação
    train = pd.concat([train,valid],axis=0).reset_index(drop=True)

    # train = pd.read_csv("/tmp/lr-emotions/Dataset/emotions/CrossValidation/Tr/emotions-Split-Tr-1.csv")
    # valid = pd.read_csv("/tmp/lr-emotions/Dataset/emotions/CrossValidation/Vl/emotions-Split-Vl-1.csv")
    # test = pd.read_csv("/tmp/lr-emotions/Dataset/emotions/CrossValidation/Ts/emotions-Split-Ts-1.csv")
    # start = 72
    # end = 78
    # diretorio = "/tmp/lr-emotions/Local/Split-1"
    
    print("\n\n%==============================================%")
    print("train: ", sys.argv[1])
    print("valid: ", sys.argv[2])
    print("test: ", sys.argv[3])
    print("start: ", sys.argv[4])
    print("directory: ", sys.argv[5])
    print("fold: ", sys.argv[6])
    print("%==============================================%\n\n")
    
    # treino: separando os atributos e os rótulos
    X_train = train.iloc[:, :start]    # atributos 
    Y_train = train.iloc[:, start:]    # rótulos 
    
    # teste: separando os atributos e os rótulos
    X_test = test.iloc[:, :start]    # atributos 
    Y_test = test.iloc[:, start:]    # rótulos 
    
    # obtendo os nomes dos rótulos
    labels_y_train = list(Y_train.columns)
    labels_y_test = list(Y_test.columns)
    
    # obtendo os nomes dos atributos
    attr_x_train = list(X_train.columns)
    attr_x_test = list(X_test.columns)
    
    # parametros do classificador base
    random_state = 1234    
    n_estimators = 200
    baseModel = RandomForestClassifier(n_estimators = n_estimators, random_state = random_state)
    classifier = BinaryRelevance(baseModel)
    
    start_train_time = time.time()
    classifier.fit(X_train, Y_train)
    end_train_time = time.time()
    training_time = end_train_time - start_train_time  
    
    start_test_time = time.time()
    binary_predictions = classifier.predict(X_test.values)
    end_test_time = time.time()
    testing_time_bin = end_test_time - start_test_time
    
    start_test_time = time.time()
    probabilities = classifier.predict_proba(X_test.values)
    end_test_time = time.time()
    testing_time_proba = end_test_time - start_test_time
    
    true = (diretorio + "/y_true.csv")
    pred = (diretorio + "/y_pred_bin.csv")
    proba = (diretorio + "/y_pred_proba.csv")
    
    test[labels_y_test].to_csv(true, index=False)
    
    binary_predictions_2 = binary_predictions.toarray()
    binary_predictions_2 = pd.DataFrame(binary_predictions_2)
    binary_predictions_2.columns = labels_y_test
    binary_predictions_2.to_csv(pred, index=False)
    
    probabilities_2 = probabilities.toarray()
    probabilities_2 = pd.DataFrame(probabilities_2)
    probabilities_2.columns = labels_y_test
    probabilities_2.to_csv(proba, index=False)
    
    # print("\nCOMPUTE CURVES")
    res_curves = eval.multilabel_curves_measures(Y_test, probabilities_2)    
    name = (diretorio + "/results-python.csv") 
    res_curves.to_csv(name, index=False)
    
    # Prepare dataframe
    timing_data = [
        ["training_time", training_time],
        ["testing_time_bin", testing_time_bin],
        ["testing_time_proba", testing_time_proba]
    ]

    df_timing = pd.DataFrame(timing_data, columns=["Process", "Time (s)"])

    # Save to CSV
    name_csv = os.path.join(diretorio, "runtime-python.csv")
    df_timing.to_csv(name_csv, index=False)   

    # Measure pickle size in memory
    buffer_pickle = io.BytesIO()
    pickle.dump(classifier, buffer_pickle)
    size_pickle_bytes = buffer_pickle.tell()

    # Measure joblib size in memory
    buffer_joblib = io.BytesIO()
    joblib.dump(classifier, buffer_joblib)
    size_joblib_bytes = buffer_joblib.tell()

    # Prepare dataframe with only bytes
    model_sizes = [
        ["pickle", size_pickle_bytes],
        ["joblib", size_joblib_bytes]
    ]

    df_sizes = pd.DataFrame(model_sizes, columns=["Format", "Size (Bytes)"])

    # Save to CSV
    name_csv = os.path.join(diretorio, "model-sizes.csv")
    df_sizes.to_csv(name_csv, index=False)

    
