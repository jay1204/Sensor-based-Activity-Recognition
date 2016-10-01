close all

%%
addpath 'Fnc/'
%% LOADING DATA
selectFeature = [1:36];
SubjectID = 2;
for i = 1:5
    load(['data/' 'newFeature_S_' num2str(SubjectID,'%d') '-ADL' num2str(i,'%d') '.mat']);
    Feature{i} = FeatureData;
    
    newLabel = LabelData(:,end);
    newLabel = newLabel - 100;
    newLabel(newLabel<0) = 6;
    Label{i} = newLabel;
end

%%
% Training and testing data
testFeature = [Feature{4}; Feature{5}];
testLabel = [Label{4}; Label{5}];

trainFeature = [Feature{1}; Feature{2}; Feature{3}];
trainLabel = [Label{1}; Label{2}; Label{3}];

if (1)
    [coeff, SCORE, LATENT] = pca(trainFeature);
    for i = 1:length(coeff)
       if (sum(LATENT(1:i))/sum(LATENT) >= 0.9)
           break;
       end
    end
    coeff = coeff(:,1:i);
    trainFeature = trainFeature*coeff;
    testFeature = testFeature*coeff;
end
%% SETTING PARAMETERS
% train
NumCluster = 50;
NumLowState = 2;
MaxIter = 50;

% NumLowStateList = [10,5,5,5,4,7];
% NumLowStateList = [2,2,2,2,2,2];
NumLowStateList = [8,6,3,7,7,5];

rng(17)
%% CLUSTER
[clusterLabelTrain, clusterLabelTest] = fnc_ClusterData(trainFeature, testFeature, NumCluster);
%% TRAINING
% for NumLowState = 10
[TranMatList, EmissionMatList, PriorList, PriorHigh] = fnc_TrainHMMActivity(clusterLabelTrain, trainLabel, NumLowStateList, NumCluster, MaxIter);

%% TESTING
[finalPath, llstore] = fnc_TestHMMActivity(clusterLabelTest, TranMatList, EmissionMatList, PriorList, PriorHigh, lenSegment, 6);

testLabelOr = testLabel;
testLabelOr(testLabelOr == 6) = 0;

finalPathOr = finalPath;
finalPathOr(finalPathOr == 6) = 0;

figure;hold on
plot(testLabelOr,'linewidth',2)
title(['Experiment Result of Subject ' num2str(SubjectID,'%d') ' appling multiple HMM model'],'FontSize',20)
set(gca,'FontSize',18)
plot(finalPathOr,'.r')
legend('Ground Truth Label','Classified Label')
xlabel('Time t')
ylabel('Activity label')

[accuracy, recall, precision, fscore, totalAccuracy] = fnc_Evaluate(testLabelOr(:), finalPathOr(:));
[accuracy' recall' precision' fscore']
WF = PriorHigh*fscore';