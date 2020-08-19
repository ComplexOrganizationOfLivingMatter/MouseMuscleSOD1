%Pipeline
load('..\..\PCA_data\Matrix_cc_04-May-2018.mat')
addpath(genpath('lib'))

indCONT60=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT60(:,1));
indCONT80=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT80(:,1));
indCONT100=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT100(:,1));
indCONT120=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT120(:,1));
%indWT80=cellfun(@(x) ~(length(isnan(x))==1),matrixWT80(:,1));
%indWT100=cellfun(@(x) ~(length(isnan(x))==1),matrixWT100(:,1));
indWT120=cellfun(@(x) ~(length(isnan(x))==1),matrixWT120(:,1));
indG93A60=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A60(:,1));
indG93A80=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A80(:,1));
indG93A100=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A100(:,1));
indG93A120=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A120(:,1));
indG93A130=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A130(:,1));

indCell = {indCONT60, indCONT80, indCONT100, indCONT120,indG93A60, indG93A80, indG93A100, indG93A120,indG93A130, indWT120};
matCell = {matrixCONT60, matrixCONT80, matrixCONT100, matrixCONT120,matrixG93A60, matrixG93A80, matrixG93A100, matrixG93A120,matrixG93A130,matrixWT120};

numRandom = 100;

delete(gcp('nocreate'))
parpool(8)
for nGen = 1:length(indCell)
    
    indValid = indCell{nGen};
    matGen = matCell{nGen};
    matGenValid  = matGen(indValid,:);
    
    for nImages = 1:size(matGenValid,1)
        pathImage = matGenValid{nImages,1};
        path2load = strrep(pathImage(4:end),'Results_69_cc.mat','');
        path2save = strrep(path2load,'Data_image\','');
        if ~exist([path2save 'GDD\'],'dir')
            load([path2load 'Data_cc.mat'],'cells_L','valid_cells','slow_cells','fast_cells');

            cells_L_valid = ismember(cells_L,valid_cells);
            centroids = regionprops(cells_L,'Centroid');
            centroids = cat(1,centroids.Centroid);
            centroidsSlowCells = centroids(slow_cells,:);
            centroidsFastCells = centroids(fast_cells,:);
            noValidCells = unique(cells_L);
            noValidCells = noValidCells(~ismember(noValidCells,[0; slow_cells; fast_cells]));
            centroidsNoValidCells = centroids(noValidCells,:);

            mkdir([path2save 'GDD\'])
            disp(path2save)
            %imwrite(cells_L_valid,[path2save 'GDD\segmentedImage_validCells.tiff'])
            imwrite(cells_L>0,[path2save 'GDD\segmentedImage.tiff'])
            csvwrite([path2save 'GDD\centroidsSlowCells.csv'],centroidsSlowCells);
            %csvwrite([path2save 'GDD\centroidsFastCells.csv'],centroidsFastCells); 
            %csvwrite([path2save 'GDD\centroidsNoValidCells.csv'],centroidsNoValidCells); 

            mkdir([path2save 'GDD\VoronoiControl\'])

            parfor nRea = 1:numRandom
                generateVoronoiControl(length(slow_cells),cells_L,[path2save 'GDD\VoronoiControl\'],nRea)
            end
        end
    end
    
    
end
