#Statistical pipeline

#load R packages
library("dplyr")
library("ggplot2")
library("ggpubr")
library("nortest") #Lilliefors test
library("onewaytests")

#import data into R
my_data1 <- read.csv(file.choose())
data1 <- my_data1$x
my_data2 <- read.csv(file.choose())
data2 <- my_data2$x

groupedData <- data.frame("values"=c(data1,data2),"classes" = c(rep(1,length.out=length(data1)),rep(2,length.out=length(data2))))

#show some random data
dplyr::sample_n(my_data1, 10)


#Normality test -> if non-significant pvalue, then it has a normal distribution (h->0, normal distribution)

#if n<50
if (length(data1)<50){
  normTest1 <- shapiro.test(data1) 
  normTest2 <- shapiro.test(data2) 
}else{
  #normTest1 <- ks.test(x=data1,"pnorm", mean(data1), sd(data1))
  #normTest2 <- ks.test(x=data2,"pnorm", mean(data2), sd(data2))
  
  normTest1 <- lillie.test(data1)
  normTest2 <- lillie.test(data2)
  
}

#if normality
if (normTest1$p.value>0.05 & normTest2$p.value>0.05){
  #F-test to evaluate variances -> F-Snedecor test(h->0 similar variances)
  fRes <- var.test(x=data1,y=data2)

  if (fRes$p.value>0.05){
    #if normal distributions and similar variance -> t-test (h->0 similar means)
    tRes <- t.test(x=data1,y=data2)
  }else{
    #if normal distributions and different variances -> Welch test (h->0 similar medians)
    welRes <- welch.test(values ~ classes, groupedData)
  }
  
  
}else{
  #without assuming normality
  
  #test if similar variances -> Fligner-Killeen test (h->0, same variance)
  fligTest <- fligner.test(values ~ classes, groupedData)
  
  #if same variance -> Mann-Whitney-Wilcoxon test (h->0 identical populations)
  wilRes <- wilcox.test(x=data1, y=data2,paired = FALSE)
}
  



  
  
