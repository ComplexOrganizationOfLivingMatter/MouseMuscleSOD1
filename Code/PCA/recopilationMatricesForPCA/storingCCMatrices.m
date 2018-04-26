function  matrixCCs = storingCCMatrices(totalPathsFiles,imagesWithoutColoredCells)

    matrixCCs={};
    for i=1:length(totalPathsFiles)
        pathFile=totalPathsFiles{i};
        if strfind(pathFile,'69_cc.mat')
            load(pathFile)
            Mean_relation_axis=mean(Mean_relation_axis);
            pathFileDapi=[pathFile(1:end-17) 'Results_dapi_12_cc.mat'];

            if sum(cellfun(@(x) ~isempty(strfind(pathFile,x)), imagesWithoutColoredCells))>0
               matrixCCs{end+1,1}=NaN;
            else
               matrixCCs{end+1,1}=pathFile;
            end

            if exist (pathFileDapi) ~=0
                load(pathFileDapi)
                matrixCCs{end,2}=[Mean_Area,Std_Area,Mean_slow_cells_area,Std_slow_cells_area,Mean_fast_cells_area,Std_fast_cells_area,Mean_major_axis,Mean_minor_axis,Mean_relation_axis,Std_relation_axis,Mean_Pix_convex_region,Std_Pix_convex_region,Mean_relation_areas,Std_relation_areas,Mean_neighbors,Std_neighbors,Std_neighbors_of_slow,Std_neighbors_of_fast,Mean_slow_neighbors_of_slow,Mean_fast_neighbors_of_slow,Mean_slow_neighbors_of_fast,Mean_fast_neighbors_of_fast,Mean_Relation_areas_neighborhood,Std_Relation_areas_neighborhood,Mean_relation_major_axis_neighbors,Std_relation_major_axis_neighbors,Mean_relation_minor_axis_neighbors,Std_relation_minor_axis_neighbors,Mean_relation_relation_axis_neighbors,Std_relation_relation_axis_neighbors,Mean_relation_Pix_convex_region_neighbors,Std_relation_Pix_convex_region_neighbors,Mean_relation_relation_areas_neighbors,Std_relation_relation_areas_neighbors,Mean_sum_weights,Desv_sum_weights,Mean_weights_fast_cells,Desv_weights_fast_cells,Mean_weights_slow_cells,Desv_weights_slow_cells,Mean_Coef_cluster,Desv_Coef_cluster,Mean_Coef_cluster_fast,Desv_Coef_cluster_fast,Mean_Coef_cluster_slow,Desv_Coef_cluster_slow,Mean_excentricity,Desv_excentricity,Mean_excentricity_fast,Desv_excentricity_fast,Mean_excentricity_slow,Desv_excentricity_slow,Mean_BC,Desv_BC,Mean_BC_fast,Desv_BC_fast,Mean_BC_slow,Desv_BC_slow,Mean_dist,Desv_dist,Mean_dist_fast_fast,Desv_dist_fast_fast,Mean_dist_fast_slow,Desv_dist_fast_slow,Mean_dist_slow_slow,Desv_dist_slow_slow,Mean_dist_slow_fast,Desv_dist_slow_fast,Average_slow_cells,mean_peaks_cel_water_val,mean_peaks_collagen_val,mean_peaks_cell_total_val,desv_n_peaks_cwater,desv_n_peaks_collagen,desv_n_peaks_cel_total,Percentage_Area_Object_water_cell,Percentage_Area_Object_collagen,Percentage_Area_Object_cell,desv_area_obj_cwater,desv_area_obj_collagen,desv_area_obj_cel_total];
            else
                matrixCCs{end,2}=[Mean_Area,Std_Area,Mean_slow_cells_area,Std_slow_cells_area,Mean_fast_cells_area,Std_fast_cells_area,Mean_major_axis,Mean_minor_axis,Mean_relation_axis,Std_relation_axis,Mean_Pix_convex_region,Std_Pix_convex_region,Mean_relation_areas,Std_relation_areas,Mean_neighbors,Std_neighbors,Std_neighbors_of_slow,Std_neighbors_of_fast,Mean_slow_neighbors_of_slow,Mean_fast_neighbors_of_slow,Mean_slow_neighbors_of_fast,Mean_fast_neighbors_of_fast,Mean_Relation_areas_neighborhood,Std_Relation_areas_neighborhood,Mean_relation_major_axis_neighbors,Std_relation_major_axis_neighbors,Mean_relation_minor_axis_neighbors,Std_relation_minor_axis_neighbors,Mean_relation_relation_axis_neighbors,Std_relation_relation_axis_neighbors,Mean_relation_Pix_convex_region_neighbors,Std_relation_Pix_convex_region_neighbors,Mean_relation_relation_areas_neighbors,Std_relation_relation_areas_neighbors,Mean_sum_weights,Desv_sum_weights,Mean_weights_fast_cells,Desv_weights_fast_cells,Mean_weights_slow_cells,Desv_weights_slow_cells,Mean_Coef_cluster,Desv_Coef_cluster,Mean_Coef_cluster_fast,Desv_Coef_cluster_fast,Mean_Coef_cluster_slow,Desv_Coef_cluster_slow,Mean_excentricity,Desv_excentricity,Mean_excentricity_fast,Desv_excentricity_fast,Mean_excentricity_slow,Desv_excentricity_slow,Mean_BC,Desv_BC,Mean_BC_fast,Desv_BC_fast,Mean_BC_slow,Desv_BC_slow,Mean_dist,Desv_dist,Mean_dist_fast_fast,Desv_dist_fast_fast,Mean_dist_fast_slow,Desv_dist_fast_slow,Mean_dist_slow_slow,Desv_dist_slow_slow,Mean_dist_slow_fast,Desv_dist_slow_fast,Average_slow_cells];
            end   
        end
    end

end

