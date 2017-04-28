%%PCA_2_cc
function PCA_2_cc_Original(m_t1,m_t2,m_t3,n_t1,n_t2)

    %Summary of process:
    % 1-Calculate 10 betters trios
    % 2-Compare each individual cc VS each of 10 trios. Getting 5 betters descriptors by trio, with a total of 50 quartets of cc (5x10)
    % 3-Repeat process before saving 2 best cc for quartets (5x10x2). Total of 100 quintets
    % Finally, adding a 'cc' until 7 ccs or until get lower descriptor of PCA
    % than step before.

    %Define expansion in process
    expansion=[5 2 1 1];
    maxExpansion=4; %exted expansion array for more complexity

    %% Parameters Initialization
    %Selection of specified ccs
    totalCharactsIndexes=1:size(m_t1, 2); %num of columns

    %Asignation to groups by matrixes
    % Group 1
    matrixT1=m_t1;
    nImgType1=size(matrixT1,1);

    % Group 2
    matrixT2=m_t2;
    nImgType2=size(matrixT2,1);
    
    % Group 3
    matrixT3=m_t3;
    nImgType3=size(matrixT3,1);
    

    %All ccs matrix
    matrixAllCCs=[matrixT1;matrixT2;matrixT3];

    %Number of images and ccs
    n_images=nImgType1+nImgType2+nImgType3;
    n_totalCcs=length(totalCharactsIndexes);


    %Unitary matrix by type. A column by class
    unitaryMatrixByType=zeros([n_images,2]);
    unitaryMatrixByType(1:nImgType1,1)=1;
    unitaryMatrixByType(nImgType1+1:n_images,2)=1;

    %% Calculate all trios of characteristics
    nIteration=1;
    W={};eigenvectors={};Ratio_pca=[];
    for cc1=1:n_totalCcs-2
        for cc2=cc1+1:n_totalCcs-1
            for cc3=cc2+1:n_totalCcs
                 %Include trio of ccs for all images
                 matrixChosenCcs(:,1:3)=[matrixAllCCs(:,cc1) ,matrixAllCCs(:,cc2),matrixAllCCs(:,cc3)];

                 %Normalizing each cc
                 for cc=1:3
                    matrixChosenCcs(:,cc)=matrixChosenCcs(:,cc)-min(matrixChosenCcs(:,cc));
                    matrixChosenCcs(:,cc)=matrixChosenCcs(:,cc)/max(matrixChosenCcs(:,cc));  
                 end

                 %3 cc for all images
                 matrixChosenCcs(isnan(matrixChosenCcs))=0;% Do 0 all NaN

                %Calculate proyections, eigenvectors and ratios of PCA
                %accumulative
                [W,eigenvectors,Ratio_pca]=calculatePCAValues(matrixChosenCcs,nIteration,nImgType1,nImgType2+nImgType3,W,eigenvectors,Ratio_pca,[cc1,cc2,cc3]);

                %counter + 1
                nIteration=nIteration+1;

            end
        end
    end

    %% Filtering best 10 PCA and their 3 ccs
    auxiliar=Ratio_pca(1,:)';
    nOfBest=10;
    [~, indexBetter]=sort(auxiliar,'descend');
    indexBetter=indexBetter(1:nOfBest);
    BetterPCAs(1:nOfBest,1:4)=[Ratio_pca(1,indexBetter);Ratio_pca(2,indexBetter);Ratio_pca(3,indexBetter);Ratio_pca(4,indexBetter)]';
    best_eigenvectors = eigenvectors(indexBetter);
    eigenvectors = best_eigenvectors;
    Proy=W(1,indexBetter);


    %% Expansion

    expansionIndex=1;


    BettersPCAEachStep{1} = BetterPCAs;
    eigenvectorsEachStep{1} = best_eigenvectors;
    proyEachStep{1} = Proy';

    %Max of 4 expansions.
    while expansionIndex <= maxExpansion
        expansionIndex
        BetterPCAs_bef=BetterPCAs;
        clear Proy
        [BetterPCAs,Proy, eigenvectors]=add_cc_original(BetterPCAs_bef,matrixAllCCs,expansion(expansionIndex),nImgType1,nImgType2+nImgType3);

        % Sort BetterPCAs from best to worst PCA
        [BetterPCAs rowOrder]=sortrows(BetterPCAs,-1);

        for i=1:size(rowOrder,1)
            Proyb{i,1}=Proy{rowOrder(i),1};
            eigenvectorsb{i,1} = eigenvectors(rowOrder(i), 1);
        end
        Proy=Proyb;
        eigenvectors = eigenvectorsb;
        clear eigenvectorsb
        clear Proyb

        %expansion counter
        expansionIndex=expansionIndex+1;

        BettersPCAEachStep{expansionIndex} = BetterPCAs;
        eigenvectorsEachStep{expansionIndex} = eigenvectors;
        proyEachStep{expansionIndex} = Proy;
    end

    %% Final evaluation
    [~, numIter] = max(cellfun(@(x) max(x(:,1)), BettersPCAEachStep));
    bestIterationPCA = BettersPCAEachStep{numIter};
    [bestPCA, numRow] = max(bestIterationPCA(:, 1));
    indexesCcsSelected=bestIterationPCA(numRow, 2:size(bestIterationPCA,2));
    eigenvectors = eigenvectorsEachStep{numIter};
    eigenvectors = eigenvectors{numRow};
    Proy = proyEachStep{numIter};
    Proy = Proy{numRow};


    save( ['D:\Pedro\MouseMuscleSOD1\PCA_data\PCA_data_by_groups\PCA_' n_t1 '_' n_t2 '_selection_cc_' num2str(n_totalCcs)], 'BettersPCAEachStep', 'Proy', 'bestPCA','indexesCcsSelected', 'eigenvectors')

    switch lower(n_t1(1:2))
        
        case 'wt'
            color1=[0,1,0];
        case 'co'
            color1=[0,0,1];
        case 'g9'
            color1=[1,0,0];
    end
    
    switch lower(n_t2(1:2))
        
        case 'wt'
            color2=[0,1,0];
        case 'co'
            color2=[0,0,1];
        case 'g9'
            color2=[1,0,0];
            color3=[160,0,0]/255;
    end
    
    if strcmp(lower(n_t1(1:2)),lower(n_t2(1:2)))==1
        color2=color1/2;
        color3=color2/2;
    end
    
    %%Represent Luisma format
    Proyecc=Proy;
    h=figure; plot(Proyecc(1,1:nImgType1),Proyecc(2,1:nImgType1),'.','Color',color1,'MarkerSize',30)
    hold on, plot(Proyecc(1,nImgType1+1:nImgType1+nImgType2),Proyecc(2,nImgType1+1:nImgType1+nImgType2),'.','Color',color2,'MarkerSize',30)
    hold on, plot(Proyecc(1,nImgType1+nImgType2+1:nImgType1+nImgType2+nImgType3),Proyecc(2,nImgType1+nImgType2+1:nImgType1+nImgType2+nImgType3),'.','Color',color3,'MarkerSize',30)
    
    %stringres=strcat(num2str(indexesCcsSelected));
    stringres=strcat('PCA analysis selected features:',num2str(indexesCcsSelected),' Descriptor: ',num2str(bestPCA));
    title(stringres)
    legend(n_t1,n_t2, 'Location', 'bestoutside')
    saveas(h,['D:\Pedro\MouseMuscleSOD1\PCA_data\PCA_data_by_groups\PCA_' n_t1 '_' n_t2 '.jpg'])

    close all
end
