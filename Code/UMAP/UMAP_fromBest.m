%get UMAP dimensionality reduction using the selected features
clear all
close all

addpath(genpath('src'))
load('..\..\PCA_data\Matrix_cc_13-Nov-2020.mat')
folderRoot='..\..\UMAP_data\UMAP_data_by_groups\';
warning('off','all')

nRandomizations = 10;

indexesGeometricNetworkCcs=[1 2 7:16 23:36 41 42 47 48 53 54 59 60]; %34 features (no slow/fast fibres)
indexesOnlyGeometricCcs = [1:14,69]; %15 features without considering the tissue as a network
indexesOnlyGeometricNoTypeFibre = [1 2 7:14]; %10 features
indexes34andAreas = [1:16 23:36 41 42 47 48 53 54 59 60 69]; %39 features (34 features + areas and proportion slow/fast cells 
indexesGeometricNetworkDapiCcs=[indexesGeometricNetworkCcs 70:81];% 34 features + DAPI
indexAllFeaturesNoDapi = [1:62,65:69]; %All 67 features 
indexAllFeatures= [indexAllFeaturesNoDapi, 70:81];%All features +  DAPI

indCONT60=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT60(:,1));
indCONT80=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT80(:,1));
indCONT100=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT100(:,1));
indCONT120=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT120(:,1));
indWT80=cellfun(@(x) ~(length(isnan(x))==1),matrixWT80(:,1));
indWT100=cellfun(@(x) ~(length(isnan(x))==1),matrixWT100(:,1));
indWT120=cellfun(@(x) ~(length(isnan(x))==1),matrixWT120(:,1));
indG93A60=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A60(:,1));
indG93A80=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A80(:,1));
indG93A100=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A100(:,1));
indG93A120=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A120(:,1));
indG93A130=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A130(:,1));

mat1={matrixCONT60,matrixCONT100,matrixCONT120,matrixWT120,matrixWT120};
mat2={matrixG93A60,matrixG93A100,[matrixG93A120;matrixG93A130],matrixCONT120,[matrixG93A120;matrixG93A130]};
name1={'Control 60','Control 100','Control 120','WT 120','WT 120'};
name2={'G93A 60','G93A 100','G93A 120','Control 120','G93A 120'};
indexesM1={indCONT60,indCONT100,indCONT120,indWT120,indWT120};
indexesM2={indG93A60,indG93A100,[indG93A120;indG93A130],indCONT120,[indG93A120;indG93A130]};


for nMat = 1:length(mat1)
    folderGroups = 'WT_SOD1_G93A';
    if contains(name1{nMat},'60')
        folderDays = '60 days';
    end
    if contains(name1{nMat},'100')
        folderDays = '100 days';
        
    end
    
    if contains(name1{nMat},'120')
        folderDays = '120 days';
        if contains(name1{nMat},'WT') && contains(name2{nMat},'Control')
            folderGroups = 'WT_SOD1_WT';
        end
        if contains(name1{nMat},'WT') && contains(name2{nMat},'G93A')
            folderGroups = 'SOD1_G93A_SOD1_WT';
        end
    end
    folderCcs = dir(fullfile(folderRoot,folderDays,folderGroups,'*.mat'));

    matrix1=vertcat(cell2mat(mat1{nMat}(:,2)));
    matrix2=vertcat(cell2mat(mat2{nMat}(:,2)));
    m1=matrix1(indexesM1{nMat},:);
    m2=matrix2(indexesM2{nMat},:);
    
    
    for nCCs = 1:size(folderCcs,1)
        nameFile = folderCcs(nCCs).name;
        load(fullfile(folderCcs(nCCs).folder,nameFile))

        % Group 1
        m1Indexes = m1(:,selectedFeatures);
        nImgType1=size(m1Indexes,1);

        % Group 2
        m2Indexes = m2(:,selectedFeatures);
        nImgType2=size(m2Indexes,1);

        %All ccs matrix
        matrixAllCCs=[m1Indexes;m2Indexes];
        matrixChosenCcs = matrixAllCCs;
        %Number of images and ccs
        n_images=nImgType1+nImgType2;       

        %Normalizing each cc
        for cc=1:size(matrixAllCCs,2)
            matrixChosenCcs(:,cc)=matrixChosenCcs(:,cc)-min(matrixChosenCcs(:,cc));
            matrixChosenCcs(:,cc)=matrixChosenCcs(:,cc)/max(matrixChosenCcs(:,cc));  
        end
        path2save = fullfile(folderCcs(nCCs).folder,nameFile(end-8:end-4));
        parfor nRand =1 : nRandomizations
            [Proyections,eigenvectors,Ratio_UMAP]=calculateUMAPValues(matrixChosenCcs,1,nImgType1,nImgType2,[],[],[],selectedFeatures);
            plotUMAP_save(path2save, name1{nMat},name2{nMat},nImgType1,nImgType2,nRand,Proyections, eigenvectors, Ratio_UMAP,selectedFeatures);
        end
    end
end




        


