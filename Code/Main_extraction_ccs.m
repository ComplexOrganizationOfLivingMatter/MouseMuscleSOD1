%main script dealing with the extraction of the muscle features from the segmented images
clear all
close all

addpath(genpath(fullfile('..')))

%Select path where the segmented images are stored in
selpath = uigetdir('..');
folder_days=dir(selpath);


for i=3:size(folder_days,1)  %problemas WT-SOD-M-120-49-SD-CMSD-2A40X
        %Read all the subfolders
        folder_type_images = dir(fullfile(folder_days(i).folder, folder_days(i).name));        
        
        for j=3:size(folder_type_images,1)
            %Read all subfolders
            folder_date_images = dir(fullfile(folder_type_images(j).folder, folder_type_images(j).name));
            for k=3:size(folder_date_images,1)
                %Read all files (name of photo)
                folder_images = dir(fullfile(folder_date_images(k).folder, folder_date_images(k).name));        

                warning('off','all')

                for l=3:size(folder_images,1)
    
                    %Segmentation
                    Segmentation(fullfile(folder_images(l).folder, folder_images(l).name));

                    %Feature extraction
                    [valid_cells]=Extraction_69ccs(fullfile(folder_images(l).folder, folder_images(l).name));
                    disp(['69 ccs - ' folder_images(l).name])

                end
                            
            end
            
        end
end
            