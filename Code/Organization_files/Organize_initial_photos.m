%%Organize images in folders
clear all
close all

cd ..\..
cd Photos

%Get Path
[stat,struc] = fileattrib;
PathCurrent = struc.Name;

%Reading all images in path
read_days_folders = dir(PathCurrent);
read_days_folders(1:2)=[];

for i=1:length(read_days_folders)
    
    cd (read_days_folders(i).name)
    
    %Get Path
    [stat,struc] = fileattrib;
    PathCurrent = struc.Name;
    
    read_images_type=dir(PathCurrent); 
    read_images_type(1:2)=[];
    
    for k=1:length(read_images_type)
 
        cd (read_images_type(k).name)
        
        %Get Path
        [stat,struc] = fileattrib;
        PathCurrent = struc.Name;
        
        read_dates=dir(PathCurrent); 
        read_dates(1:2)=[];
        
        for l=1:length(read_dates)
            
            cd (read_dates(l).name)
            
            %Get Path
            [stat,struc] = fileattrib;
            PathCurrent = struc.Name;
            read_files = dir([PathCurrent '\*r.jpg']); 

                for j=1:length(read_files)
                    
                    image_name=read_files(j).name;
                    image_name=image_name(1:end-5);
                    
                    Img_r=imread([image_name 'r.jpg']);
                    Img_g=imread([image_name 'g.jpg']);
                    Img_b=imread([image_name 'b.jpg']);

                    %crear las rutas (Path) para carpetas y archivos
                    PathFolder = [PathCurrent '\' image_name];
                    mkdir(PathFolder);


                    imwrite(Img_r,[image_name '\' image_name 'r.jpg']);
                    imwrite(Img_g,[image_name '\' image_name 'g.jpg']);
                    imwrite(Img_b,[image_name '\' image_name 'b.jpg']);

                           
                end
                
            cd ..
        end
        cd ..

    end
    cd ..
end

cd ..
cd Code\Organization_files
