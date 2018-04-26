rootPath='..\..\..\PCA_data\';
pathProcData='..\..\..\Processed_images\';
load([rootPath 'pathImagesWithoutColoredCells.mat'],'imagesWithoutColoredCells')


CONT60=getAllFiles([pathProcData '60 days\CONT']);
CONT60=CONT60(cellfun(@(x) ~isempty(strfind(lower(x),'sol')),CONT60));
matrixCONT60=storingCCMatrices(CONT60,imagesWithoutColoredCells);

G93A60=getAllFiles([pathProcData '60 days\G93A']);
G93A60=G93A60(cellfun(@(x) ~isempty(strfind(lower(x),'sol')),G93A60));
matrixG93A60=storingCCMatrices(G93A60,imagesWithoutColoredCells);

G93A80=getAllFiles([pathProcData '80 days\G93A']);
matrixG93A80=storingCCMatrices(G93A80,imagesWithoutColoredCells);

WT80=getAllFiles([pathProcData '80 days\WT']);
matrixWT80 = storingCCMatrices(WT80,imagesWithoutColoredCells);

CONT80=getAllFiles([pathProcData '80 days\CONT']);
matrixCONT80= storingCCMatrices(CONT80,imagesWithoutColoredCells);

CONT100=getAllFiles([pathProcData '100 days\CONT']);
matrixCONT100= storingCCMatrices(CONT100,imagesWithoutColoredCells);

G93A100=getAllFiles([pathProcData '100 days\G93A']);
matrixG93A100=storingCCMatrices(G93A100,imagesWithoutColoredCells);

WT100=getAllFiles([pathProcData '100 days\WT']);
matrixWT100=storingCCMatrices(WT100,imagesWithoutColoredCells);

CONT120=getAllFiles([pathProcData '120 days\CONT']);
matrixCONT120=storingCCMatrices(CONT120,imagesWithoutColoredCells);

G93A120=getAllFiles([pathProcData '120 days\G93A']);
matrixG93A120=storingCCMatrices(G93A120,imagesWithoutColoredCells);

WT120=getAllFiles([pathProcData '120 days\WT']);
matrixWT120=storingCCMatrices(WT120,imagesWithoutColoredCells);

G93A130=getAllFiles([pathProcData '130 days\G93A']);
matrixG93A130=storingCCMatrices(G93A130,imagesWithoutColoredCells);



save([rootPath 'Matrix_cc_' date '.mat'], 'matrixCONT60', 'matrixG93A60', 'matrixG93A80', 'matrixWT80', 'matrixCONT80', 'matrixCONT100', 'matrixG93A100', 'matrixWT100', 'matrixCONT120', 'matrixG93A120', 'matrixWT120', 'matrixG93A130')
