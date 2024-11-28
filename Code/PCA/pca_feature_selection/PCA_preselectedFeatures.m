%% PCA of preselected 19 features

top7Features = {[26,9,6,45,65,37,30],[14,20,67,6,10,21,30],[12,4,2,24,23,14,13]};


addpath(genpath('src'))
path2load = fullfile('..','..','..','PCA_data');
load(fullfile(path2load,'Matrix_cc_13-Nov-2020.mat'))
path2save=fullfile(path2load,'PCA_preselectedFeatures');

indexAllFeaturesNoDapi = [1:62,65:69]; %All 67 features 


indCONT60=find(cellfun(@(x) ~(length(isnan(x))==1),matrixCONT60(:,1)));
indCONT100=find(cellfun(@(x) ~(length(isnan(x))==1),matrixCONT100(:,1)));
indCONT120=find(cellfun(@(x) ~(length(isnan(x))==1),matrixCONT120(:,1)));


indG93A60=find(cellfun(@(x) ~(length(isnan(x))==1),matrixG93A60(:,1)));
indG93A100=find(cellfun(@(x) ~(length(isnan(x))==1),matrixG93A100(:,1)));
matrixG93A120concat = [matrixG93A120;matrixG93A130];
indG93A120=find(cellfun(@(x) ~(length(isnan(x))==1),matrixG93A120concat(:,1)));

%number of samples per group and number of experiments
n_samples = 19;
n_randomizations=1000;


preliminaryIndicesA = {indCONT60,indCONT100,indCONT120};
preliminaryIndicesB = {indG93A60,indG93A100,indG93A120};
preliminaryMatGroupsA = {matrixCONT60,matrixCONT100,matrixCONT120};
preliminaryMatGroupsB = {matrixG93A60,matrixG93A100,matrixG93A120concat};

nameDays={'60','100','120'};

mkdir(path2save)

for nDay=1:3
    preliminary_matrixA=vertcat(cell2mat(preliminaryMatGroupsA{nDay}(preliminaryIndicesA{nDay},2)));
    preliminary_matrixB=vertcat(cell2mat(preliminaryMatGroupsB{nDay}(preliminaryIndicesB{nDay},2)));

    m1 = preliminary_matrixA(:,indexAllFeaturesNoDapi);
    m2 = preliminary_matrixB(:,indexAllFeaturesNoDapi);

    %filter by features of interest
    m1=m1(:,sort(top7Features{nDay}));
    m2=m2(:,sort(top7Features{nDay}));
    PCA_2_cc_Original(m1,m2,['Control p' nameDays{nDay}], ['G2019S p' nameDays{nDay}],path2save,sort(top7Features{nDay}));

end
