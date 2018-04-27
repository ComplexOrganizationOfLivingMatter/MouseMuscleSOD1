rootPath='..\..\PCa_data\';

pathPCAresults=[rootPath 'PCA_data_by_groups\'];
tableCcs=readtable('..\..\docs\list_81_cc.xls');
listOfCcs=table2cell(tableCcs);

load([rootPath 'Matrix_cc_25-Apr-2018.mat'])


pathFilesPca=dir([pathPCAresults,'*.mat']);

maxNumCcs=7;
numRows=8;

excelStructure=cell(length(pathFilesPca)*numRows,8);

for nFiles=1:length(pathFilesPca)
   
    load([pathPCAresults pathFilesPca(nFiles).name])
    comparisonName = strrep(pathFilesPca(nFiles).name,'PCA_','');
    
    SplittedNames=strsplit(comparisonName,'_');
    for nGroup=1:2
        nameGroup=SplittedNames{nGroup};
        switch nameGroup
            case 'Control 60'
                matrixCcs=matrixCONT60;
            case 'Control 80'
                matrixCcs=matrixCONT80;
            case 'Control 100'
                matrixCcs=matrixCONT100;
            case 'Control 120'
                matrixCcs=matrixCONT120;
            case 'WT 80'
                matrixCcs=matrixWT80;
            case 'WT 100'
                matrixCcs=matrixWT100;
            case 'WT 120'
                matrixCcs=matrixWT120;
            case 'G93A 60'
                matrixCcs=matrixG93A60;
            case 'G93A 80'
                matrixCcs=matrixG93A80;
            case 'G93A 100'
                matrixCcs=matrixG93A100;
            case 'G93A 120'
                matrixCcs=matrixG93A120;
                matrixAux=matrixG93A130;
        end

        if nGroup==1
            matrixGroup1=cell2mat(matrixCcs(cellfun(@(x) ~(length(isnan(x))==1),matrixCcs(:,1)),2));
        else
            matrixGroup2=cell2mat(matrixCcs(cellfun(@(x) ~(length(isnan(x))==1),matrixCcs(:,1)),2));
            if strcmp(nameGroup,'G93A 120')
                matrixGroup2=[matrixGroup2;cell2mat(matrixAux(cellfun(@(x) ~(length(isnan(x))==1),matrixAux(:,1)),2))];
            end
        end
    end
    
    
   
    weightCcs=cell2mat(eigenvectors);
    [absWeightCcsCol,indCol]=max(abs(weightCcs),[],2);
    [absWeightCcs,indRow]=sort(absWeightCcsCol,'descend');
    
    ccsOrderedByWeight=zeros(1,maxNumCcs);
    ccsOrderedByWeight(1:length(indRow))=indexesCcsSelected(indRow);
    ccsOrderedByWeight(ccsOrderedByWeight==0)=[];
    listOfCcsOrdered=listOfCcs(ccsOrderedByWeight);

    ccsWithWeight=[ccsOrderedByWeight;absWeightCcs'];
    
    
    ccsDataGroup1=matrixGroup1(:,ccsOrderedByWeight);
    ccsDataGroup2=matrixGroup2(:,ccsOrderedByWeight);
    
    meanDataG1=mean(ccsDataGroup1);
    stdDataG1=std(ccsDataGroup1);
    meanDataG2=mean(ccsDataGroup2);
    stdDataG2=std(ccsDataGroup2);
    
    firstCell = {[SplittedNames{1} ' - ' SplittedNames{2}]; ['PCA descriptor: ' num2str(bestPCA)]};
    comparisonsAndPCAdescriptor = char(firstCell);
    
    excelStructure{((nFiles-1)*numRows)+1,1}= [SplittedNames{1} ' - ' SplittedNames{2}];
    excelStructure{((nFiles-1)*numRows)+2,1}= ['PCA descriptor: ' num2str(bestPCA)];
    excelStructure{((nFiles-1)*numRows)+3,1}= 'absolute weights';
    excelStructure{((nFiles-1)*numRows)+4,1}= 'mean 1st Group';
    excelStructure{((nFiles-1)*numRows)+5,1}= 'mean 2nd Group';
    excelStructure{((nFiles-1)*numRows)+6,1}= 'std 1st Group';
    excelStructure{((nFiles-1)*numRows)+7,1}= 'std 2nd Group';

    excelStructure(((nFiles-1)*numRows)+2,2:length(indexesCcsSelected)+1)=listOfCcsOrdered';
    excelStructure(((nFiles-1)*numRows)+3,2:length(indexesCcsSelected)+1)=num2cell(absWeightCcs');
    excelStructure(((nFiles-1)*numRows)+4:((nFiles-1)*numRows)+7,2:length(indexesCcsSelected)+1)=num2cell([meanDataG1;meanDataG2;stdDataG1;stdDataG2]);

end
t = cell2table(excelStructure);    %ca can include a mix of numeric and char vectors
writetable(t,[rootPath 'featuresSelectedPCA_' date '.xls'], 'writevariablenames', false);
