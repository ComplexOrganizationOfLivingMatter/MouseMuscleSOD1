clear all
close all

addpath(genpath('src'))

folderDays = dir('..\..\UMAP_data\UMAP_data_by_groups\');
nRand = 10;

for nDay = 3:size(folderDays,1)
    
    folderGroups = dir(fullfile(folderDays(nDay).folder,folderDays(nDay).name));
    for nGroups = 3:size(folderGroups,1)
        
        folderCcs = dir(fullfile(folderGroups(nGroups).folder,folderGroups(nGroups).name));
        
        for nCCs = 3:size(folderCcs,1)
            allMats = dir([fullfile(folderCcs(nCCs).folder,folderCcs(nCCs).name),'\*.mat']);
            
            numberOfRand = size(allMats,1);
            if numberOfRand~=0
                listOfFeatures = cell(1,numberOfRand);
                bestUMAPRandoms = zeros(1,numberOfRand);
                for nMat = 1:numberOfRand
                    load(fullfile(allMats(nMat).folder,allMats(nMat).name))
                    listOfFeatures{nMat} = indexesCcsSelected;
                    bestUMAPRandoms(nMat) = bestUMAP;
                end

                numberOfFeatures = cellfun(@length, listOfFeatures);
                modeNFeatures = mode(numberOfFeatures);
                allccs = horzcat(listOfFeatures{:});
                [GC,GR] = groupcounts(allccs');
                [ai,bi]=sort(GC,'descend');
                selectedFeatures = GR(bi(1:modeNFeatures))';
                meanUMAPdescriptor = mean(bestUMAPRandoms);
                                
                save(fullfile(folderGroups(nGroups).folder,folderGroups(nGroups).name,['meanDescriptorAndFrequentFeatures_', strrep(folderCcs(nCCs).name,' ','')]),'selectedFeatures','meanUMAPdescriptor')
            end
        end
        
    end
end