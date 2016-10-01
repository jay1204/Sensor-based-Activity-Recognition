function [clusterLabelTrain, clusterLabelTest] = fnc_ClusterData(trainFeature, testFeature, NumCluster)

options = statset('MaxIter',1000);
gmfit = fitgmdist(trainFeature,NumCluster,'CovarianceType','full',...
    'SharedCovariance',true,'Options',options);
clusterLabelTrain = cluster(gmfit, trainFeature);
clusterLabelTest = cluster(gmfit, testFeature);