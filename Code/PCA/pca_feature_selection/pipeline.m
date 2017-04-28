%Pipeline
addpath('src')
addpath('src\lib')
load('D:\Pedro\MouseMuscleSOD1\PCA_data\Matrix_cc.mat')

m1={matrixCONT60,matrixCONT60,matrixCONT60,matrixCONT80,matrixCONT80,matrixCONT100,matrixG93A60,matrixG93A60,matrixG93A80,matrixWT80,matrixWT80,matrixWT100,matrixCONT60,matrixCONT80,matrixWT80,matrixWT80,matrixCONT100,matrixWT100,matrixWT100,matrixWT120};
m2={matrixCONT80(:, 1:69),matrixCONT100(:, 1:69),matrixCONT120(:, 1:69),matrixCONT100,matrixCONT120,matrixCONT120,matrixG93A80(:, 1:69),matrixG93A100(:, 1:69),matrixG93A100,matrixWT100,matrixWT120,matrixWT120,matrixG93A60,matrixG93A80,matrixCONT80,matrixG93A80,matrixG93A100,matrixCONT100,matrixG93A100,matrixCONT120};
name1={'Control 60','Control 60','Control 60','Control 80','Control 80','Control 100','G93A 60','G93A 60','G93A 80','WT 80','WT 80','WT 100','Control 60','Control 80','WT 80','WT 80','Control 100','WT 100','WT 100','WT 120'};
name2={'Control 80','Control 100','Control 120','Control 100','Control 120','Control 120','G93A 80','G93A 100','G93A 100','WT 100','WT 120','WT 120','G93A 60','G93A 80','Control 80','G93A 80','G93A 100','Control 100','G93A 100','Control 120'};


parfor i=1:length(m1)
    %PCA_2_cc_Original(matrix1, matrix2, 'Class1', 'Class2');
    PCA_2_cc_Original(m1{i},m2{i},name1{i},name2{i});
end

m1={matrixG93A60,matrixG93A80,matrixG93A100,matrixCONT120,matrixWT120};
m2={matrixG93A120(:, 1:69),matrixG93A120,matrixG93A120,matrixG93A120,matrixG93A120};
m3={matrixG93A130(:, 1:69),matrixG93A130,matrixG93A130,matrixG93A130,matrixG93A130};
name1={'G93A 60','G93A 80','G93A 100','Control 120','WT 120'};
name2={'G93A 120','G93A 120','G93A 120','G93A 120','G93A 120'};

parfor i=1:length(m1)
    %PCA_2_cc_Original_Aux(matrix1, matrix2, matrix3, 'Class1', 'Class2');
    PCA_2_cc_Original_Aux(m1{i},m2{i},m3{i},name1{i},name2{i});
end




