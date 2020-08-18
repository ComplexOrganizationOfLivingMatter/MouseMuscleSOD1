function generateVoronoiControl(nSlowCells,cells_L,path2save,nRealization)

    [H,W] = size(cells_L);
    nSeeds = max(cells_L(:));
    distanceBetwSeeds = 4;%to avoid overlapping

    [seeds] = chooseSeedsPositions(1,H,W,nSeeds,distanceBetwSeeds);

    img=zeros(H,W); % Define image to assign seeds
    %placing the seeds
    for k=1:size(seeds,1)
        img(seeds(k,1),seeds(k,2))=1;
    end

    D = bwdist(img);        % Apply transform of distance
    voronoiImage = watershed(D);      % Split in regions closer to seed

    noValidCellsVoronoi = unique([unique(voronoiImage(1:end,1));unique(voronoiImage(1:end,end));unique(voronoiImage(1,1:end))';unique(voronoiImage(end,1:end))']);
    noValidCellsVoronoi = noValidCellsVoronoi(noValidCellsVoronoi~=0);
    validCellsVoronoi = 1:nSeeds;
    validCellsVoronoi = validCellsVoronoi(~ismember(validCellsVoronoi,noValidCellsVoronoi));
    
    %select random slow cells
    p = randperm(length(validCellsVoronoi),nSlowCells);
    idSlowCells = validCellsVoronoi(p);
    
    
    centroids = regionprops(voronoiImage,'Centroid');
    centroids = cat(1,centroids.Centroid);
    centroidsSlowCells = centroids(idSlowCells,:);
    csvwrite([path2save 'centroidsSlowCells_Voronoi_' num2str(nRealization) '.csv'],centroidsSlowCells);
    imwrite(voronoiImage>0,[path2save 'voronoi_' num2str(nRealization) '.tiff'])

end