function [W, V] = pca_function(matrixChosenCcs)

        %Operations to calculate PCA ratio and weight
        X=matrixChosenCcs';
        meanCCs=mean(X,2);
     
        for i = 1:size(X,2)
           X(:,i) = X(:,i) - meanCCs;
        end
        
        L = X'*X;
          
        %Calculate autovectors/eigenvalues
        [eigenvectors,eigenvalues] = eig(L);
        [sortedEigenvalues,ind]=sort(diag(eigenvalues),'descend');   % sort eigenvalues
        V=eigenvectors(:,ind);
        
        %Convert  eigenvalues of X'X in autovectors of X*X'
        eigenvectors = X*V;
        
        % Normalize autovectors to achieve an unitary length
        for i=1:size(X,2)
            eigenvectors(:,i) = eigenvectors(:,i)/norm(eigenvectors(:,i));
        end
        
        V=eigenvectors(:,1:2);
        
        %Projections
        W=V'*X; 
        
end