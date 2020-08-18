function tableStats = compareMeansOfMatrices(m1,m2)
%Protocol

%First, we evaluated whether features values of 2 kind of data presented normal 
%distribution and variance using Kolmogorov–Smirnov and F?Snedecor tests, respectively. 
%In case that data presented the same distribution but not an equal variance,
%we employed a two?tailed Welch test to compare the means from both groups. 
%In case that data presented different distribution and a different variance, 
%we employed Wilcoxon test to compare the means from both groups. 
%We employed a two?tailed Student's t ?test to compare the means in the cases
%where both distribution and variance of the two sets of data were similar
tableStats=table('Size',[size(m1,2),2],'VariableTypes',{'string','double'},'VariableNames',{'algorithm','p'});
    
    for i=1:size(m1,2)
        
        feature1=m1(:,i);
        feature2=m2(:,i);
        %initialize stats
        hKS1 = kstest(feature1);
        hKS2 = kstest(feature2);
        
        if hKS1 == 1 && hKS2 ==1
        
            %   H = VARTEST2(X,Y) performs an F test of the hypothesis that two
            %   independent samples, in the vectors X and Y, come from normal
            %   distributions with the same variance, against the alternative that
            %   they come from normal distributions with different variances.
            %   The result is H=0 if the null hypothesis ("variances are equal")
            %   cannot be rejected at the 5% significance level, or H=1 if the null
            %   hypothesis can be rejected at the 5% level.  X and Y can have
            %   different lengths.
            hVar = vartest2(feature1,feature2);
            
            if hVar==1
                %t-test. Normal distribution and same variances
                [h_ttest, p_ttest]=ttest2(feature1,feature2);
                nameAlgo = 't-test';
                p_ouput = p_ttest;
            else
                %Satterthwaite's approximation. This test is sometimes
                %called Welch’s t-test. Normal distribution and different
                %variances.
                [h_wtest,p_wtest] = ttest2(feature1, feature2, 'Vartype','unequal');
                nameAlgo = 'Welch';
                p_ouput = p_wtest;
            end
        
        else
            % two-sided Wilcoxon rank sum test. ranksum tests the null hypothesis 
            %that data in x and y are samples from continuous distributions 
            %with equal medians, against the alternative that they are not.
            
            %The Wilcoxon rank sum test is equivalent to the Mann-Whitney U test.
            [p_Wilconxon,h_Wilconxon] = ranksum(feature1,feature2);
            nameAlgo = 'Wilconxon';
            p_ouput = p_Wilconxon;
        end
        
        %output: name algorithm - p_value
        tableStats.algorithm(i)=nameAlgo;
        tableStats.p(i)=p_ouput;
    end


end