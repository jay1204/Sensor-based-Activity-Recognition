function path = fnc_Viterbilogsilent(prior, TranMat, ObsMat)
% prior - prior of state. M length vector
% TranMat - transimission matrix. M x M matrix aij - i to j state
% ObsMat - observation matrix (P(obs|state)) M x N matrix (N is the length of sequence)

deltaMat = [];
phiMat = [];

NumState = length(prior) - 1;
LenSeq = size(ObsMat,2);

logPrior = log(prior);
logTranMat = log(TranMat);
logObsMat = log(ObsMat);


% t = 1
deltaMat(:,1) = logPrior(:) + logTranMat(:,1);
phiMat(:,1) = zeros(NumState,1);
% Forward
for t = 2:LenSeq
    for stateID = 1:NumState
        [deltaMat(stateID,t), phiMat(stateID,t)] = max(deltaMat(:,t-1) + logTranMat(:,stateID));        
        deltaMat(stateID,t) = deltaMat(stateID,t) + logObsMat(stateID,t);
    end
    deltaMat(NumState+1,t) = deltaMat(stateID,t);
end
% Backward
path = zeros(LenSeq,1);
% t = T
path(LenSeq) = min(find(deltaMat(1:end-1,LenSeq) == max(deltaMat(1:end-1,LenSeq))));

for t = LenSeq-1:-1:1
    tmp = phiMat(path(t+1),t+1); 
    if (tmp < NumState+1)
        path(t) = path(t+1);
    else
        path(t) = phiMat(path(t+1),t+1); 
    end
end
% path = path(:);

    
    