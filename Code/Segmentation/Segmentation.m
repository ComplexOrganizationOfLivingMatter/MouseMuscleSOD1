function Segmentation(path_img)

%%% Variables
Noise_background=3000; % Delete noise
Divide_cells=2; % Ratio used to divide cells
Intercellular_espace=2; % Increase distances between cells, reduce artifacts and divide cells
Delete_artifacts=12000; % It's depends of min size cell 


%% SEGMENTATION

%%Load images
splittedPath = strsplit(path_img,filesep);
nameImage = splittedPath{end};
%Reading different images
Img_r=imread(fullfile(path_img, [nameImage 'r.jpg']));     

%If channel G is not necessary to be edited, we work with green
%original channel
Img_g_original=imread(fullfile(path_img, [nameImage 'g.jpg'])); 
if exist(fullfile(path_img, [nameImage 'g_edited.jpg']),'file')==2
    Img_g=imread(fullfile(path_img, [nameImage 'g_edited.jpg']));
else
    Img_g=Img_g_original;
end

%Any photos don't have DAPI
if exist([path_img '\' name 'b.jpg'])==2
   Img_b=imread(fullfile(path_img, [nameImage 'b.jpg'])); 
else
   Img_b=0;
end

%Composite and separate channels
Img=Img_r+Img_g+Img_b;
Img2=Img_r+Img_g_original+Img_b;
R=Img(:,:,1);
G=rgb2gray(Img_g);%Img(:,:,2);
B=Img(:,:,3);
[H,W,c]=size(Img);
    
%%Getting the intesities map from green image. Modify the contrast
%%automatically
G_he = histeq(G);

% We modify G regarding intensity property. Get a treshold overlapping 3 diferent layers to obtein the most representative data. 
J=adapthisteq(G);
meanJ=mean(mean(J));
h3=(meanJ/3); h15=(meanJ/1.5); h2=meanJ/2;

BWmin3 = imextendedmin(G,h3);
BWmin2 = imextendedmin(G,h2);
BWmin15 = imextendedmin(G,h15);


BWmin=BWmin15+BWmin3+BWmin2;

%% DELETING NO CELLS

% Noise 
BWmin= bwareaopen(BWmin,Noise_background);
mask_openning=BWmin;

L1 = bwlabel(mask_openning,8);  %Label connected compponents
L = label2rgb(L1);  %Give color to this components to be represented

% No cells calculated for internsity cell (tresholding)

%%Getting mean intensities from G from centroids of connected regions from L1.
Mean_G = regionprops(L1, G, 'MeanIntensity'); 
Mean_G = struct2cell(Mean_G);
Mean_G = cell2mat(Mean_G);


%Openning again. Delete cells in which G mean is higher than the treshold (100 in this case)
mask_openning=BWmin;
L1 = bwlabel(mask_openning,8);  % labelling regions to represent
L = label2rgb(L1);  %colour
mask_openning=L1;

ind_no_cell=find(Mean_G>100);
for i=1:length(ind_no_cell)
    [pixels_no_cell]=find(L1==ind_no_cell(i));
    mask_openning(pixels_no_cell)=0;
end
BW=mask_openning;

%% Morphological operations

% Fill holes
BW = imfill(BW,'holes');

% Openning to deleting dots and dividing cells
se = strel('disk',Divide_cells);
BW = imopen(BW,se);

% Compacting cells
se = strel('disk',2);
BW = imclose(BW,se);

% Separation between cells
se = strel('disk',Intercellular_espace);
BW = imerode(BW,se);
BW = bwareaopen(BW,Delete_artifacts);


%% Watershed
[Ix,Iy]=gradient(double(G));
grad = sqrt(Ix.^2 + Iy.^2);

D = bwdist(BW);
DL = watershed(D);
bgm = DL == 0;

contour_img=bgm;
contour_visual=1-im2double(contour_img);

initial_mask=BW;

%% Represent images: contour_visual, mascara inicial and contour_water
%%(same nomenclature which Dani used (before me) to save images and variables)

    
    PathFolder = fullfile(path_img, 'Data_image');
    if ~isfolder(PathFolder
        mkdir(PathFolder)
    end
    
    %Save composite image
    imwrite(Img2,fullfile(PathFolder, [nameImage '.jpg']);
    
    %Save contour_img image
    stringres=fullfile(PathFolder, [nameImage '_contour_img.jpg']);
    imwrite(contour_visual,stringres)
    
    %Save first cellular mask
    stringres=fullfile(PathFolder, [nameImage '_initial_mask.jpg']);
    imwrite(initial_mask,stringres)


    gradmag2 = imimposemin(grad, im2double(BW) | bgm);
    contour_water= watershed(gradmag2);
    contour_water=bwlabel(contour_water);

    %Save contour_img of intercellular espace
    stringres=fullfile(PathFolder, [nameImage '_water_contour_img.jpg']);
    imwrite(contour_water,stringres)

%% watershed

%Represent cells
white_index=find(contour_water==0);
R1=R;
G1=Img_g_original(:,:,2);
B1=B;

R1(white_index)=255;
G1(white_index)=255;
B1(white_index)=255;

RGB=cat(3,R1,G1,B1);

%Save watershed image (real image + contour_img of intercellular espace)
stringres=fullfile(PathFolder, [nameImage '_watershed.jpg']);
imwrite(RGB,stringres)


%Represent contour_imgs (dilating contour_img to improve visibility)
se = strel('disk',4);
bgm_cont=imdilate(bgm,se);
in_cont=find(bgm_cont==1);

R1_cont=R;
G1_cont=Img_g_original(:,:,2);
B1_cont=B;


white_cont=in_cont;
R1_cont(white_cont)=255;
G1_cont(white_cont)=255;
B1_cont(white_cont)=255;


RGB_cont=cat(3,R1_cont,G1_cont,B1_cont);
original_with_contour_img=RGB_cont;

%Save contour_img line + real image
stringres=fullfile(PathFolder, [nameImage '_real_contour_img.jpg']);
imwrite(original_with_contour_img,stringres)


%% Generate mask final more realistic than mascara inicial

contour_water_L=bwlabel(contour_water,8);
Label_contour_img=unique(contour_water_L(contour_img==1));
Label_contour_img=Label_contour_img(Label_contour_img~=0);

for Lab=1:length(Label_contour_img)
    contour_water_L(contour_water_L==Label_contour_img(Lab))=0;
end

improved_mask = logical(contour_water_L); 

%It is very important to do matching between cells_img and improved_mask
%labels
cells_img=bwlabel(1-contour_img,8);
improved_mask=improved_mask.*cells_img;

%Save improved mask
stringres=fullfile(PathFolder, [nameImage '_improved_mask.jpg']);
imwrite(improved_mask,stringres)

%%Saving necessary images to calculate the features
stringres=fullfile(PathFolder, 'Needed_images.mat');
save(stringres,'contour_img','contour_visual','contour_water','original_with_contour_img','improved_mask','initial_mask','cells_img');



end