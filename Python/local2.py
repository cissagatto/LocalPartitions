##############################################################################
# LOCAL PARTITIONS MULTI-LABEL CLASSIFICATION (Python 3.10+ compatible)
##############################################################################

import sys
import os
import io
import time
import pickle
import importlib
import pandas as pd
import numpy as np

from joblib import dump
from sklearn.ensemble import RandomForestClassifier
from sklearn.multioutput import MultiOutputClassifier

import measures as ms
importlib.reload(ms)

import evaluation as eval
importlib.reload(eval)


if __name__ == '__main__':

    train = pd.read_csv(sys.argv[1])
    valid = pd.read_csv(sys.argv[2])
    test = pd.read_csv(sys.argv[3])
    start = int(sys.argv[4])
    end = int(sys.argv[5])
    diretorio = sys.argv[6]

    """
    train = pd.read_csv("/tmp/lr-GpositiveGO/Dataset/GpositiveGO/CrossValidation/Tr/GpositiveGO-Split-Tr-1.csv")
    valid = pd.read_csv("/tmp/lr-GpositiveGO/Dataset/GpositiveGO/CrossValidation/Vl/GpositiveGO-Split-Vl-1.csv")
    test = pd.read_csv("/tmp/lr-GpositiveGO/Dataset/GpositiveGO/CrossValidation/Ts/GpositiveGO-Split-Ts-1.csv")
    start = 912
    end = 916
    diretorio = "/tmp/lr-GpositiveGO/Local/Split-1"
    """

    # junta treino e validação
    train = pd.concat([train, valid], axis=0).reset_index(drop=True)


    #print("\n\n%==============================================%")
    #print("directory: ", sys.argv[6])
    #print("%==============================================%\n\n")

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
        n_estimators=n_estimators, random_state=random_state
    )

    # substitui BinaryRelevance por MultiOutputClassifier (compatível com sklearn 1.2+)
    classifier = MultiOutputClassifier(baseModel)


    # ======= TREINO =======
    start_train_time = time.time()
    classifier.fit(X_train, Y_train)
    end_train_time = time.time()
    training_time = end_train_time - start_train_time


    # ======= VERIFICANDO SE TREINOU UM MODELO PARA CADA CLASSE
    # print(len(classifier.estimators_))  # deve ser igual a Y_train.shape[1]
    # for i, est in enumerate(classifier.estimators_[:4]):  # exibe os 5 primeiros
    #    print(f"Label {i}: modelo = {type(est).__name__}")


    # ======= PREDIÇÃO BINÁRIA =======
    start_test_time = time.time()
    binary_predictions = classifier.predict(X_test)
    binary_df = pd.DataFrame(binary_predictions, columns=labels_y_test)
    end_test_time = time.time()
    testing_time_bin = end_test_time - start_test_time


    # ======= PREDIÇÃO DE PROBABILIDADES =======
    start_test_time = time.time()    
    # MultiOutputClassifier retorna lista de arrays (um por rótulo)
    probas_list = classifier.predict_proba(X_test)
    end_test_time = time.time()
    testing_time_proba = end_test_time - start_test_time

    
    # ======= PEGANDO APENAS A PROBABILIDADE DE PERTENCER =======        
    # empilha as colunas de probabilidade de pertencer (classe 1)
    probabilities = np.array([p[:, 1] for p in probas_list]).T    
    # converte em dataframe
    probabilities_df = pd.DataFrame(probabilities, columns=labels_y_test)


    # ======= CONVERTENDO TODAS AS PREDIÇÕES =======    
    columns = []
    for cls in labels_y_test:
        columns.extend([f"{cls}_0", f"{cls}_1"])
    
    # Empilhando os arrays para ficar 2 colunas por classe
    probas_arrays = [np.hstack([p[:, 0].reshape(-1,1), p[:, 1].reshape(-1,1)]) for p in probas_list]

    # Concatenando todas as colunas
    all_probas = np.hstack(probas_arrays)

    # monta o dataframe
    probas_df = pd.DataFrame(all_probas, columns=columns)


    # ======= SALVANDO OS CSVS =======        
    true = os.path.join(diretorio, "y_true.csv")
    binary = os.path.join(diretorio, "y_pred_bin.csv")
    proba = os.path.join(diretorio, "y_pred_proba.csv")
    original = os.path.join(diretorio, "y_proba_original.csv")

    test[labels_y_test].to_csv(true, index=False)
    
    probabilities_df.to_csv(proba, index=False)
    binary_df.to_csv(binary, index=False)
    probas_df.to_csv(original, index=False)


    # ======= SAVE TIME =======    
    df_timing = pd.DataFrame([[        
        training_time,
        testing_time_bin,
        testing_time_proba
    ]], columns=["training", "testing_bin", "testing_proba"])
    df_timing.to_csv(os.path.join(diretorio, "runtime-python.csv"), index=False)

    # ======= SAVE MEASURES =======    
    metrics_df = eval.multilabel_curves_measures(Y_test, pd.DataFrame(probabilities, columns=labels_y_test))
    metrics_df.to_csv(os.path.join(diretorio, "results-python.csv"), index=False)

    #bipartition_df = eval.multilabel_bipartition_measures(Y_test, pd.DataFrame(probabilities, columns=labels_y_test))
    #bipartition_df.to_csv(os.path.join(diretorio, "bipartition-python.csv"), index=False)

    # ======= SAVE MODEL SIZE =======
    model_buffer = io.BytesIO()
    pickle.dump(classifier, model_buffer)
    model_size_bytes = model_buffer.tell()
    pd.DataFrame({'size': [model_size_bytes]}).to_csv(
        os.path.join(diretorio, "model-size.csv"), index=False
    )
