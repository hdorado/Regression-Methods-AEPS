# file data-analysis-AEPS-BigData.R
# 
# This file contains a script to develop regressions with machine learning methodologies
#
#
# author: Hugo Andres Dorado 02-16-2015
#  
#This script is free: you can redistribute it and/or modify
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 

#-----------------------------------------------------------------------------------------------------------------


#SCRIPT BUILED FOR R VERSION 3.0.2 
#PACKAGES
rm(list=ls())
require(gtools)
require(gridBase)
require(relaimpo)
require(caret)
require(party)
require(randomForest)
require(snowfall)
require(earth)
require(agricolae)
require(cowplot)
require(reshape)
require(stringr)
require(gbm)
require(plyr)
library(gridExtra)

#Load functions; Open  All-Functions-AEPS_BD.RData
load("/mnt/workspace_cluster_6/TRANSVERSAL_PROJECTS/MADR/COMPONENTE_2/OPEN_BIGDATA_AEPS/REGRESSION_MODELS/All-Functions-AEPS_BD.RData")
load("//dapadfs/workspace_cluster_6/TRANSVERSAL_PROJECTS/MADR/COMPONENTE_2/OPEN_BIGDATA_AEPS/REGRESSION_MODELS/All-Functions-AEPS_BD.RData")
source("//dapadfs/workspace_cluster_6/TRANSVERSAL_PROJECTS/MADR/COMPONENTE_2/PUBLICACIONES/2015_Rice_Paper/SCRIPTS/cForestFunAll_400Samples.R")
source("/mnt/workspace_cluster_6/TRANSVERSAL_PROJECTS/MADR/COMPONENTE_2/PUBLICACIONES/2015_Rice_Paper/SCRIPTS/cForestFunAll_400Samples.R")

#Work Directory

dirFol  <- "//dapadfs/workspace_cluster_6/TRANSVERSAL_PROJECTS/MADR/COMPONENTE_2/PUBLICACIONES/2015_Rice_Paper/NUEVO_CASO_SALDANA"
dirFol  <- "/mnt/workspace_cluster_6/TRANSVERSAL_PROJECTS/MADR/COMPONENTE_2/PUBLICACIONES/2015_Rice_Paper/NUEVO_CASO_SALDANA"


setwd(dirFol)

#DataBase structure

datNam  <- "base_saldania_indicadores.csv"

dataSet0   <- read.csv(datNam,row.names=1)

dataSet <- dataSet0[,c(11:37,38,8)]

head(dataSet)

names(dataSet)

namsDataSet <- names(dataSet)


inputs  <- 1:27   #inputs columns
segme   <- 28      #split column
output  <- 29     #output column


#Creating the split factors

contVariety <- table(dataSet[,segme])
variety0    <- names(sort(contVariety[contVariety>=30]))


if(length(variety0)==0){variety = variety0 }else{variety = factor(c(variety0,"All"))}


#creating folders

createFolders(dirFol,variety)

#Descriptive Analysis
for(var in variety)
descriptiveGraphics(var,dataSet,inputs = inputs,segme = segme,output = output,smooth=T,ylabel = "Rendimiento (kg/ha)",smoothInd = NULL,ghrp="box",res=80)

#DataSets ProcesosF

dataSetProces(variety,dataSet,segme,corRed="caret")

#LINEAR REGRESSION; only when all inputs are cuantitative;  

lineaRegresionFun(variety,dirLocation=paste0(getwd(),"/"),ylabs="Yield (Kg/HA)")

#MULTILAYER PERCEPTRON

multilayerPerceptronFun("All",dirLocation=paste0(getwd(),"/"),nb.it=30,ylabs="Yield (Kg/HA)",pertuRelevance=T,ncores=3)

#CONDITIONAL FOREST; especify if you have categorical variables

conditionalForestFun("F60",nb.it=100, ncores= 23,saveWS=T)

#RANDOM FOREST

randomForestFun("All",nb.it=30,ncores = 3,saveWS=F)

#GENERALIZED BOOSTED REGRESSION MODELING 

boostingFun("All",nb.it=30,ncores=3,saveWS=F)


