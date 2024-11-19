%% Task 1. ASSESSING SAMPLE SIZE EFFECT
%% Task 2. EVALUATING SEPARATION WHEN SHUFFLE THE SAMPLE CLASS. I.E. RANDOMIZING GROUP1 AND GROUP2 LABELS
% just comparing NDICIA PCA among Control and G93A groups at ages 60, 100
% and 120 days.

addpath(genpath('src'))
path2load = fullfile('..','..','..','PCA_data');
load(fullfile(path2load,'Matrix_cc_13-Nov-2020.mat'))
path2saveRand=fullfile(path2load,'Randomization');
path2saveHom=fullfile(path2load,'Homogeneous_size');

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

preliminaryMatGroupsA = {matrixCONT60,matrixCONT100,matrixCONT120};
preliminaryMatGroupsB = {matrixG93A60,matrixG93A100,matrixG93A120concat};
preliminaryIndicesA = {indCONT60,indCONT100,indCONT120};
preliminaryIndicesB = {indG93A60,indG93A100,indG93A120};
nameDays={'60','100','120'};

BestPCA_value_rand = zeros(length(nameDays),n_randomizations);
BestPCA_value_hom = zeros(length(nameDays),n_randomizations);

featuresSelected_rand = cell(length(nameDays),n_randomizations);
featuresSelected_hom = cell(length(nameDays),n_randomizations);


for nDay=1:3
    preliminary_matrixA=vertcat(cell2mat(preliminaryMatGroupsA{nDay}(:,2)));
    preliminary_matrixB=vertcat(cell2mat(preliminaryMatGroupsB{nDay}(:,2)));
    for nRand = 1:n_randomizations
        
        %% Sample size evaluation
        %randomize the samples taken for the NDICIA PCA analysis - use the
        %same size of samples for both groups
        idxA = sort(randperm(length(preliminaryIndicesA{nDay}),n_samples));
        idxB = sort(randperm(length(preliminaryIndicesB{nDay}),n_samples));
        m1 = preliminary_matrixA(idxA,indexAllFeaturesNoDapi);
        m2 = preliminary_matrixB(idxB,indexAllFeaturesNoDapi);

        %make dir for realization
        path2save_hom = fullfile(path2saveHom,[num2str(n_samples) ' samples'],[nameDays{nDay} ' days'],['rand ' num2str(nRand)]);
        path2save_rand = fullfile(path2saveRand,[num2str(n_samples) ' samples'],[nameDays{nDay} ' days'],['rand ' num2str(nRand)]);

        if ~exist(path2save_hom,'dir')
            mkdir(path2save_hom)
            PCA_2_cc_Original(m1,m2, ['Control ' nameDays{nDay}], ['G93A ' nameDays{nDay}],path2save_hom);
    
            %% Randomization
            %Get the same size of samples for both preliminary groups, and
            %shuffle, assigning them randomly a class: A or B. 
            m12 = [m1;m2];
            shuffleId = randperm(n_samples*2,n_samples*2);
            new_m1 = m12(shuffleId(1:n_samples),:);
            new_m2 = m12(shuffleId(n_samples+1:end),:);
            
            %make dir for realization
            mkdir(path2save_rand)
            PCA_2_cc_Original(new_m1,new_m2,['A ' nameDays{nDay}], ['B ' nameDays{nDay}],path2save_rand);
        end
        load(fullfile(path2save_hom,['PCA_Control ' nameDays{nDay} '_G93A ' nameDays{nDay} '_selection_cc_' num2str(length(indexAllFeaturesNoDapi)) '.mat']))
        BestPCA_value_hom(nDay,nRand) = bestPCA;            
        featuresSelected_hom{nDay,nRand}=indexesCcsSelected;
        
        load(fullfile(path2save_rand,['PCA_A ' nameDays{nDay} '_B ' nameDays{nDay} '_selection_cc_' num2str(length(indexAllFeaturesNoDapi)) '.mat']))
        BestPCA_value_rand(nDay,nRand) = bestPCA;
        featuresSelected_rand{nDay,nRand}=indexesCcsSelected;

    end

end

save(fullfile(path2saveRand,['PCA_' num2str(n_samples) '_samples_Rand_18-Nov-2024.mat']),'BestPCA_value_rand','featuresSelected_rand');
save(fullfile(path2saveHom,['PCA_' num2str(n_samples) '_samples_Hom_18-Nov-2024.mat']),'BestPCA_value_hom','featuresSelected_hom');

