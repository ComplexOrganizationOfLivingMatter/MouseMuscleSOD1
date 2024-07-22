%Pipeline
addpath('src')
addpath('src\lib')
load(fullfile('..','..','..','PCA_data','Matrix_cc_13-Nov-2020.mat'))
path2save=fullfile('..','..','..','PCA_data','PCA_data_by_groups');


indexesGeometricNetworkCcs=[1 2 7:16 23:36 41 42 47 48 53 54 59 60]; %34 features (no slow/fast fibres)
indexesOnlyGeometricCcs = [1:14,69]; %15 features without considering the tissue as a network
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

mat1={matrixCONT60,matrixCONT60,matrixCONT60,matrixCONT80,matrixCONT80,matrixCONT100,matrixG93A60,matrixG93A60,matrixG93A80,matrixWT80,matrixWT80,matrixWT100,matrixCONT60,matrixCONT80,matrixWT80,matrixWT80,matrixCONT100,matrixWT100,matrixWT100,matrixWT120};
mat2={matrixCONT80,matrixCONT100,matrixCONT120,matrixCONT100,matrixCONT120,matrixCONT120,matrixG93A80,matrixG93A100,matrixG93A100,matrixWT100,matrixWT120,matrixWT120,matrixG93A60,matrixG93A80,matrixCONT80,matrixG93A80,matrixG93A100,matrixCONT100,matrixG93A100,matrixCONT120};
name1={'Control 60','Control 60','Control 60','Control 80','Control 80','Control 100','G93A 60','G93A 60','G93A 80','WT 80','WT 80','WT 100','Control 60','Control 80','WT 80','WT 80','Control 100','WT 100','WT 100','WT 120'};
name2={'Control 80','Control 100','Control 120','Control 100','Control 120','Control 120','G93A 80','G93A 100','G93A 100','WT 100','WT 120','WT 120','G93A 60','G93A 80','Control 80','G93A 80','G93A 100','Control 100','G93A 100','Control 120'};
indexesM1={indCONT60,indCONT60,indCONT60,indCONT80,indCONT80,indCONT100,indG93A60,indG93A60,indG93A80,indWT80,indWT80,indWT100,indCONT60,indCONT80,indWT80,indWT80,indCONT100,indWT100,indWT100,indWT120};
indexesM2={indCONT80,indCONT100,indCONT120,indCONT100,indCONT120,indCONT120,indG93A80,indG93A100,indG93A100,indWT100,indWT120,indWT120,indG93A60,indG93A80,indCONT80,indG93A80,indG93A100,indCONT100,indG93A100,indCONT120};

for i=1:length(mat1)
    matrix1=vertcat(cell2mat(mat1{i}(:,2)));
    matrix2=vertcat(cell2mat(mat2{i}(:,2)));
    m1=matrix1(indexesM1{i},:);
    m2=matrix2(indexesM2{i},:);
    
    %PCA_2_cc_Original(matrix1, matrix2, 'Class1', 'Class2','indexesTag');
    PCA_2_cc_Original(m1(:,indexesGeometricNetworkCcs),m2(:,indexesGeometricNetworkCcs),name1{i},name2{i},path2save,indexesGeometricNetworkCcs);
    PCA_2_cc_Original(m1(:,indexesOnlyGeometricCcs),m2(:,indexesOnlyGeometricCcs),name1{i},name2{i},path2save,indexesOnlyGeometricCcs);
    PCA_2_cc_Original(m1(:,indexes34andAreas),m2(:,indexes34andAreas),name1{i},name2{i},path2save,indexes34andAreas);
    PCA_2_cc_Original(m1(:,indexAllFeaturesNoDapi),m2(:,indexAllFeaturesNoDapi),name1{i},name2{i},path2save,indexAllFeaturesNoDapi);

    %include dapi ccs if > 60 days
    if ~contains([name1{i},name2{i}],'60')
        PCA_2_cc_Original(m1(:,indexAllFeatures),m2(:,indexAllFeatures),name1{i},name2{i},path2save,indexAllFeatures);
        PCA_2_cc_Original(m1(:,indexesGeometricNetworkDapiCcs),m2(:,indexesGeometricNetworkDapiCcs),name1{i},name2{i},path2save,indexesGeometricNetworkDapiCcs);

    end
end


%% Comparisons including SOD1 g93a 130 days
mat1={matrixG93A60,matrixG93A80,matrixG93A100,matrixCONT120,matrixWT120};
mat2={matrixG93A120,matrixG93A120,matrixG93A120,matrixG93A120,matrixG93A120};
mat3={matrixG93A130,matrixG93A130,matrixG93A130,matrixG93A130,matrixG93A130};
indexesM1={indG93A60,indG93A80,indG93A100,indCONT120,indWT120};
indexesM2={indG93A120,indG93A120,indG93A120,indG93A120,indG93A120};
indexesM3={indG93A130,indG93A130,indG93A130,indG93A130,indG93A130};
name1={'G93A 60','G93A 80','G93A 100','Control 120','WT 120'};
% name2={'G93A 120','G93A 120','G93A 120','G93A 120','G93A 120'};

for i=1:length(mat1)
    matrix1=vertcat(cell2mat(mat1{i}(:,2)));
    matrix2=vertcat(cell2mat(mat2{i}(:,2)));
    matrix3=vertcat(cell2mat(mat3{i}(:,2)));

    %delete nan due to slow - fast cells
    m1=matrix1(indexesM1{i},:);
    m2=matrix2(indexesM2{i},:);
    m3=matrix3(indexesM3{i},:);
    
    %PCA_2_cc_Original(matrix1, matrix2, matrix3, 'Class1', 'Class2','indexesTag');
    PCA_2_cc_Original_Subgroups(m1(:,indexesGeometricNetworkCcs),m2(:,indexesGeometricNetworkCcs),m3(:,indexesGeometricNetworkCcs),name1{i},'G93A 120',path2save,indexesGeometricNetworkCcs);
    PCA_2_cc_Original_Subgroups(m1(:,indexesOnlyGeometricCcs),m2(:,indexesOnlyGeometricCcs),m3(:,indexesOnlyGeometricCcs),name1{i},'G93A 120',path2save,indexesOnlyGeometricCcs);
    PCA_2_cc_Original_Subgroups(m1(:,indexes34andAreas),m2(:,indexes34andAreas),m3(:,indexes34andAreas),name1{i},'G93A 120',path2save,indexes34andAreas);
    PCA_2_cc_Original_Subgroups(m1(:,indexAllFeaturesNoDapi),m2(:,indexAllFeaturesNoDapi),m3(:,indexAllFeaturesNoDapi),name1{i},'G93A 120',path2save,indexAllFeaturesNoDapi);
    
    %include dapi ccs if > 60 days
    if ~contains([name1{i},'G93A 120'],'60')
        PCA_2_cc_Original_Subgroups(m1(:,indexAllFeatures),m2(:,indexAllFeatures),m3(:,indexAllFeatures),name1{i},'G93A 120',path2save,indexAllFeatures);
        PCA_2_cc_Original_Subgroups(m1(:,indexesGeometricNetworkDapiCcs),m2(:,indexesGeometricNetworkDapiCcs),m3(:,indexesGeometricNetworkDapiCcs),name1{i},'G93A 120',path2save,indexesGeometricNetworkDapiCcs);
    end
    
end



% %% Comparisons Transgenic vs WT & WT-SOD1wt vs SOD1 g93a
% 
% mat1={matrixG93A100,[matrixG93A120;matrixG93A130],matrixCONT100,matrixCONT120};
% mat2={matrixCONT100,matrixCONT120,matrixG93A100,[matrixG93A120;matrixG93A130]};
% mat3={matrixWT100,matrixWT120,matrixWT100,matrixWT120};
% indexesM1={indG93A100,[indG93A120;indG93A130],indCONT100,indCONT120};
% indexesM2={indCONT100,indCONT120,indG93A100,[indG93A120;indG93A130]};
% indexesM3={indWT100,indWT120,indWT100,indWT120};
% name1={'G93A 100','G93A 120','Control 100','Control 120'};
% name2={'ControlWT 100','ControlWT 120','Transgenic 100','Transgenic 120'};
% 
% parfor i=1:length(mat1)
%     matrix1=vertcat(cell2mat(mat1{i}(:,2)));
%     matrix2=vertcat(cell2mat(mat2{i}(:,2)));
%     matrix3=vertcat(cell2mat(mat3{i}(:,2)));
%     m1=matrix1(indexesM1{i},:);
%     m2=matrix2(indexesM2{i},:);
%     m3=matrix3(indexesM3{i},:);
%     
%     %PCA_2_cc_Original(matrix1, matrix2, matrix3, 'Class1', 'Class2','indexesTag');
%     PCA_2_cc_Original_Subgroups(m1(:,indexesGeometricNetworkCcs),m2(:,indexesGeometricNetworkCcs),m3(:,indexesGeometricNetworkCcs),name1{i},name2{i},path2save,indexesGeometricNetworkCcs);
%     PCA_2_cc_Original_Subgroups(m1(:,1:69),m2(:,1:69),m3(:,1:69),name1{i},name2{i},path2save);
%     PCA_2_cc_Original_Subgroups(m1(:,indexesGeometricNetworkDapiCcs),m2(:,indexesGeometricNetworkDapiCcs),m3(:,indexesGeometricNetworkDapiCcs),name1{i},name2{i},path2save,indexesGeometricNetworkDapiCcs);
%     PCA_2_cc_Original_Subgroups(m1,m2,m3,name1{i},name2{i},path2save);
% 
% end


