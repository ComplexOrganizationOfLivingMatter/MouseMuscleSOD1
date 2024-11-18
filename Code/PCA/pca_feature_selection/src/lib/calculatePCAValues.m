function [W,eigenvectors,Ratio_pca]=calculatePCAValues(matrixChosenCcs,nIteration,nImgType1,nImgType2,W,eigenvectors,Ratio_pca,ccsChosen)
        

        % W -> projection weights
        [W{1,nIteration}, eigenvectors{nIteration}] = pca_function(matrixChosenCcs);
        

        %% Getting numbers from method3 graphics (LUCIANO) and Storing PCA Ratio for chosen ccs
        label=[ones(1, nImgType1), 2*ones(1,nImgType2)];
        [T, sintraluc, sinterluc, Sintra, Sinter] = valid_sumsqures(W{1,nIteration}',label,2);
        %ratio PCA
        C=sinterluc/sintraluc;
        %ratio pca,cc1,cc2,cc3
        Ratio_pca(:,nIteration)=[trace(C);ccsChosen(:)];
       
        
        
end