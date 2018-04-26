pathPCAresults='..\..\PCa_data\PCA_data_by_groups\';

tableCcs=readtable('..\..\docs\list_81_cc.xls');

pathFilesPca=dir([pathPCAresults,'*.mat']);

maxNumCcs=7;

for nFiles=1:length(pathFilesPca)
   
    load([pathPCAresults pathFilesPca(nFiles).name])
    
    comparisonName = strrep(pathFilesPca(nFiles).name,'PCA_','');
    comparisonName = strrep(comparisonName(1:end-20),'_',' - ');
    
    pcaDescriptor = bestPCA;
    
    weightCcs=cell2mat(eigenvectors);
    [absWeightCcsCol,indCol]=max(abs(weightCcs),[],2);
    [absWeightCcs,indRow]=sort(absWeightCcsCol,'descend');
    
    ccsOrderedByWeight=zeros(1,maxNumCcs);
    ccsOrderedByWeight(1:length(indRow))=indexesCcsSelected(indRow);
        
    ccsWithWeight=[ccsOrderedByWeight;absWeightCcs'];
    
end
