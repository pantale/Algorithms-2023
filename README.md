# Algorithms-2023

This repository contains the source files of the software used in the MDPI Algorithms publication:

**Comparing Activation Functions in Machine Learning for Finite Element Simulations in Thermomechanical Forming**

Olivier Pantalé

*Algorithms* **2023**, *16*(12), 537; https://doi.org/10.3390/a16120537

**Published:**  25 November 2023

**Special Issue:** [Deep Learning Architecture and Applications](https://www.mdpi.com/journal/algorithms/special_issues/56U1X6P99B)

**Abstract:** Finite element (FE) simulations have been effective in simulating thermomechanical forming processes, yet challenges arise when applying them to new materials due to nonlinear behaviors. To address this, machine learning techniques and artificial neural networks play an increasingly vital role in developing complex models. This paper presents an innovative approach to parameter identification in flow laws, utilizing an artificial neural network that learns directly from test data and automatically generates a Fortran subroutine for the Abaqus standard or explicit FE codes. We investigate the impact of activation functions on prediction and computational efficiency by comparing Sigmoid, Tanh, ReLU, Swish, Softplus, and the less common Exponential function. Despite its infrequent use, the Exponential function demonstrates noteworthy performance and reduced computation times. Model validation involves comparing predictive capabilities with experimental data from compression tests, and numerical simulations confirm the numerical implementation in the Abaqus explicit FE code.

**Keywords:**  [constitutive behavior](https://www.mdpi.com/search?q=constitutive+behavior); [ANN flow law](https://www.mdpi.com/search?q=ANN+flow+law); [numerical implementation](https://www.mdpi.com/search?q=numerical+implementation); [user hardening](https://www.mdpi.com/search?q=user+hardening); [activation functions](https://www.mdpi.com/search?q=activation+functions); [abaqus](https://www.mdpi.com/search?q=abaqus)

**Citation:** 

```
@Article{a16120537,
AUTHOR = {Pantalé, Olivier},
TITLE = {Comparing Activation Functions in Machine Learning for Finite Element Simulations in Thermomechanical Forming},
JOURNAL = {Algorithms},
VOLUME = {16},
YEAR = {2023},
NUMBER = {12},
ARTICLE-NUMBER = {537},
URL = {https://www.mdpi.com/1999-4893/16/12/537},
ISSN = {1999-4893},
DOI = {10.3390/a16120537}
}
```

## Contents

This directory contains the following main files and subdirectories:

- **3Cr2Mo.h5** : The database of the Gleeble tests

- **ANN-Study.ipynb** : The ANN learning model in Python 3

- **ANN-Fortran.ipynb** : The Python/Fortran extractor for the ANN used to generate the FORTRAN 77 subroutine for the Abaqus FEM code

- **Abaqus** : The directory containing the source file of the Abaqus compression model presented in the paper
