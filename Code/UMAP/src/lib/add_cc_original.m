function [BetterUMAPs,Proy, eigenvectorsF]=add_cc_original(BetterUMAPs_bef,matrixAllCCs,expansion,nImgType1,nImgType2)
count=0;
Niteration=1;
BetterUMAPs=[];
for rowCCs=1:size(BetterUMAPs_bef,1)
    W={};eigenvectors={};Ratio_UMAP=[];
    ccsRow=BetterUMAPs_bef(rowCCs,2:size(BetterUMAPs_bef,2));
    ccsRow(ccsRow<=0)=[];
    for nCC=1:size(matrixAllCCs,2)
        
        matrixChosenCcs=[];
        matrixChosenCcs=matrixAllCCs(:,ccsRow);
        
        if isempty(find(nCC==ccsRow))==1
            p1=sum(matrixAllCCs(:,nCC));
            % all ccs nan or 0. PCA & eigenvectors = 0
            if p1==0
                Ratio_UMAP(1:2,Niteration)=[0,nCC];
                eigenvectors{1,Niteration} = 0;
            else
                %Include CC to CCs before
                matrixChosenCcs=[matrixChosenCcs,matrixAllCCs(:,nCC)];

                %normalize matrixes
                for charac=1:size(matrixChosenCcs,2)
                    matrixChosenCcs(:,charac)=matrixChosenCcs(:,charac)-min(matrixChosenCcs(:,charac));
                    matrixChosenCcs(:,charac)=matrixChosenCcs(:,charac)/max(matrixChosenCcs(:,charac));
                end
                matrixChosenCcs(isnan(matrixChosenCcs))=0;% 0 NaNs

                %% PCA
                [W,eigenvectors,Ratio_UMAP]=calculateUMAPValues(matrixChosenCcs,Niteration,nImgType1,nImgType2,W,eigenvectors,Ratio_UMAP,[ccsRow,nCC]);
            
            end
            Niteration=Niteration+1;
        end
    end
    
    
    
    
    %% Expansion without repetition
    auxiliar=Ratio_UMAP(1,:);
    for i=1:expansion
        %If there are more than a row, check repeated vectors of ccs
        if isempty(BetterUMAPs)==0
            [~, maxUMAPIndex]=max(auxiliar);
            newPCARow=Ratio_UMAP(:,maxUMAPIndex)';
            
            %Checked former rows comparing with new row
            r=1;
            while r<size(BetterUMAPs,1)+1
                if length(BetterUMAPs(r,2:end))==length(newPCARow(1,2:end))
                    if length(find(sort(BetterUMAPs(r,2:end))==sort(newPCARow(1,2:end))))==size(BetterUMAPs,2)-1
                        auxiliar(1,maxUMAPIndex)=0;
                        [~, maxUMAPIndex]=max(auxiliar);
                        newPCARow=Ratio_UMAP(:,maxUMAPIndex)';
                        r=1;
                    else
                        r=r+1;
                    end
                else
                    r=r+1;
                end
            end
            %add if different row exist
            if isempty(newPCARow)==0
                BetterUMAPs(count+i,1)=Ratio_UMAP(1,maxUMAPIndex);
                for j=2:size(BetterUMAPs_bef,2)
                    BetterUMAPs(count+i,j)=BetterUMAPs_bef(rowCCs,j);
                end
                BetterUMAPs(count+i,size(BetterUMAPs_bef,2)+1)=Ratio_UMAP(end,maxUMAPIndex);
                Proy{count+i,1}=W{1,maxUMAPIndex};
                eigenvectorsF{count+i,1} = eigenvectors{1, maxUMAPIndex};
                auxiliar(1,maxUMAPIndex)=0;
            end
            
        %When BetterPCAs isempty add row
        else
            [BetterUMAPs(count+i,1) maxUMAPIndex]=max(auxiliar);

            for j=2:size(BetterUMAPs_bef,2)
                BetterUMAPs(count+i,j)=BetterUMAPs_bef(rowCCs,j);
            end
            BetterUMAPs(count+i,size(BetterUMAPs_bef,2)+1)=Ratio_UMAP(end,maxUMAPIndex);
            Proy{count+i,1}=W{1,maxUMAPIndex};
            eigenvectorsF{count+i,1} = eigenvectors{1, maxUMAPIndex};
            auxiliar(1,maxUMAPIndex)=0;
            
        end
    end
    
   
    count=count+expansion;
    clear W Ratio_UMAP
end

