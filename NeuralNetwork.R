#install Packages if needed
#install.packages("neuralnet")
#install.packages("nnet")
#install.packages("magrittr")
require(neuralnet)
require(nnet)
library(caret)
library(Matrix)
library(data.table)
library(mlr)
library(magrittr)
#Remove all variables
options(warn=-1)
cat("\014")  
rm(list=ls(all=TRUE))

#It is the Input table
Data<-read.table("Feature.csv",sep=",",header=TRUE)
#Split to train and test
set.seed(22)
a <- createDataPartition(Data[[3]], p = 0.8, list=FALSE)
trainDataOrigin <- setDT(Data[a,])
testDataOrigin <- setDT(Data[-a,])

trainData <- subset(trainDataOrigin, select=c("case","gender", "age","emergency","hospitalization","hospitalizationDay","outPatientClinic","transferHospital","ICUStay","ICUStayDays","priCandida","priBacteria","CCI1","CCI2","Colonization","Drug1_Antibacterial","Drug2_Antifungal","Drug3_Chemotherapy","Drug4_Gastric",
                                              "Drug5_Immunosuppressive","Drug6_Monoclonal","Drug7_Steroid",
                                              "AcutePancreatitis","GastrointestinalPerforation","Malnutrition_CCI","Stroke","EndotrachealIntubation",
                                              "ExtracorporealMembraneOxygenation","Hemodialysis","IndwellingCentralBenousCatheters",
                                              "IndwellingUrinaryCatheter","IntravascularCatheter","MechanicValve","MechanicalVentilation",
                                              "Pacemaker","PleuralDrainage","ProsthesisJoint","SolidOrganTransplantation","TotalParenteralNutrition",
                                              "Malnutrition_Albumin","EndotrachealIntubation_NTU",
                                              "ExtracorporealMembraneOxygenation_NTU","Hemodialysis_NTU","IndwellingCentralBenousCatheters_NTU",
                                              "IndwellingUrinaryCatheter_NTU","IntravascularCatheter_NTU","MechanicValve_NTU","MechanicalVentilation_NTU",
                                              "Pacemaker_NTU","PleuralDrainage_NTU","ProsthesisJoint_NTU","SolidOrganTransplantation_NTU","TotalParenteralNutrition_NTU",
                                              "Surgery_NTU"))

testData <- subset(testDataOrigin, select=c("gender", "age","emergency","hospitalization","hospitalizationDay","outPatientClinic","transferHospital","ICUStay","ICUStayDays","priCandida","priBacteria","CCI1","CCI2","Colonization","Drug1_Antibacterial","Drug2_Antifungal","Drug3_Chemotherapy","Drug4_Gastric",
                                            "Drug5_Immunosuppressive","Drug6_Monoclonal","Drug7_Steroid",
                                            "AcutePancreatitis","GastrointestinalPerforation","Malnutrition_CCI","Stroke","EndotrachealIntubation",
                                            "ExtracorporealMembraneOxygenation","Hemodialysis","IndwellingCentralBenousCatheters",
                                            "IndwellingUrinaryCatheter","IntravascularCatheter","MechanicValve","MechanicalVentilation",
                                            "Pacemaker","PleuralDrainage","ProsthesisJoint","SolidOrganTransplantation","TotalParenteralNutrition",
                                            "Malnutrition_Albumin","EndotrachealIntubation_NTU",
                                            "ExtracorporealMembraneOxygenation_NTU","Hemodialysis_NTU","IndwellingCentralBenousCatheters_NTU",
                                            "IndwellingUrinaryCatheter_NTU","IntravascularCatheter_NTU","MechanicValve_NTU","MechanicalVentilation_NTU",
                                            "Pacemaker_NTU","PleuralDrainage_NTU","ProsthesisJoint_NTU","SolidOrganTransplantation_NTU","TotalParenteralNutrition_NTU",
                                            "Surgery_NTU"))

# Converting
(to.replace <- names(which(sapply(trainData, is.logical))));
for (var in to.replace) trainData[, var:= (as.numeric(get(var)-0.5)*2), with=FALSE];
trainData$gender <- unclass(trainData$gender) %>% as.numeric *2 - 3
trainData$case <- (trainData$case + 1) / 2

(to.replace <- names(which(sapply(testData, is.logical))));
for (var in to.replace) testData[, var:= (as.numeric(get(var)-0.5)*2), with=FALSE];
testData$gender <- unclass(testData$gender) %>% as.numeric *2 - 3

formula.bpn <- case ~ gender + age + emergency + hospitalization + hospitalizationDay + outPatientClinic + transferHospital + ICUStay + ICUStayDays + priCandida + priBacteria + CCI1 + CCI2 + Colonization + Drug1_Antibacterial + Drug2_Antifungal + Drug3_Chemotherapy + Drug4_Gastric + Drug5_Immunosuppressive + Drug6_Monoclonal + Drug7_Steroid

# tune parameters
#model <- caret::train(form=formula.bpn,     # formula
#               data=trainData,           # ���
#               method="neuralnet",   # �����g����(bpn)
#               
#               # �̭��n���B�J�G�[��P�ƦC�զX(�Ĥ@�h1~4��nodes ; �ĤG�h0~4��nodes)
#               # �ݦ�رƦC�զX(�h�����üh�B�C�h�h�֭�node)�A�|���̤p��RMSE
#               tuneGrid = expand.grid(.layer1=c(16:32), .layer2=c(16:32), .layer3=c(0)),               
#               
#               # �H�U���ѼƳ]�w�A�M�W����neuralnet���@��
#               learningrate = 0.01,  # learning rate
#               threshold = 0.2,     # partial derivatives of the error function, a stopping criteria
#               stepmax = 500,         # �̤j��ieration�� = 500000(5*10^5)
#                lifesign="full",
#                lifesign.step= 10 
#)

#model
#f1 <- as.formula('case ~ gender + age + emergency + hospitalization + hospitalizationDay + outPatientClinic + transferHospital + ICUStay + ICUStayDays + priCandida + priBacteria + CCI1 + CCI2 + Colonization + Drug1_Antibacterial + Drug2_Antifungal + Drug3_Chemotherapy + Drug4_Gastric + Drug5_Immunosuppressive + Drug6_Monoclonal + Drug7_Steroid')
#model <- train(data.frame(trainData[,2:ncol(trainData)]), trainData$case , method = nnet, tuneGrid = expand.grid(.layer1 = c(1:32), .layer2 = c(1:32), .layer3 = c(0)), learningrate = 0.01)
#model

bpn <- neuralnet(formula = formula.bpn, 
                 data = trainData,
                 hidden = c(16,16),       # �@�����üh�G2��node
                 learningrate = 0.2, # learning rate
                 threshold = 1.2,    # partial derivatives of the error function, a stopping criteria
                 stepmax = 30000,        # �̤j��ieration�� = 500000(5*10^5)
                 lifesign="full",
                 lifesign.step= 10 
                 #linear.output=T
                 )

plot(bpn)

# �ϥ�bpn�ҫ��A��Jtest set��i��w��
# �ݭn�`�N���O�A��J��test��ƥu��]�tinput node����
# �ҥH���e�|�����A��J�ҫ��i��w��
pred <- compute(bpn, testData);

# �w�����G
#pred$net.result
pred$net.result[ pred$net.result <0.5 ] <- 0
pred$net.result[ pred$net.result >0.5 ] <- 1

# Converting
Label <- subset(testDataOrigin, select=c("case"));
(to.replace <- names(which(sapply(Label, is.logical))));
for (var in to.replace) Label[, var:= (as.numeric(get(var)-0.5)*2), with=FALSE];
Label <- (Label + 1) / 2;

# �V�c�x�} (�w���v��96.67%)
table(real    = unlist(Label),  predict = unlist(pred$net.result))