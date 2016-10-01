close all
clear all
%%
addpath 'Fnc/'

%%
Flag_pca = 1;
Flag_Gaussian = 0;
Flag_cluster = 1;
%%
selectFeature = [1:36];
% set the subject you want to recognize the activities
SubjectID = 1;
base='data/';
load([base 'Feature_S' num2str(SubjectID,'%d')]);

trainFeature = TrainingFeature(:,selectFeature);
testFeature = TestingFeature(:,selectFeature);

%% pca
if (Flag_pca)
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
%% Label
trainFeatureLabel = TrainingLabel(:,end);
LRtrainingLabel = TrainingLabel(:,3);
LRtrainingLabel = LRtrainingLabel - 100;
LRtrainingLabel(LRtrainingLabel<0) = 6;

testFeatureLabel = TestingLabel(:,end);
LRtestingLabel = TestingLabel(:,3);
LRtestingLabel = LRtestingLabel - 100 ;
LRtestingLabel(LRtestingLabel<0) = 6;

%% Cluster
if (Flag_cluster)
    k = 50;
    
    options = statset('MaxIter',1000);
    gmfit = fitgmdist(trainFeature,k,'CovarianceType','full',...
        'SharedCovariance',true,'Options',options);
    clusterLabel = cluster(gmfit, trainFeature);
    
    [Prior, TransMat] = fnc_CompPriorTransMat(LRtrainingLabel);
    [EmissionMat,SymbolList,StateList] = fnc_CompEmissionMat(clusterLabel, LRtrainingLabel);
    [ TransMat,EmissionMat ] = fnc_forward_backward(clusterLabel, Prior, TransMat,EmissionMat,SymbolList);
    testclusterLabel = cluster(gmfit, testFeature);
    
    ObsMat = fnc_CompObsMat(testclusterLabel, EmissionMat);
    pathCluster = fnc_Viterbilog(Prior, TransMat, ObsMat);
    
    totalAcc = 1-nnz(LRtestingLabel(:) - pathCluster(:))/length(pathCluster);
    
    LRtestingLabel(find(LRtestingLabel==6))=0;
    pathCluster(find(pathCluster==6))=0;
    
    figure;hold on
    plot(LRtestingLabel)
    title(['Experiment Result of Subject ' num2str(SubjectID,'%d') ' appling single HMM model'],'FontSize',20)
    set(gca,'FontSize',18)
    plot(pathCluster,'.r')
    legend('Ground Truth Label','Classified Label')
    xlabel('Time t')
    ylabel('Activity label')
    
    [accuracy, recall, precision, fscore] = fnc_Evaluate(LRtestingLabel(:), pathCluster(:));
    WFmeasure = Prior*fscore';
end
