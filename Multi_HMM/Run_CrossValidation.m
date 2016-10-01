close all

%%
addpath 'Fnc/'
%% LOADING DATA
selectFeature = [1:36];
SubjectID = 2;
for i = 1:3
    load(['data/' 'newFeature_S_' num2str(SubjectID,'%d') '-ADL' num2str(i,'%d') '.mat']);
    Feature{i} = FeatureData;
    
    newLabel = LabelData(:,end);
    newLabel = newLabel - 100;
    newLabel(newLabel<0) = 6;
    Label{i} = newLabel;
end
%% SETTING PARAMETERS
% train
NumCluster = 50;
NumLowState = 3;
MaxIter = 50;
% test
NumLowStateList = [2,2,2,2,2,2];
%%
for stateID = 1:6
    cntNLS = 1;
    for numLS = 2:8
        NumLowStateList(stateID) = numLS;
        
        for roundID = 1:3
            %%
            % Training and testing data
            tmpList = 1:3;
            testFeature = Feature{roundID};
            testLabel = Label{roundID};
            
            tmpList(tmpList == roundID) = [];
            trainFeature = [Feature{tmpList(1)} ; Feature{tmpList(2)}];
            trainLabel = [Label{tmpList(1)} ; Label{tmpList(2)}];
            
            %% CLUSTER
            [clusterLabelTrain, clusterLabelTest] = fnc_ClusterData(trainFeature, testFeature, NumCluster);
            
            %% TRAINING
            curNumLowStateList = NumLowStateList;
            % for NumLowState = 8:15
            [TranMatList, EmissionMatList, PriorList, PriorHigh] = fnc_TrainHMMActivity(clusterLabelTrain, trainLabel, NumLowStateList, NumCluster, MaxIter);
            %% TESTING
            lenSegment = 200;
            [finalPath, llstore] = fnc_TestHMMActivity(clusterLabelTest, TranMatList, EmissionMatList, PriorList, PriorHigh, lenSegment, 6);
            
            %%            
            [accuracy, recall, precision, fscore, totalAccuracy] = fnc_Evaluate(testLabel(:), finalPath(:));

            accList(roundID) = totalAccuracy;
            %%
        end
        accTList(cntNLS) = mean(accList);
        cntNLS = cntNLS+1;
    end
    [tt,ttt] = max(accTList);
    NumLowStateList(stateID) = ttt+1;
    NumLowStateList
end