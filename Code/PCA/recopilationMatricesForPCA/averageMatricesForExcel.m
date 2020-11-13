
load('..\..\..\PCA_data\Matrix_cc_13-Nov-2020.mat')

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

matricesList={vertcat(matrixCONT60{:,2}),vertcat(matrixCONT80{:,2}),vertcat(matrixCONT100{:,2}),...
    vertcat(matrixCONT120{:,2}),vertcat(matrixWT80{:,2}),vertcat(matrixWT100{:,2}),...
    vertcat(matrixWT120{:,2}),vertcat(matrixG93A60{:,2}),vertcat(matrixG93A80{:,2}),...
    vertcat(matrixG93A100{:,2}),[vertcat(matrixG93A120{:,2});vertcat(matrixG93A130{:,2})]};

indexesList={indCONT60,indCONT80,indCONT100,indCONT120,indWT80,indWT100,...
    indWT120,indG93A60,indG93A80,indG93A100,[indG93A120;indG93A130]};

indexesGeometricCcs=[1 2 7:16 23:36 41 42 47 48 53 54 59 60];

cellMatrix=cell(81,size(matricesList,2));

for i = 1:length(matricesList)
    
    m=matricesList{i};
    
    numCCs=size(m,2);
    auxMatrix=zeros(numCCs,2);
    
    filterNanMatrix=m(indexesList{i},:);
    
    meanCCsFilter=mean(filterNanMatrix);
    stdCCsFilter=std(filterNanMatrix);
    meanCCs=mean(filterNanMatrix);
    stdCCs=std(filterNanMatrix);
    
    auxMatrix(:,1)=meanCCsFilter';
    auxMatrix(:,2)=stdCCsFilter';
    auxMatrix(indexesGeometricCcs,1)=meanCCs(indexesGeometricCcs)';
    auxMatrix(indexesGeometricCcs,2)=stdCCs(indexesGeometricCcs)';
    
    cellColumnForExcel=arrayfun(@(x,y) [num2str(round(x,2)) ' (+-' num2str(round(y,2)) ')'], auxMatrix(:,1),auxMatrix(:,2),'UniformOutput',false);
    
    cellMatrix(1:numCCs,i)=cellColumnForExcel;
end

T=cell2table(cellMatrix,'VariableNames',{'CONT60','CONT80','CONT100','CONT120','WT80','WT100','WT120','G93A60','G93A80','G93A100','G93A120'});

writetable(T,['..\..\..\PCA_data\tableAverageCharacteristics_' date '.xls'])
