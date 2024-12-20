function [BetterPCAs,Proy, eigenvectorsF]=add_cc_original(BetterPCAs_bef,matrixAllCCs,expansion,nImgType1,nImgType2)
count=0;
Niteration=1;
BetterPCAs=[];
BetterPCAs_bef(BetterPCAs_bef(:,1)==0,:)=[];
for rowCCs=1:size(BetterPCAs_bef,1)
    W={};eigenvectors={};Ratio_pca=[];
    ccsRow=BetterPCAs_bef(rowCCs,2:size(BetterPCAs_bef,2));
    
    for nCC=1:size(matrixAllCCs,2)
        
        matrixChosenCcs=[];
        matrixChosenCcs=matrixAllCCs(:,ccsRow);
        
        if isempty(find(nCC==ccsRow))==1
            p1=sum(matrixAllCCs(:,nCC));
            % all ccs nan or 0. PCA & eigenvectors = 0
            if p1==0
                Ratio_pca(1:2,Niteration)=[0,nCC];
                eigenvectors{1,Niteration} = 0;
            else
                %Include CC to CCs before
                matrixChosenCcs=[matrixChosenCcs,matrixAllCCs(:,nCC)];

                %% PCA
                [W,eigenvectors,Ratio_pca]=calculatePCAValues(matrixChosenCcs,Niteration,nImgType1,nImgType2,W,eigenvectors,Ratio_pca,[ccsRow,nCC]);
            
            end
            Niteration=Niteration+1;
        end
    end
    
    
    
    
    %% Expansion without repetition
    auxiliar=Ratio_pca(1,:);
    for i=1:expansion
        %If there are more than a row, check repeated vectors of ccs
        if isempty(BetterPCAs)==0
            [~, maxPcaIndex]=max(auxiliar);
            newPCARow=Ratio_pca(:,maxPcaIndex)';
            
            %Checked former rows comparing with new row
            r=1;
            while r<size(BetterPCAs,1)+1               
                if length(find(sort(BetterPCAs(r,2:end))==sort(newPCARow(1,2:end))))==size(BetterPCAs,2)-1
                    auxiliar(1,maxPcaIndex)=0;
                    [~, maxPcaIndex]=max(auxiliar);
                    newPCARow=Ratio_pca(:,maxPcaIndex)';
                    
                % else
                %     r=r+1;
                end
                r=r+1;
            end
            %add if different row exist
            if isempty(newPCARow)==0
                BetterPCAs(count+i,1)=Ratio_pca(1,maxPcaIndex);
                for j=2:size(BetterPCAs_bef,2)
                    BetterPCAs(count+i,j)=BetterPCAs_bef(rowCCs,j);
                end
                BetterPCAs(count+i,size(BetterPCAs_bef,2)+1)=Ratio_pca(end,maxPcaIndex);
                Proy{count+i,1}=W{1,maxPcaIndex};
                eigenvectorsF{count+i,1} = eigenvectors{1, maxPcaIndex};
                auxiliar(1,maxPcaIndex)=0;
            end
            
        %When BetterPCAs isempty add row
        else
            [BetterPCAs(count+i,1) maxPcaIndex]=max(auxiliar);

            for j=2:size(BetterPCAs_bef,2)
                BetterPCAs(count+i,j)=BetterPCAs_bef(rowCCs,j);
            end
            BetterPCAs(count+i,size(BetterPCAs_bef,2)+1)=Ratio_pca(end,maxPcaIndex);
            Proy{count+i,1}=W{1,maxPcaIndex};
            eigenvectorsF{count+i,1} = eigenvectors{1, maxPcaIndex};
            auxiliar(1,maxPcaIndex)=0;
            
        end
    end
    
   
    count=count+expansion;
    clear W Ratio_pca
end

