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
testResults = read.csv("E:/PreliminaryAnalysisGrandCanyon/src/stats/outputTables/outputForPupilDiaGLMM_GrandCanyon_test.csv", header=TRUE, sep=delim, dec=dec, stringsAsFactors=FALSE)

# Set predictors as categorical variables
testResults$SwarmCohesion <- as.factor(testResults$SwarmCohesion)
testResults$TargetKnowledge <- as.factor(testResults$TargetKnowledge)
testResults$TerrainKnowledge <- as.factor(testResults$TerrainKnowledge)
testResults$WindowSize <- as.factor(testResults$WindowSize)

# Renaming predictors
# testResults$Turbidity <- as.factor(testResults$Turbidity)
# testResults$NumberFish <- as.factor(testResults$Number_of_Fish)
# testResults$FishSpeed <- as.factor(testResults$Speed)

# Label the levels
levels(testResults$SwarmCohesion) <- c('Low', 'High')
levels(testResults$TargetKnowledge) <- c('No', 'Yes')
levels(testResults$TerrainKnowledge) <- c('No', 'Yes')
levels(testResults$WindowSize) <- c('1', '2','3', '4','5', '6','7', '8','9', '10','11', '12','13', '14','15','16', '17','18', '19','20','21', '22','23', '24','25')

testResults$WindowSize <- as.numeric(as.character(testResults$WindowSize))
# GLM of different models
#mod = glm(Net_Cognitive_Load~ 1  + Turbidity + NumberFish + (1|Subject)  + (1|Fish_Type), family = gaussian(link="identity"), data = testResults)

mod0 = glm(PupilDiam~ 1 , family = gaussian(link="identity"), data = testResults)
#mod1 = glm(CognitiveLoad~ 1 + SwarmCohesion  , family = gaussian(link="identity"), data = testResults)
#mod2 = glm(CognitiveLoad~ 1 + TargetKnowledge , family = gaussian(link="identity"), data = testResults)
#mod3 = glm(CognitiveLoad~ 1 + TerrainKnowledge , family = gaussian(link="identity"), data = testResults)
#mod4 = glm(CognitiveLoad~ 1 + CogWindow , family = gaussian(link="identity"), data = testResults)

mod1 = glm(PupilDiam ~ 1 + SwarmCohesion  , family = gaussian(link="identity"), data = testResults)
mod2 = glm(PupilDiam ~ 1 + SwarmCohesion + TargetKnowledge , family = gaussian(link="identity"), data = testResults)
mod3 = glm(PupilDiam ~ 1 + SwarmCohesion + TargetKnowledge + TerrainKnowledge , family = gaussian(link="identity"), data = testResults)
mod4 = glm(PupilDiam ~ 1 + SwarmCohesion + TargetKnowledge + TerrainKnowledge + WindowSize , family = gaussian(link="identity"), data = testResults)

mod5 = glm(PupilDiam ~ 1 + SwarmCohesion + TargetKnowledge + TerrainKnowledge + WindowSize + TerrainKnowledge*TargetKnowledge , family = gaussian(link="identity"), data = testResults)
mod6 = glm(PupilDiam ~ 1 + SwarmCohesion + TargetKnowledge + TerrainKnowledge + WindowSize + TerrainKnowledge*SwarmCohesion , family = gaussian(link="identity"), data = testResults)
mod7 = glm(PupilDiam ~ 1 + SwarmCohesion + TargetKnowledge + TerrainKnowledge + WindowSize + TerrainKnowledge*WindowSize , family = gaussian(link="identity"), data = testResults)


# mod5 = glm(CognitiveLoad~ 1 + TerrainKnowledge*TargetKnowledge, family = gaussian(link="identity"), data = testResults)
# mod6 = glm(CognitiveLoad~ 1 + TerrainKnowledge*SwarmCohesion, family = gaussian(link="identity"), data = testResults)
# mod7 = glm(CognitiveLoad~ 1 + TargetKnowledge*SwarmCohesion, family = gaussian(link="identity"), data = testResults)


models <- list(mod0,mod1,mod2,mod3,mod4,mod5,mod6,mod7)
aictab(cand.set = models, modnames = c('mod0','mod1','mod2','mod3','mod4','mod5','mod6','mod7'))
# Model comparison 
#ANOVA
anova(mod0,mod1, test = "Chisq")
anova(mod1,mod2, test = "Chisq")
anova(mod2,mod3, test = "Chisq")
anova(mod3,mod4, test = "Chisq")
anova(mod4,mod5, test = "Chisq")
anova(mod4,mod6, test = "Chisq")
anova(mod4,mod7, test = "Chisq")


#anova(mod4,mod5, test = "Chisq")

#AICc
aictab(cand.set = models, modnames = c('mod0','mod1','mod2','mod3','mod4','mod5','mod6','mod7'))



#
# jpeg(file="C:\Users\aruni\OneDrive - Northern Illinois University\PhDProjects\CognitiveCorrelatesExperiment\Scripts\FinalScriptCogntiveCorrelatesExperiment\FinalScriptCogntiveCorrelatesExperiment\src\Figure6_av.jpg", width = 36, height = 30, units = "cm", res = 400)
# plot1 = cat_plot(mod6, pred = Turbidity, modx = FishSpeed, mod2 = NumberFish, geom = "line",data = testResults,interval=FALSE)
# plot1+ylab("Cognitive Load") + theme(text = element_text(size = 38))+ theme(axis.title = element_text(size = 38))+coord_fixed(ratio=5)+theme(axis.text.x = element_text(size = 38))+theme(axis.text.y = element_text(size = 38))+ theme(legend.text = element_text(size=38))+ theme(legend.title = element_text(size=38))+ theme( panel.grid.major = element_line(size = 1.5))
# while (!is.null(dev.list()))  dev.off()

#
# jpeg("Figure6_b.jpg", width = 25, height = 30, units = "cm", res = 400)
# plot2 = cat_plot(mod6, pred = Turbidity, modx = FishSpeed, mod2 = CameraDistance, geom = "line",data = testResults,interval=FALSE)
# plot2+ylab("Cognitive Load")+theme(text = element_text(size = 50)) + theme(legend.text = element_text(size=50))+ theme(legend.title = element_text(size=35),panel.grid.major = element_line(size = 1.5))
# plot2 + theme(axis.title = element_text(size = 30))+coord_fixed(ratio=5.5)+theme(axis.text.x = element_text(size = 38))+theme(axis.text.y = element_text(size = 43),panel.grid.major = element_line(size = 1.5))
# while (!is.null(dev.list()))  dev.off()

plot1 = cat_plot(mod5, pred = SwarmCohesion , geom = "line",data = testResults,interval=FALSE)
plot1 + ylab("Cognitive Load")+theme(text = element_text(size = 20)) + theme(legend.text = element_text(size=20))+ theme(legend.title = element_text(size=15),panel.grid.major = element_line(size = 1.5))

plot2 = cat_plot(mod5, pred = TargetKnowledge , geom = "line",data = testResults,interval=FALSE)
plot2 + ylab("Cognitive Load")+theme(text = element_text(size = 20)) + theme(legend.text = element_text(size=20))+ theme(legend.title = element_text(size=15),panel.grid.major = element_line(size = 1.5))

plot3 = cat_plot(mod5, pred = TerrainKnowledge , geom = "line",data = testResults,interval=FALSE)
plot3 + ylab("Cognitive Load")+theme(text = element_text(size = 20)) + theme(legend.text = element_text(size=20))+ theme(legend.title = element_text(size=15),panel.grid.major = element_line(size = 1.5))

plot4 = cat_plot(mod5, pred = TargetKnowledge , modx = TerrainKnowledge , geom = "line",data = testResults,interval=FALSE)
plot4 + ylab("Cognitive Load")+theme(text = element_text(size = 20)) + theme(legend.text = element_text(size=20))+ theme(legend.title = element_text(size=15),panel.grid.major = element_line(size = 1.5))

plot5 = cat_plot(mod5, pred = SwarmCohesion  , modx = TerrainKnowledge , geom = "line",data = testResults,interval=FALSE)
plot5 + ylab("Cognitive Load")+theme(text = element_text(size = 20)) + theme(legend.text = element_text(size=20))+ theme(legend.title = element_text(size=15),panel.grid.major = element_line(size = 1.5))


plot4 = cat_plot(mod5, pred = CogWindow , geom = "line",data = testResults,interval=FALSE)
plot4 + ylab("Cognitive Load")+theme(text = element_text(size = 5)) + theme(legend.text = element_text(size=5))+ theme(legend.title = element_text(size=5),panel.grid.major = element_line(size = 1.5))
plot4 + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

plot5 = cat_plot(mod4, pred = SwarmCohesion , geom = "line",data = testResults,interval=FALSE)
plot5 + ylab("Cognitive Load")+theme(text = element_text(size = 20)) + theme(legend.text = element_text(size=20))+ theme(legend.title = element_text(size=15),panel.grid.major = element_line(size = 1.5))

plot6 = cat_plot(mod4, pred = TargetKnowledge , geom = "line",data = testResults,interval=FALSE)
plot6 + ylab("Cognitive Load")+theme(text = element_text(size = 20)) + theme(legend.text = element_text(size=20))+ theme(legend.title = element_text(size=15),panel.grid.major = element_line(size = 1.5))

plot7 = cat_plot(mod4, pred = TerrainKnowledge , geom = "line",data = testResults,interval=FALSE)
plot7 + ylab("Cognitive Load")+theme(text = element_text(size = 20)) + theme(legend.text = element_text(size=20))+ theme(legend.title = element_text(size=15),panel.grid.major = element_line(size = 1.5))

plot8 = cat_plot(mod4, pred = CogWindow , geom = "line",data = testResults,interval=FALSE)
plot8 + ylab("Cognitive Load")+theme(text = element_text(size = 20)) + theme(legend.text = element_text(size=20))+ theme(legend.title = element_text(size=15),panel.grid.major = element_line(size = 1.5))
plot8 + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))



plot5 = cat_plot(mod4, pred = SwarmCohesion, modx = cogWindow , modx = TargetKnowledge, mod2 = CogWindow, geom = "line",data = testResults,interval=FALSE)
plot5+ylab("Cognitive Load")+theme(text = element_text(size = 10)) + theme(legend.text = element_text(size=10))+ theme(legend.title = element_text(size=7),panel.grid.major = element_line(size = 1.5))

plot6 = cat_plot(mod5, pred = TerrainKnowledge  , modx = TargetKnowledge, mod2 = CogWindow , geom = "line",data = testResults,interval=FALSE)
plot6+ylab("Cognitive Load")+theme(text = element_text(size = 20)) + theme(legend.text = element_text(size=20))+ theme(legend.title = element_text(size=15),panel.grid.major = element_line(size = 1.5))
#while (!is.null(dev.list()))  dev.off()

plot7 = cat_plot(mod2, pred = TargetKnowledge, geom = "line",data = testResults,interval=FALSE)
plot7+ylab("Cognitive Load") + theme(text = element_text(size = 38))+ theme(axis.title = element_text(size = 15))+coord_fixed(ratio=5)+theme(axis.text.x = element_text(size = 15))+theme(axis.text.y = element_text(size = 15))+ theme(legend.text = element_text(size=38))+ theme(legend.title = element_text(size=15))+ theme( panel.grid.major = element_line(size = 1.5))
#while (!is.null(dev.list()))  dev.off()


plot8 = cat_plot(mod3, pred = TerrainKnowledge, modx = TargetKnowledge, mod2 = SwarmCohesion, geom = "line",data = testResults,interval=FALSE)
plot8+ylab("Cognitive Load") + theme(text = element_text(size = 38))+ theme(axis.title = element_text(size = 15))+coord_fixed(ratio=5)+theme(axis.text.x = element_text(size = 15))+theme(axis.text.y = element_text(size = 15))+ theme(legend.text = element_text(size=38))+ theme(legend.title = element_text(size=15))+ theme( panel.grid.major = element_line(size = 1.5))
#while (!is.null(dev.list()))  dev.off()

plot6 = cat_plot(mod4, pred = CogWindow, geom = "line",data = testResults,interval=FALSE)
plot6+ylab("Cognitive Load") + theme(text = element_text(size = 38))+ theme(axis.title = element_text(size = 15))+coord_fixed(ratio=5)+theme(axis.text.x = element_text(size = 15))+theme(axis.text.y = element_text(size = 15))+ theme(legend.text = element_text(size=38))+ theme(legend.title = element_text(size=15))+ theme( panel.grid.major = element_line(size = 1.5))
#while (!is.null(dev.list()))  dev.off()

plot7 = cat_plot(mod5, pred = TerrainKnowledge, modx = TargetKnowledge, geom = "line",data = testResults,interval=FALSE)
plot7+ylab("Cognitive Load") + theme(text = element_text(size = 38))+ theme(axis.title = element_text(size = 15))+coord_fixed(ratio=5)+theme(axis.text.x = element_text(size = 15))+theme(axis.text.y = element_text(size = 15))+ theme(legend.text = element_text(size=38))+ theme(legend.title = element_text(size=15))+ theme( panel.grid.major = element_line(size = 1.5))
#while (!is.null(dev.list()))  dev.off()

plot8 = cat_plot(mod6, pred = TerrainKnowledge, modx = SwarmCohesion, geom = "line",data = testResults,interval=FALSE)
plot8+ylab("Cognitive Load") + theme(text = element_text(size = 38))+ theme(axis.title = element_text(size = 15))+coord_fixed(ratio=5)+theme(axis.text.x = element_text(size = 15))+theme(axis.text.y = element_text(size = 15))+ theme(legend.text = element_text(size=38))+ theme(legend.title = element_text(size=15))+ theme( panel.grid.major = element_line(size = 1.5))
#while (!is.null(dev.list()))  dev.off()


plot9 = cat_plot(mod7, pred = TargetKnowledge, modx = SwarmCohesion, geom = "line",data = testResults,interval=FALSE)
plot9+ylab("Cognitive Load") + theme(text = element_text(size = 38))+ theme(axis.title = element_text(size = 15))+coord_fixed(ratio=5)+theme(axis.text.x = element_text(size = 15))+theme(axis.text.y = element_text(size = 15))+ theme(legend.text = element_text(size=38))+ theme(legend.title = element_text(size=15))+ theme( panel.grid.major = element_line(size = 1.5))
#while (!is.null(dev.list()))  dev.off()


