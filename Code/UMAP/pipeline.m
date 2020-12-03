%Pipeline
addpath(genpath('src'))
load('..\..\PCA_data\Matrix_cc_13-Nov-2020.mat')
path2save='..\..\UMAP_data\UMAP_data_by_groups\';
if ~exist(path2save,'dir')
    mkdir(path2save)
end



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

%% Comparisons WT - SOD1 wt - SOD1 g93a

mat1={matrixCONT60,matrixCONT100,matrixWT120};
mat2={matrixG93A60,matrixG93A100,matrixCONT120};
name1={'Control 60','Control 100','WT 120'};
name2={'G93A 60','G93A 100','Control 120'};
indexesM1={indCONT60,indCONT100,indWT120};
indexesM2={indG93A60,indG93A100,indCONT120};

for i=1:length(mat1)
    matrix1=vertcat(cell2mat(mat1{i}(:,2)));
    matrix2=vertcat(cell2mat(mat2{i}(:,2)));
    m1=matrix1(indexesM1{i},:);
    m2=matrix2(indexesM2{i},:);
    
    %UMAP_NDICIA(matrix1, matrix2, 'Class1', 'Class2','indexesTag');
    UMAP_NDICIA(m1(:,indexesOnlyGeometricNoTypeFibre),m2(:,indexesOnlyGeometricNoTypeFibre),name1{i},name2{i},path2save,indexesOnlyGeometricNoTypeFibre);
    UMAP_NDICIA(m1(:,indexesOnlyGeometricCcs),m2(:,indexesOnlyGeometricCcs),name1{i},name2{i},path2save,indexesOnlyGeometricCcs);
    UMAP_NDICIA(m1(:,indexesGeometricNetworkCcs),m2(:,indexesGeometricNetworkCcs),name1{i},name2{i},path2save,indexesGeometricNetworkCcs);
    UMAP_NDICIA(m1(:,indexes34andAreas),m2(:,indexes34andAreas),name1{i},name2{i},path2save,indexes34andAreas);
    UMAP_NDICIA(m1(:,indexAllFeaturesNoDapi),m2(:,indexAllFeaturesNoDapi),name1{i},name2{i},path2save,indexAllFeaturesNoDapi);

    %include dapi ccs if > 60 days
    if ~contains([name1{i},name2{i}],'60')
        UMAP_NDICIA(m1(:,indexAllFeatures),m2(:,indexAllFeatures),name1{i},name2{i},path2save,indexAllFeatures);
        UMAP_NDICIA(m1(:,indexesGeometricNetworkDapiCcs),m2(:,indexesGeometricNetworkDapiCcs),name1{i},name2{i},path2save,indexesGeometricNetworkDapiCcs);

    end
end


%% Comparisons including SOD1 g93a 130 days
mat1={matrixCONT120,matrixWT120};
mat2={matrixG93A120,matrixG93A120};
mat3={matrixG93A130,matrixG93A130};
indexesM1={indCONT120,indWT120};
indexesM2={indG93A120,indG93A120};
indexesM3={indG93A130,indG93A130};
name1={'Control 120','WT 120'};
% name2={'G93A 120','G93A 120','G93A 120','G93A 120','G93A 120'};

for i=1:length(mat1)
    matrix1=vertcat(cell2mat(mat1{i}(:,2)));
    matrix2=vertcat(cell2mat(mat2{i}(:,2)));
    matrix3=vertcat(cell2mat(mat3{i}(:,2)));

    %delete nan due to slow - fast cells
    m1=matrix1(indexesM1{i},:);
    m2=matrix2(indexesM2{i},:);
    m3=matrix3(indexesM3{i},:);
    
    %UMAP_NDICIA(matrix1, matrix2, matrix3, 'Class1', 'Class2','indexesTag');
    UMAP_NDICIA(m1(:,indexesGeometricNetworkCcs),[m2(:,indexesGeometricNetworkCcs),m3(:,indexesGeometricNetworkCcs)],name1{i},'G93A 120',path2save,indexesGeometricNetworkCcs);
    UMAP_NDICIA(m1(:,indexesOnlyGeometricCcs),[m2(:,indexesOnlyGeometricCcs),m3(:,indexesOnlyGeometricCcs)],name1{i},'G93A 120',path2save,indexesOnlyGeometricCcs);
    UMAP_NDICIA(m1(:,indexesOnlyGeometricNoTypeFibre),[m2(:,indexesOnlyGeometricNoTypeFibre),m3(:,indexesOnlyGeometricNoTypeFibre)],name1{i},'G93A 120',path2save,indexesOnlyGeometricNoTypeFibre);
    UMAP_NDICIA(m1(:,indexes34andAreas),[m2(:,indexes34andAreas),m3(:,indexes34andAreas)],name1{i},'G93A 120',path2save,indexes34andAreas);
    UMAP_NDICIA(m1(:,indexAllFeaturesNoDapi),[m2(:,indexAllFeaturesNoDapi),m3(:,indexAllFeaturesNoDapi)],name1{i},'G93A 120',path2save,indexAllFeaturesNoDapi);
    
    %include dapi ccs if > 60 days
    if ~contains([name1{i},'G93A 120'],'60')
        UMAP_NDICIA(m1(:,indexAllFeatures),[m2(:,indexAllFeatures),m3(:,indexAllFeatures)],name1{i},'G93A 120',path2save,indexAllFeatures);
        UMAP_NDICIA(m1(:,indexesGeometricNetworkDapiCcs),[m2(:,indexesGeometricNetworkDapiCcs),m3(:,indexesGeometricNetworkDapiCcs)],name1{i},'G93A 120',path2save,indexesGeometricNetworkDapiCcs);
    end
    
end



