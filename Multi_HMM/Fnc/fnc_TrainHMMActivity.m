function [TranMatList, EmissionMatList, PriorList, PriorHigh] = fnc_TrainHMMActivity(clusterLabelTrain, LRtrainingLabel, NumLowStateList, NumCluster, MaxIter)

% High level
[PriorHigh, TransMatHigh] = fnc_CompPriorTransMat(LRtrainingLabel, numel(unique(LRtrainingLabel)));

% Training
StateList = unique(LRtrainingLabel);
NumState = length(StateList);

% NumLowState = 5;
TranMatList = [];
EmissionMatList = [];
PriorList = [];
for i = 1:NumState
    i
    indState = find(LRtrainingLabel == StateList(i));
    trainFeatureState = clusterLabelTrain(indState,:);
    curNumLowState = NumLowStateList(i);
%     TRGUESS = eye(curNumLowState);
    TRGUESS = mk_stochastic(rand(curNumLowState,curNumLowState));
    EMITGUESS = mk_stochastic(rand(curNumLowState,NumCluster));
    prior1 = normalise(rand(curNumLowState,1));
    [transmat,emismat, prior] = fnc_forward_backward(trainFeatureState, prior1', TRGUESS,EMITGUESS,[1:NumCluster], MaxIter);
    TranMatList{i} = transmat;
    EmissionMatList{i} = emismat;
    PriorList{i} = prior(:);
end