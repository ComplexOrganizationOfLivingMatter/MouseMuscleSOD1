rootPath='..\..\PCA_data\';

pathPCAresults=[rootPath 'PCA_data_by_groups\'];
tableCcs=readtable('..\..\docs\list_81_cc.xls');
listOfCcs=table2cell(tableCcs);

load([rootPath 'Matrix_cc_06-Oct-2020.mat'])

group1='34ccs';
group2='46ccs';
group3='69ccs';
group4='81ccs';
pathFilesPca1=dir([pathPCAresults group1 '\*.mat']);
pathFilesPca2=dir([pathPCAresults group2 '\*.mat']);
pathFilesPca3=dir([pathPCAresults group3 '\*.mat']);
pathFilesPca4=dir([pathPCAresults group4 '\*.mat']);


maxNumCcs=7;
numRows=8;

groupNames={group1,group2,group3,group4};
groupOfPathFiles={pathFilesPca1,pathFilesPca2,pathFilesPca3,pathFilesPca4};

for nPathFiles=1:length(groupOfPathFiles)
    
    pathFilesPca=groupOfPathFiles{nPathFiles};
    excelStructure=cell(length(groupOfPathFiles{nPathFiles})*numRows,8);

    for nFiles=1:length(pathFilesPca)

        load([pathPCAresults groupNames{nPathFiles} '\' pathFilesPca(nFiles).name])
        comparisonName = strrep(pathFilesPca(nFiles).name,'PCA_','');

        SplittedNames=strsplit(comparisonName,'_');
        for nGroup=1:2
            nameClass=SplittedNames{nGroup};
            switch nameClass
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
                case 'Transgenic 100'
                    matrixCcs=matrixG93A100;
                    matrixAux=matrixWT100;
                case 'Transgenic 120'
                    matrixCcs=matrixG93A120;
                    matrixAux=matrixWT120;
                case 'ControlWT 100'
                    matrixCcs=matrixCONT100;
                    matrixAux=matrixWT100;
                case 'ControlWT 120'
                    matrixCcs=matrixCONT120;
                    matrixAux=matrixWT120;
            end

            switch nGroup
                case 1
                    matrixGroup1=cell2mat(matrixCcs(cellfun(@(x) ~(length(isnan(x))==1),matrixCcs(:,1)),2));
                case 2
                    matrixGroup2=cell2mat(matrixCcs(cellfun(@(x) ~(length(isnan(x))==1),matrixCcs(:,1)),2));
                    if strcmp(nameClass,'G93A 120') || strcmp(nameClass,'Transgenic 120') || strcmp(nameClass,'Transgenic 100') || strcmp(nameClass,'ControlWT 100') || strcmp(nameClass,'ControlWT 120') 
                        matrixGroup2=[matrixGroup2;cell2mat(matrixAux(cellfun(@(x) ~(length(isnan(x))==1),matrixAux(:,1)),2))];
                    end
            end
        end


        if ~isnumeric(eigenvectors)
            weightCcs=cell2mat(eigenvectors);
        else
            weightCcs=eigenvectors;
        end
        
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
    t = cell2table(excelStructure); 
    writetable(t,[rootPath 'featuresSelectedPCA_' groupNames{nPathFiles} '_' date '.xls'], 'writevariablenames', false);
end