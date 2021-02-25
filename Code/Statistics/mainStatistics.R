#Statistical pipeline

#Libraries installations
#1 - for data manipulation -> install.packages("dplyr")
#2 - for data visualization -> install.packages("ggpubr")

#load R packages
library("dplyr")
library("ggplot2")
library("ggpubr")


#import data into R
my_data1 <- read.csv(file.choose())
data1 <- my_data1$x
my_data2 <- read.csv(file.choose())
data2 <- my_data2$x

#show some random data
dplyr::sample_n(my_data1, 10)


#Normality test -> if non-significant pvalue, then it has a normal distribution

#if n<50
if (length(data1)<50){
  normTest1 <- shapiro.test(data1) 
  normTest2 <- shapiro.test(data2) 
}else{
  normTest1 <- ks.test(data1,"pnorm", mean(data1), sd(data1))
  normTest2 <- ks.test(data2,"pnorm", mean(data2), sd(data2))
}

#if normality

  #F-test to evaluate variances -> F-Snedecor test(h->0 similar variances)
  fRes <- var.test(datos ~ groups, data = my_data)


  #if normal distributions and similar variance -> t-test (h->0 similar means)
  tRes <- t.test(x,y)
  
  #if normal distributions and different variances -> Welch test (h-> similar medians)
  welRes <- welch.test(datos ~ groups, data = my_data)


#if without assuming normality
  #test if similar variances -> Fligner-Killeen test (h->0, same variance)
  fligTest <- fligner.test(x,y)
  
  #if same variance -> Mann-Whitney-Wilcoxon test (h->0 identical populations)
  wilRes <- wilcox.test(x=muestraX, y=muestraY,paired = FALSE)
  
  #Si las varianzas no fuesen iguales se tendría que realizar el t-test con la corrección de Welch