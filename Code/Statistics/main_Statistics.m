%Comparing features 

clear all;
folder_data='..\..\PCA_data\';
filename = 'Matrix_cc_13-Nov-2020.mat';

load([folder_data filename])

%discard NaN images
indCONT60=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT60(:,1));
indCONT80=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT80(:,1));
indCONT100=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT100(:,1));
indCONT120=cellfun(@(x) ~(length(isnan(x))==1),matrixCONT120(:,1));
indWT120=cellfun(@(x) ~(length(isnan(x))==1),matrixWT120(:,1));

indG93A60=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A60(:,1));
indG93A80=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A80(:,1));
indG93A100=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A100(:,1));
indG93A120=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A120(:,1));
indG93A130=cellfun(@(x) ~(length(isnan(x))==1),matrixG93A130(:,1));

cont60 = vertcat(matrixCONT60{indCONT60,2});
cont80 = vertcat(matrixCONT80{indCONT80,2});
cont100 = vertcat(matrixCONT100{indCONT100,2});
cont120 = vertcat(matrixCONT120{indCONT120,2});
g93a60 = vertcat(matrixG93A60{indG93A60,2});
g93a80 = vertcat(matrixG93A80{indG93A80,2});
g93a100 = vertcat(matrixG93A100{indG93A100,2});
g93a120 = [vertcat(matrixG93A120{indG93A120,2});vertcat(matrixG93A130{indG93A130,2})];
wt120 = vertcat(matrixWT120{indWT120,2});






tableStatsCont60_Cont80 = compareMeansOfMatrices(cont60,cont80);
tableStatsCont80_Cont100 = compareMeansOfMatrices(cont80,cont100);
tableStatsCont100_Cont120 = compareMeansOfMatrices(cont100,cont120);

tableStatsG93A60_G93A80 = compareMeansOfMatrices(g93a60,g93a80);
tableStatsG93A80_G93A100 = compareMeansOfMatrices(g93a80,g93a100);
tableStatsG93A100_G93A120 = compareMeansOfMatrices(g93a100,g93a120);

tableStatsCont60_G93A60 = compareMeansOfMatrices(cont60,g93a60);
tableStatsCont80_G93A80 = compareMeansOfMatrices(cont80,g93a80);
tableStatsCont100_G93A100 = compareMeansOfMatrices(cont100,g93a100);
tableStatsCont120_G93A120 = compareMeansOfMatrices(cont120,g93a120);


