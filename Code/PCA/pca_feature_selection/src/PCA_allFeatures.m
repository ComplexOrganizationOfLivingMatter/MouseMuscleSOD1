%load('Matrix_cc_13-Nov-2020.mat')
indexAllFeaturesNoDapi = [1:62,65:69]; %All 67 features. It is like that because features 63 and 64 were repeated when extracted.

cellMatrices = {matrixCONT60;matrixCONT100;matrixCONT120;matrixG93A60;matrixG93A100;matrixG93A120;matrixG93A130};
cellMatricesNoNan = cellfun(@(x) x(cellfun(@(y) ~(length(isnan(y))==1),x(:,1)),:),cellMatrices,'UniformOutput',false);
lengthMat = cellfun(@length, cellMatricesNoNan);

mTotal = vertcat(cellMatricesNoNan{:});

indCont60 = 1:lengthMat(1);
indCont100 = lengthMat(1)+1:sum(lengthMat(1:2));
indCont120 = sum(lengthMat(1:2))+1:sum(lengthMat(1:3));
indG93A60 = sum(lengthMat(1:3))+1:sum(lengthMat(1:4));
indG93A100= sum(lengthMat(1:4))+1:sum(lengthMat(1:5));
indG93A120= sum(lengthMat(1:5))+1:sum(lengthMat(1:6));
indG93A130= sum(lengthMat(1:6))+1:sum(lengthMat(1:end));

mTotalClean = mTotal(:,2);
mTotalSelectedFeatures = cellfun(@(x) x(indexAllFeaturesNoDapi),mTotalClean,'UniformOutput',false);

matrixTotal=vertcat(cell2mat(mTotalSelectedFeatures));

[W, V] = pca_function(matrixTotal);

addpath(genpath(fullfile('..','UMAP','src')))
umapInit = UMAP;
umapInit.min_dist = 0.3;
umapInit.n_neighbors=30;
umapInit.n_components=2;
umapInit.randomize=true;
W_UMAP = umapInit.fit_transform(matrixTotal);

%%Represent Luisma format
colorC60=[0.5 0.9 0.9];
colorC100=[0 0 1];
colorC120=[0.1 0.3 0.8];


colorG60=[1 0.4 0.4];
colorG100=[1 0 0];
colorG120=[0.5 0 0.3];
colorG130=[0 0 0];

figure('Position', get(0, 'Screensize')); 
plot(W(1,indCont60),W(2,indCont60),'.','Color',colorC60,'MarkerSize',45)
hold on, 
plot(W(1,indCont100),W(2,indCont100),'.','Color',colorC100,'MarkerSize',45)
hold on, 
plot(W(1,indCont120),W(2,indCont120),'.','Color',colorC120,'MarkerSize',45)
hold on, 
plot(W(1,indG93A60),W(2,indG93A60),'.','Color',colorG60,'MarkerSize',45)
hold on, 
plot(W(1,indG93A100),W(2,indG93A100),'.','Color',colorG100,'MarkerSize',45)
hold on, 
plot(W(1,indG93A120),W(2,indG93A120),'.','Color',colorG120,'MarkerSize',45)
hold on, 
plot(W(1,indG93A130),W(2,indG93A130),'.','Color',colorG130,'MarkerSize',45)

%stringres=strcat(num2str(indexesCcsSelected));
xlabel('PC1')
ylabel('PC2')
legend({'C60','C100','C120','G60','G100','G120','G130'}, 'Location', 'bestoutside')
set(gca,'FontSize', 20)
set(gcf,'color','white')

% F = getframe(h);
% imwrite(F.cdata, [path2save 'PCA_' n_t1 '_' n_t2 '_selection_cc_' num2str(n_totalCcs) '.tiff'],'Resolution', 300);
% savefig(h,[path2save 'PCA_' n_t1 '_' n_t2 '_selection_cc_' num2str(n_totalCcs) '.fig'])



h=figure('Position', get(0, 'Screensize')); 
plot(W_UMAP(indCont60,1),W_UMAP(indCont60,2),'.','Color',colorC60,'MarkerSize',45)
hold on, 
plot(W_UMAP(indCont100,1),W_UMAP(indCont100,2),'.','Color',colorC100,'MarkerSize',45)
hold on, 
plot(W_UMAP(indCont120,1),W_UMAP(indCont120,2),'.','Color',colorC120,'MarkerSize',45)
hold on, 
plot(W_UMAP(indG93A60,1),W_UMAP(indG93A60,2),'.','Color',colorG60,'MarkerSize',45)
hold on, 
plot(W_UMAP(indG93A100,1),W_UMAP(indG93A100,2),'.','Color',colorG100,'MarkerSize',45)
hold on, 
plot(W_UMAP(indG93A120,1),W_UMAP(indG93A120,2),'.','Color',colorG120,'MarkerSize',45)
hold on, 
plot(W_UMAP(indG93A130,1),W_UMAP(indG93A130,2),'.','Color',colorG130,'MarkerSize',45)
legend({'C60','C100','C120','G60','G100','G120','G130'}, 'Location', 'bestoutside')
xlabel('UMAP1')
ylabel('UMAP2')
set(gca,'FontSize', 20)
set(gcf,'color','white')


