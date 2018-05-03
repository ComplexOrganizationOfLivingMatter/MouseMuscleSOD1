%This script is the main program which manages the total extraction of
%charasteristics from all segmented images

%This concatenation of loop for travels around all paths of images to
%process them.

clear all
close all


cd ..
cd Photos

%Read all folders in path current (folder days)
[stat,struc] = fileattrib;
PathCurrent = struc.Name;

folder_days = dir(PathCurrent);
folder_days(1:2)=[];


% listOfFolder={};

for i=1:length(folder_days)  %problemas WT-SOD-M-120-49-SD-CMSD-2A40X
    
    days=folder_days(i).name;
    cd (days)
    %Read all folders in path current (folder type images)
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    folder_type_images = dir(PathCurrent);
    folder_type_images(1:2)=[];
    
    for j=1:length(folder_type_images)
        folder_type=folder_type_images(j).name;
        cd (folder_type)
        %Read all folders in path current (folder date)
        [stat,struc] = fileattrib;
        PathCurrent = struc.Name;
        folder_date_images = dir(PathCurrent);
        folder_date_images(1:2)=[];
        
        for k=1:length(folder_date_images)
            folder_date=folder_date_images(k).name;
            cd (folder_date)
            
            %Read all files in path current (name of photo)
            [stat,struc] = fileattrib;
            PathCurrent = struc.Name;
            folder_images = dir(PathCurrent);
            folder_images(1:2)=[];
            
            cd ..\..\..\..\Code\Ccs_extraction
            
            disp([num2str(i) ' - ' days '\'  folder_type '\' folder_date])
            warning('off','all')
            
            pctRunOnAll warning('off','all')
            parfor l=1:length(folder_images)

                folder=[days '\'  folder_type '\' folder_date];
                name=folder_images(l).name;
%                 tic 
                [valid_cells]=Extraction_69ccs(folder,name);
                disp(['69 ccs - ' folder ' - ' name])
%                 toc
%                 if strcmp(days,'60 days')~=1
%                     tic
%                     Extraction_12ccs_dapi( folder,name,valid_cells);
%                     '12 dapi ccs'
%                     toc
%                 end
%                 listOfFolder(end+1,1:2)={{folder},{name}};
            end
            
            cd (['..\..\Photos\' days '\' folder_type])
            
        end
        
        cd ..
    end
    cd ..
end

cd ('..\Code')

            