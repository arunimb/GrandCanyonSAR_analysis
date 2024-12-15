library(tidyverse)
library(AICcmodavg)
library(sjPlot)
library(lme4)
library(GLMsData)
library(statmod)
library(jtools)
library(rcompanion)
library(multcomp)
library(afex)
library(stargazer)
library(texreg)
library(xtable)
library(car)
library(MASS)
library(AICcmodavg)
library(tidyr)
library(ggplot2)
library(lme4)
library(interactions)
#Set working directory
setwd(choose.dir())
#read glm file
delim = ","
dec = "."
testResults = read.csv("./outputTables/outputForFracCompleteStops.csv", header=TRUE, sep=delim, dec=dec, stringsAsFactors=FALSE)


# Set predictors as categorical variables
testResults$SwarmCohesion <- as.factor(testResults$SwarmCohesion)
testResults$TargetKnowledge <- as.factor(testResults$TargetKnowledge)
testResults$TerrainKnowledge <- as.factor(testResults$TerrainKnowledge)

# Label the levels
levels(testResults$SwarmCohesion) <- c('Low', 'High')
levels(testResults$TargetKnowledge) <- c('No', 'Yes')
levels(testResults$TerrainKnowledge) <- c('No', 'Yes')

mod0 = glm(fracCompleteStops ~ 1 + SwarmCohesion + TargetKnowledge + TerrainKnowledge , family = gaussian(link="identity"), data = testResults)
summary(mod0)


