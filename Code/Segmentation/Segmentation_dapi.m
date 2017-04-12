function [BWmax,BWmin]=Segmentation_dapi(folder,name)
    

    %% loading images

    path_photos=['..\..\Photos\' folder '\' name];
    path_data=['..\..\Processed_images\' folder '\' name];

    % Load dapi's channel

    Img_r=imread([path_photos '\' name 'r.jpg']);
    Img_g=imread([path_photos '\' name 'g.jpg']);
    Img_b=imread([path_photos '\' name 'b.jpg']);

    Img=(Img_r+Img_g+Img_b);
    
    B=im2double(Img(:,:,3));    
    [H,W,c]=size(Img);
    
    % Load images needed to segment dapi channel (images got from segmentation without DAPI)

    load([path_data '\Data_image\Needed_images.mat'],'contour_img','contour_water','improved_mask','cells_img')    


    %% Getting objects and deleting noise

    %Enhancer
    B=imadjust(B);

    %Logical image
    BW = im2bw(B);

    %Deleting objects smaller than 400 pix
    BWmin= bwareaopen(BW,400);


    %% Reduce size from highest dapi regions connected
    %Initialize var
    BWmax=zeros(H,W);

    %calculate area of objects
    Area_ob = regionprops(BWmin, 'area');
    Area_ob = cat(1, Area_ob.Area);
    area_mean=mean(Area_ob);

    L=bwlabel(BWmin,8);

    for i=1:max(max(L))

        BWmax(L==i)=i;
        objt=BWmax(L==i);

        %calculate treshold intensity to delete area from big objects
        rest=max(B(L==i))-min(B(L==i));

        if Area_ob(i)>(area_mean*1.2)
                int_tresh=min(B(L==i))+rest*0.85;       
        else
            int_tresh=min(B(L==i))+rest*0.40;
        end

        int2delete=find(B(L==i)<int_tresh);
        objt(int2delete)=0;
        BWmax(L==i)=objt;
        BWmax(BWmax>0)=1;

    end

    %Clear small objects 
    BWmax= bwareaopen(BWmax,80);
    %fill holes
    BWmax=imfill(BWmax,'holes');

    %Write segmented dapi images
    imwrite(B,[path_data '\Data_image\Blue channel.bmp'])
    imwrite(BWmin,[path_data '\Data_image\Blue object segmentation.bmp'])
    imwrite(BWmax,[path_data '\Data_image\Blue node segmentation.bmp'])



end

