%main script dealing with the image segmentation and features extraction on the muscle images
clear all
close all

addpath(genpath(fullfile('..')))

%Select the path where the segmented images are stored.
% This is an example of hierchachical organization of the images:
%       "<PARENT FOLDER>\<AGE>\<GENOTYPE>\<DAY OF IMAGING>\<IMAGE ID>"
%       eg. "Photos\100 days\CONT\01-03-2016\CONT-H-100-24-SD-CMSD-2A40X"

% Select <PARENT FOLDER>
selpath = uigetdir('..');

% Reading <AGE> folders
folder_days=dir(selpath);


for i=3:size(folder_days,1)
        
        % Reading <GENOTYPE> folders
        folder_type_images = dir(fullfile(folder_days(i).folder, folder_days(i).name));         

        for j=3:size(folder_type_images,1)

            %Reading <DAY OF IMAGING> folders
            folder_date_images = dir(fullfile(folder_type_images(j).folder, folder_type_images(j).name));

            for k=3:size(folder_date_images,1)

                %Reading <IMAGE ID> folders. Folder hosting the microscopy images from the muscle biopsies
                folder_images = dir(fullfile(folder_date_images(k).folder, folder_date_images(k).name));        
                warning('off','all')

                for l=3:size(folder_images,1)
    
                    %1. Applying SEGMENTATION pipeline
                    Segmentation(fullfile(folder_images(l).folder, folder_images(l).name));

                    %2. Applying FEATURE EXTRACTION pipeline once image segmentation is properly curated
                    Extraction_67ccs(fullfile(folder_images(l).folder, folder_images(l).name));
                    disp(['67 ccs - ' folder_images(l).name])

                end
                            
            end
            
        end
end
            