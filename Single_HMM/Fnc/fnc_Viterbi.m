function [path deltaMat] = fnc_Viterbi(prior, TranMat, ObsMat)
% prior - prior of state. M length vector
% TranMat - transimission matrix. M x M matrix aij - i to j state
% ObsMat - observation matrix (P(obs|state)) M x N matrix (N is the length of sequence)

deltaMat = [];
phiMat = [];

NumState = length(prior);
LenSeq = size(ObsMat,2);

% t = 1
deltaMat(:,1) = prior(:).*ObsMat(:,1);
phiMat(:,1) = zeros(NumState,1);
% Forward
for t = 2:LenSeq
    for j = 1:NumState
        [deltaMat(j,t), phiMat(j,t)] = max(deltaMat(:,t-1).*TranMat(:,j));        
        deltaMat(j,t) = deltaMat(j,t)*ObsMat(j,t);
    end
end
% Backward
path = zeros(LenSeq,1);
% t = T
path(LenSeq) = min(find(deltaMat(:,LenSeq) == max(deltaMat(:,LenSeq))));

for t = LenSeq-1:-1:1
  path(t) = phiMat(path(t+1),t+1); 
end
path = path(:);

    
    