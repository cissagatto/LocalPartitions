# Local Partitions
This code is part of my PhD research at PPG-CC/DC/UFSCar in colaboration with Katholieke Universiteit Leuven Campus Kulak Kortrijk Belgium. The aim is build and test local partitions for multilabel classification.


## How to cite 
## How to Cite 📑
If you use this code in your research, please cite the following:

```bibtex
@misc{Gatto2025,
  author = {Gatto, E. C.},
  title = {Local Partitions for Multilabel Classification},
  year = {2025},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/cissagatto/LocalPartitions}}
}
```


## 🗂️ Project Structure

The codebase includes R and Python scripts that must be used together.

### R Scripts (in `/R` folder):

* `libraries.R`
* `utils.R`
* `local-clus.R` 
* `local-utiml.R`
* `local-mulan.R`
* `local-rf.R`
* `local.R`
* `run-clus.R`
* `run-rf.R`
* `run.R`
* `local.R`
* `config-files.R`
* `jobs.R`

### Python Scripts (in `/Python` folder):

* `confusion_matrix.py`
* `measures.py`
* `evaluation.py`
* `local.py`


**Note:** Random Forest is used for all global versions, except for CLUS (which is a PCT model).  
`global-mulan` and `global-utiml` are not yet implemented. 🔧


## ⚙️ How to Reproduce the Experiment


### Step 1 – Prepare the Dataset Metadata File
A file called `datasets-original.csv` should be placed in the **root project folder**. This file contains details for 90 multilabel datasets used in the code. To add a new dataset, include the following information in the file:

| Parameter    | Status    | Description                                           |
|------------- |-----------|-------------------------------------------------------|
| Id           | mandatory | Integer number to identify the dataset                |
| Name         | mandatory | Dataset name (please follow the benchmark)            |
| Domain       | optional  | Dataset domain                                        |
| Instances    | mandatory | Total number of dataset instances                     |
| Attributes   | mandatory | Total number of dataset attributes                    |
| Labels       | mandatory | Total number of labels in the label space             |
| Inputs       | mandatory | Total number of dataset input attributes              |
| Cardinality  | optional  | **                                                    |
| Density      | optional  | **                                                    |
| Labelsets    | optional  | **                                                    |
| Single       | optional  | **                                                    |
| Max.freq     | optional  | **                                                    |
| Mean.IR      | optional  | **                                                    | 
| Scumble      | optional  | **                                                    | 
| TCS          | optional  | **                                                    | 
| AttStart     | mandatory | Column number where the attribute space begins * 1    | 
| AttEnd       | mandatory | Column number where the attribute space ends          |
| LabelStart   | mandatory | Column number where the label space begins            |
| LabelEnd     | mandatory | Column number where the label space ends              |
| Distinct     | optional  | ** 2                                                  |
| xn           | mandatory | Value for Dimension X of the Kohonen map              | 
| yn           | mandatory | Value for Dimension Y of the Kohonen map              |
| gridn        | mandatory | X times Y value. Kohonen's map must be square         |
| max.neigbors | mandatory | The maximum number of neighbors is given by LABELS -1 |


1 - Because it is the first column the number is always 1.

2 - [Click here](https://link.springer.com/book/10.1007/978-3-319-41111-8) to get explanation about each property.



### STEP 2: Cross-Validation Files
The experiment requires pre-processed cross-validation files in `.tar.gz` format. You can download the 10-fold files for multilabel datasets [here](https://1drv.ms/u/s!Aq6SGcf6js1mrZJSkZ3VEJ217rEd5A?e=IH73m3).

For new datasets, you can generate these files by following the instructions in [this repository](https://github.com/cissagatto/crossvalidationmultilabel). After generating the files, place the `.tar.gz` archive in any directory, and provide the absolute path in the configuration file for the `global.R` script.


## STEP 3
Ensure that all necessary Java, R, and Python libraries are installed on your system. This code does not automatically install packages! 🚨

You can use the [Conda Environment](https://1drv.ms/u/s!Aq6SGcf6js1mw4hbhU9Raqarl8bH8Q?e=IA2aQs) that I created to perform this experiment. Below are the links to download the files. Try to use the command below to extract the environment to your computer:

```
conda env create -f Teste.yml
```

For more information on Conda environments, refer to the [official documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html).

Alternatively, you can run the code using an [AppTainer container](https://1drv.ms/u/s!Aq6SGcf6js1mw4hcVuz_IN8_Bh1oFQ?e=5NuyxX). Check the [tutorial](https://rpubs.com/cissagatto/apptainer-slurm-r) for setup instructions (in Portuguese).


### STEP 4: Configuration File ⚙️
To run this code you will need a configuration file saved in *csv* format and with the following information:

| Config         | Value                                                                     | 
|----------------|---------------------------------------------------------------------------| 
| FolderScripts  | Absolute path to the R folder scripts                                     |
| Dataset_Path   | Absolute path to the folder where the dataset's tar.gz is stored          |
| Temporary_Path | Absolute path to the folder where temporary processing will be performed* |
| Implemenation  | Must be one of "clus", "mulan", "python" or "utiml"                       |
| Dataset_Name   | Dataset name according to *dataset-original.csv* file                     |
| Number_Dataset | Dataset number according to *dataset-original.csv* file                   |
| Number_Folds   | Number of folds used in cross validation                                  |
| Number_Cores   | Number of cores for parallel processing                                   |

We recommend using directories like `/dev/shm`, `/tmp`, or `/scratch` for temporary storage.

For detailed instructions on configuration, refer to the example files.


## 🛠️ Software Requirements
This code was develop in RStudio 2024.12.0+467 "Kousa Dogwood" Release (cf37a3e5488c937207f992226d255be71f5e3f41, 2024-12-11) for Ubuntu Jammy Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) rstudio/2024.12.0+467 Chrome/126.0.6478.234 Electron/31.7.6 Safari/537.36, Quarto 1.5.57

- R version 4.5.0 (2025-04-11) -- "How About a Twenty-Six", Copyright (C) 2025 The R Foundation for Statistical Computing, Platform: x86_64-pc-linux-gnu
- Python 3.10
- Conda 24.11.3

## 💻 Hardware Recommendations
This code may or may not be executed in parallel, however, it is highly recommended that you run it in parallel. The number of cores can be configured via the command line (number_cores). If number_cores = 1 the code will run sequentially. In our experiments, we used 10 cores. For reproducibility, we recommend that you also use ten cores. This code was tested with the emotions dataset in the following machine:

- Linux 6.11.0-26-generic #26~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC x86_64 x86_64 x86_64 GNU/Linux
- Distributor ID: Ubuntu, Description: Ubuntu 24.04.2 LTS, Release: 24.04, Codename: noble
- Manufacturer: Acer, Product Name: Nitro ANV15-51, Version: V1.16, Wake-up Type: Power Switch, Family: Acer Nitro V 15

Then the experiment was executed in a cluster at UFSC (Federal University of Santa Catarina Campus Blumenau).


## RUN
To run the code, open the terminal, enter the */LocalPartitions/R/* folder, and type

```
Rscript local.R [absolute_path_to_config_file]
```

Example:

```
Rscript local.R "~/LocalPartitions/config-files/lp-GpositiveGO.csv"
```

## RESULTS
The results are stored in a folder called REPORTS (or output) in the project root.


## DOWNLOAD RESULTS

| [Clus](https://1drv.ms/u/s!Aq6SGcf6js1mrY0-nATefiTagEnPxA?e=q0laSK) | [Mulan](https://1drv.ms/u/s!Aq6SGcf6js1msssS5Mx91QF5odzzjQ?e=JXREoy) | [Python](https://1drv.ms/u/s!Aq6SGcf6js1mw4kRQhSBYhBhUQShQw?e=hLRYgc) | [Utiml](https://1drv.ms/u/s!Aq6SGcf6js1msssRME9OReqIOqKNug?e=8OHtOS) | 


## Acknowledgment
- This study was financed in part by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001.
- This study was financed in part by the Conselho Nacional de Desenvolvimento Científico e Tecnológico - Brasil (CNPQ) - Process number 200371/2022-3.
- The authors also thank the Brazilian research agencies FAPESP financial support.
- (Belgium ....)




## 📞 Contact
Elaine Cecília Gatto
✉️ [elainececiliagatto@gmail.com](mailto:elainececiliagatto@gmail.com)



## Links

| [Site](https://sites.google.com/view/professor-cissa-gatto) | [Post-Graduate Program in Computer Science](http://ppgcc.dc.ufscar.br/pt-br) | [Computer Department](https://site.dc.ufscar.br/) |  [Biomal](http://www.biomal.ufscar.br/) | [CNPQ](https://www.gov.br/cnpq/pt-br) | [Ku Leuven](https://kulak.kuleuven.be/) | [Embarcados](https://www.embarcados.com.br/author/cissa/) | [Read Prensa](https://prensa.li/@cissa.gatto/) | [Linkedin Company](https://www.linkedin.com/company/27241216) | [Linkedin Profile](https://www.linkedin.com/in/elainececiliagatto/) | [Instagram](https://www.instagram.com/cissagatto) | [Facebook](https://www.facebook.com/cissagatto) | [Twitter](https://twitter.com/cissagatto) | [Twitch](https://www.twitch.tv/cissagatto) | [Youtube](https://www.youtube.com/CissaGatto) |

# Thanks
