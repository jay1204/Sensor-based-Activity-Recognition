clear all
close all

%%
addpath 'Fnc/'
datapath = '../OpportunityUCIDataset/dataset/';
% addpath '../OpportunityUCIDataset/scripts/benchmark/classifiers/';
% addpath 'HMMall/KPMtools/'
% addpath 'HMMall/KPMstats/'
% addpath 'HMMall/HMM/'
%%
winSize = 15; % 500 ms
stepsize = 8; % 250 ms

%%
TrainingData = [];
TestingData = [];
for SubjectID = 1:4
    colSelection = [2:37,246,248,245];
    for k = 1:5
        Data = fnc_ExtrFeature(k, colSelection, SubjectID, datapath, winSize, stepsize);
        FeatureData = Data(:,1:end-3);
        LabelData = Data(:,end-2:end);
        save(['newFeature_S' num2str(SubjectID,'%d') '-ADL' num2str(k,'%d') '.mat'],...
        'FeatureData', 'LabelData');
    end
    
%     TrainingData = Training;
%     TestingData = Testing;
%     TrainingFeature = TrainingData(:,1:end-3);
%     TrainingLabel = TrainingData(:,end-2:end);
%     TestingFeature = TestingData(:,1:end-3);
%     TestingLabel = TestingData(:,end-2:end);
%     save(['newFeature_S' num2str(SubjectID,'%d') '.mat'],...
%         'TrainingFeature', 'TrainingLabel', 'TestingFeature', 'TestingLabel');
end