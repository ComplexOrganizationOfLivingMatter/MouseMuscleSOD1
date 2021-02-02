rootPath='E:\Pedro\MouseMuscleSOD1\UMAP_data\';

pathUMAPbestResults=[rootPath 'UMAP_figuresPaper\'];
tableCcs=readtable([rootPath 'Table1_13-Nov-2020.xlsx']);
listOfCcs=table2cell(tableCcs);
listOfCcs=listOfCcs(1:69,1);

load([rootPath 'Matrix_cc_13-Nov-2020.mat'])

group1='67';
group2='39';
group3='34';

pathFilesUMAP1=dir([pathUMAPbestResults '\*' group1 '*.mat']);
pathFilesUMAP2=dir([pathUMAPbestResults '\*' group2 '*.mat']);
pathFilesUMAP3=dir([pathUMAPbestResults '\*' group3 '*.mat']);


maxNumCcs=7;
numRows=8;

groupNames={group1,group2,group3};
groupOfPathFiles={pathFilesUMAP1,pathFilesUMAP2,pathFilesUMAP3};

for nPathFiles=1:length(groupOfPathFiles)
    
    pathFilesUMAP=groupOfPathFiles{nPathFiles};
    excelStructure=cell(length(groupOfPathFiles{nPathFiles})*numRows,8);

    for nFiles=1:length(pathFilesUMAP)

        load([pathUMAPbestResults '\' pathFilesUMAP(nFiles).name])
        comparisonName = strrep(pathFilesUMAP(nFiles).name,'UMAP_','');

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
        
        [absWeightCcsCol,indCol]=max(abs(weightCcs));
        [absWeightCcs,indRow]=sort(absWeightCcsCol,'descend');

        ccsOrderedByWeight=zeros(1,maxNumCcs);
        ccsOrderedByWeight(1:length(indRow))=indexesCcsSelected(indRow);
        ccsOrderedByWeight(ccsOrderedByWeight==0)=[];
        listOfCcsOrdered=listOfCcs(ccsOrderedByWeight);

        ccsWithWeight=[ccsOrderedByWeight;absWeightCcs];


        ccsDataGroup1=matrixGroup1(:,ccsOrderedByWeight);
        ccsDataGroup2=matrixGroup2(:,ccsOrderedByWeight);

        meanDataG1=mean(ccsDataGroup1);
        stdDataG1=std(ccsDataGroup1);
        meanDataG2=mean(ccsDataGroup2);
        stdDataG2=std(ccsDataGroup2);

        firstCell = {[SplittedNames{2} ' - ' SplittedNames{3}]; ['UMAP descriptor: ' num2str(bestUMAP)]};
        comparisonsAndPCAdescriptor = char(firstCell);

        excelStructure{((nFiles-1)*numRows)+1,1}= [SplittedNames{1} ' - ' SplittedNames{2}];
        excelStructure{((nFiles-1)*numRows)+2,1}= ['UMAP descriptor: ' num2str(bestUMAP)];
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
    writetable(t,[rootPath 'featuresSelectedUMAP_' groupNames{nPathFiles} '_' date '.xls'], 'writevariablenames', false);
end