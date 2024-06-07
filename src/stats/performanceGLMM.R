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

#read glm file
delim = ","
dec = "."
testResults = read.csv("E:/GrandCanyonSAR_analysis/src/stats/outputTables/outputForPerformanceGLMM_GrandCanyon_trialsUnder600.csv", header=TRUE, sep=delim, dec=dec, stringsAsFactors=FALSE)


# Set predictors as categorical variables
testResults$SwarmCohesion <- as.factor(testResults$SwarmCohesion)
testResults$TargetKnowledge <- as.factor(testResults$TargetKnowledge)
testResults$TerrainKnowledge <- as.factor(testResults$TerrainKnowledge)

# Label the levels
levels(testResults$SwarmCohesion) <- c('Low', 'High')
levels(testResults$TargetKnowledge) <- c('No', 'Yes')
levels(testResults$TerrainKnowledge) <- c('No', 'Yes')


mod0 = glm(performance ~ 1 , family = gaussian(link="identity"), data = testResults)
mod1 = glm(performance ~ 1 + SwarmCohesion  , family = gaussian(link="identity"), data = testResults)
mod2 = glm(performance ~ 1 + SwarmCohesion + TargetKnowledge , family = gaussian(link="identity"), data = testResults)
mod3 = glm(performance ~ 1 + SwarmCohesion + TargetKnowledge + TerrainKnowledge , family = gaussian(link="identity"), data = testResults)
mod4 = glm(performance ~ 1 + SwarmCohesion + TargetKnowledge + TerrainKnowledge + SwarmCohesion * TargetKnowledge , family = gaussian(link="identity"), data = testResults)
models <- list(mod0,mod1,mod2,mod3)
aictab(cand.set = models, modnames = c('mod0','mod1','mod2','mod3'))
# Model comparison 
#ANOVA
anova(mod0,mod1, test = "Chisq")
anova(mod1,mod2, test = "Chisq")
anova(mod2,mod3, test = "Chisq")


#anova(mod4,mod5, test = "Chisq")

#AICc
aictab(cand.set = models, modnames = c('mod0','mod1','mod2','mod3'))

