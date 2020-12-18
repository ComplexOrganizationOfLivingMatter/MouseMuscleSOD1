function plotUMAP_save(path2save, n_t1,n_t2,nImgType1,nImgType2,nRand,Proyections, eigenvectors, Ratio_UMAP,selectedFeatures)
    
    save( [path2save 'UMAP_' n_t1 '_' n_t2 '_' num2str(nRand)], 'Proyections', 'Ratio_UMAP','selectedFeatures', 'eigenvectors')

    
    switch lower(n_t1(1:2))
        
        case 'wt'
            color1=[0,1,0];
        case 'co'
            color1=[0,0,1];
        case 'g9'
            color1=[1,0,0];
    end
    
    switch lower(n_t2(1:2))
        
        case 'wt'
            color2=[0,1,0];
        case 'co'
            color2=[0,0,1];
        case 'g9'
            color2=[1,0,0];
    end
    
    if strcmp(n_t1(1:2),n_t2(1:2))==1
        color2=color1/2;
    end
    
    %%Represent Luisma format
    Proyecc=Proyections{1}';
    h=figure('Position', get(0, 'Screensize')); 
    plot(Proyecc(1,1:nImgType1),Proyecc(2,1:nImgType1),'.','Color',color1,'MarkerSize',45)
    hold on, plot(Proyecc(1,nImgType1+1:nImgType1+nImgType2),Proyecc(2,nImgType1+1:nImgType1+nImgType2),'.','Color',color2,'MarkerSize',45)

    %stringres=strcat(num2str(indexesCcsSelected));
    stringres=strcat('UMAP selected features  ',num2str(selectedFeatures),' Descriptor  ',num2str(Ratio_UMAP(1)));
    title(stringres)
    legend(n_t1,n_t2, 'Location', 'bestoutside')
    set(gca,'FontSize', 20)
    set(gcf,'color','white')

    F = getframe(h);
    imwrite(F.cdata, [path2save 'UMAP_' n_t1 '_' n_t2 '_' num2str(nRand) '.tiff'],'Resolution', 300);
    savefig(h,[path2save 'UMAP_' n_t1 '_' n_t2 '_' num2str(nRand) '.fig'])
    
    
    pause(10)
    
    clear F
    close(gcf)
    close all

end

