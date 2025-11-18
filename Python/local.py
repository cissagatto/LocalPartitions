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

#FolderRoot = os.path.expanduser('~/LocalPartitions/Python')
#os.chdir(FolderRoot)
#current_directory = os.getcwd()
#sys.path.append('..')

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

    """
    train = pd.read_csv("/tmp/lr-GpositiveGO/Dataset/GpositiveGO/CrossValidation/Tr/GpositiveGO-Split-Tr-1.csv")
    valid = pd.read_csv("/tmp/lr-GpositiveGO/Dataset/GpositiveGO/CrossValidation/Vl/GpositiveGO-Split-Vl-1.csv")
    test = pd.read_csv("/tmp/lr-GpositiveGO/Dataset/GpositiveGO/CrossValidation/Ts/GpositiveGO-Split-Ts-1.csv")
    start = 912
    end = 916
    diretorio = "/tmp/lr-GpositiveGO/Local/Split-1"
    """
    
    train = pd.read_csv(sys.argv[1])
    valid = pd.read_csv(sys.argv[2])
    test = pd.read_csv(sys.argv[3])
    start = int(sys.argv[4])
    end = int(sys.argv[5])
    diretorio = sys.argv[6]    
    
    # juntando treino com validação
    train = pd.concat([train,valid],axis=0).reset_index(drop=True)    

    
    print("\n\n%==============================================%")
    #print("train: ", sys.argv[1])
    #print("valid: ", sys.argv[2])
    #print("test: ", sys.argv[3])
    #print("start: ", sys.argv[4])
    #print("end: ", sys.argv[5])
    print("directory: ", sys.argv[6])
    print("%==============================================%\n\n")
        
    # separa atributos e rótulos
    X_train = train.iloc[:, :start]
    Y_train = train.iloc[:, start:]
    X_test = test.iloc[:, :start]
    Y_test = test.iloc[:, start:]

    labels_y_test = list(Y_test.columns)

    Y_train_dense = np.array(Y_train)
    Y_test_dense = np.array(Y_test)

    # parâmetros do classificador base
    random_state = 1234
    n_estimators = 200
    baseModel = RandomForestClassifier(
        n_estimators=n_estimators, 
        random_state=random_state
    )
    
    classifier = BinaryRelevance(baseModel)
    #classifier = BinaryRelevance(classifier=baseModel, require_dense=[True, True])


    # ======= TREINO =======
    start_train_time = time.time()
    classifier.fit(X_train.values, Y_train.values)
    end_train_time = time.time()
    training = end_train_time - start_train_time
    
    
    # ======= PREDIÇÃO BINÁRIA =======
    start_test_time = time.time()
    binary_predictions = classifier.predict(X_test.values)    
    end_test_time = time.time()
    testing_bin = end_test_time - start_test_time


    # ======= PREDIÇÃO DE PROBABILIDADES =======
    start_test_time = time.time()    
    probas_list = classifier.predict_proba(X_test.values)
    end_test_time = time.time()
    testing_proba = end_test_time - start_test_time

    
    # ======= PEGANDO APENAS A PROBABILIDADE DE PERTENCER =======            
    probas_dense = probas_list.toarray()
    probas_df = pd.DataFrame(probas_dense, columns=Y_test.columns)
    binary_predictions_2 = binary_predictions.toarray()
    binary_df = pd.DataFrame(binary_predictions_2, columns=Y_test.columns)

    
    # ======= SALVANDO OS CSVS =======        
    true = os.path.join(diretorio, "y_true.csv")
    binary = os.path.join(diretorio, "y_pred_bin.csv")
    proba = os.path.join(diretorio, "y_pred_proba.csv")   
    test[labels_y_test].to_csv(true, index=False)    
    probas_df.to_csv(proba, index=False)
    binary_df.to_csv(binary, index=False)
    

    # ======= SAVE TIME =======    
    df_timing = pd.DataFrame([[        
        training,
        testing_bin,
        testing_proba
    ]], columns=["training", "testing_bin", "testing_proba"])
    df_timing.to_csv(os.path.join(diretorio, "runtime-python.csv"), index=False)

    
    # ======= SAVE MODEL SIZE =======
    model_buffer = io.BytesIO()
    pickle.dump(classifier, model_buffer)
    model_size_bytes = model_buffer.tell()
    pd.DataFrame({'size': [model_size_bytes]}).to_csv(
        os.path.join(diretorio, "model-size.csv"), index=False
    )

