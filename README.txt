# MouseMuscleSOD1

## Introduction

This repository contains the code and data for the analysis of muscle fibres in mice with different genotypes (including ALS) and ages. Follow the steps below to run or reproduce our analysis published under the title **Computational analysis of SOD1-G93A mouse muscle biomarkers for comprehensive assessment of ALS progression**, doi: https://doi.org/10.1101/2024.03.11.584407.


## Steps to Run/Reproduce the Analysis

### 1. Segment Muscle Fibers and Extract Features

#### 1.1 Run `main.m`
Run `main.m` pointing to the parent folder containing all the raw images. This script will segment the muscle fibers and extract morphological and graph-theory features.

#### 1.2 Segmentation Pipeline
The default segmentation pipeline can be executed through `Segmentation.m` function.

#### 1.3 Curate and Annotate Segmented Images
Ensure the segmented images are properly curated and the cell types are correctly annotated before proceeding with feature extraction. Use the following scripts:
- `discriminate_cells_color.m`
- `correctionCellType.m`

#### 1.4 Extract Features
Run `Extraction_67ccs.m` to extract features. Several processed images and data will be stored in a new folder called `Data_image` within each image folder.

Auxiliary code to run these functions can be found in the `Ccs_extraction` and `Correction_type_cells` folders.

### 2. Store and Organize Extracted Features

All features extracted from each specific image are stored in `Matrix_cc_13-Nov-2020.mat`. The features are organized by genotype and age, and subdivided into groups within a cell hierarchy:
- The first cell column contains the image path (image ID).
- The second cell column contains the raw values of the features ordered numerically (position 1 -> feature 1, position n -> feature n).

#### Study Groups
The following groups are used in this study ([DOI: 10.1101/2024.03.11.584407](https://doi.org/10.1101/2024.03.11.584407)). Only non-NaN paths were included:

- `matrixCONT60` (WT at ~60 days)
- `matrixG93A60` (SOD1 G93A at ~60 days)
- `matrixCONT100` (WT at ~100 days)
- `matrixG93A100` (SOD1 G93A at ~100 days)
- `matrixCONT120` (WT at ~120 days)
- `matrixG93A120` and `matrixG93A130` (SOD1 G93A at ~120 days)
- `matrixWT120` (SOD1 WT at ~120 days)

### 3. Dimension Reduction and Feature Selection

#### 3.1 PCA Pipeline
Execute the PCA pipeline through `PCA/pca_feature_selection/PCA_NDICIA_pipeline.m` on the previously defined groups to identify features that allow better differentiation based on cluster distances.

#### 3.2 UMAP Pipeline
Execute the UMAP pipeline through `UMAP/umap_feature_selection/UMAP_NDICIA_pipeline.m` on the previously defined groups to identify features that allow better differentiation based on cluster distances.
