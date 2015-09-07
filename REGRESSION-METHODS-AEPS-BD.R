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

#Load functions; Open  All-Functions-AEPS_BD.RData

load("//dapadfs/workspace_cluster_6/TRANSVERSAL_PROJECTS/MADR/COMPONENTE_2/OPEN_BIGDATA_AEPS/REGRESSION_MODELS/All-Functions-AEPS_BD.RData")

#Work Directory

dirFol  <- "D:/Tobackup/Documents/HUGO_ANDRES_FILES/PRUEBA_CODIGO_INDEPENDIENTE"

setwd(dirFol)

#DataBase structure

datNam  <- "BASE_PROCESADA.csv"


inputs  <- 1:16   #inputs columns
segme   <- 17      #split column
output  <- 18     #output column

dataSet   <- read.csv(datNam,row.names=1)

namsDataSet <- names(dataSet)

#Creating the split factors

contVariety <- table(dataSet[,segme])
variety0    <- names(sort(contVariety[contVariety>=30]))


if(length(variety0)==0){variety = variety0 }else{variety = factor(c(variety0,"All"))}


#creating folders

createFolders(dirFol,variety)

#Descriptive Analysis

descriptiveGraphics("All",dataSet,inputs = inputs,segme = segme,output = output,smooth=T,ylabel = "Rendimiento (kg/ha)",smoothInd = NULL,ghrp="box")

#DataSets ProcesosF

dataSetProces(variety,dataSet,segme,corRed="caret")

#LINEAR REGRESSION; only when all inputs are cuantitative;  

lineaRegresionFun(variety,dirLocation=paste0(getwd(),"/"),ylabs="Yield (Kg/HA)")

#MULTILAYER PERCEPTRON

multilayerPerceptronFun("All",dirLocation=paste0(getwd(),"/"),nb.it=30,ylabs="Yield (Kg/HA)",pertuRelevance=T,ncores=3)

#CONDITIONAL FOREST; especify if you have categorical variables

conditionalForestFun("All",nb.it=30, ncores= 3,saveWS=F)

#RANDOM FOREST

randomForestFun("All",nb.it=30,ncores = 3,saveWS=F)





