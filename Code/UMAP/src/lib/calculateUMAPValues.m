function [reduction,eigenvectors,Ratio_UMAP]=calculateUMAPValues(matrixChosenCcs,nIteration,nImgType1,nImgType2,reduction,eigenvectors,Ratio_UMAP,ccsChosen)
            
        %%Get UMAP reduction
%         [reduction{1,nIteration},~]=run_umap(matrixChosenCcs,'verbose','none');
        umapInit = UMAP;
        umapInit.min_dist = 0.3;
        umapInit.n_neighbors=30;
        umapInit.n_components=2;
        umapInit.randomize=true;
        reduction{1,nIteration} = umapInit.fit_transform(matrixChosenCcs);
        close all
        %% Getting numbers from method3 graphics (LUCIANO) and Storing PCA Ratio for chosen ccs
        label=[ones(1, nImgType1), 2*ones(1,nImgType2)];
        [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(reduction{1,nIteration},label,2);
        %ratio PCA
        C=sinterluc/sintraluc;
        %ratio pca,cc1,cc2,cc3
        Ratio_UMAP(:,nIteration)=[trace(C);ccsChosen(:)];

        %% Store eigenvectors
        V= reduction{1,nIteration}'*matrixChosenCcs;
        eigenvectors{nIteration} = V; 
        
        
        
end