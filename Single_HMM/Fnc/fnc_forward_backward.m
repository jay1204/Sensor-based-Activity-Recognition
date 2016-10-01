function [ transmat,emismat ] = fnc_forward_backward(seq, prior, transmat,emismat,SymbolList)
%Forward-backward Algorithm for single observation
% training the HMM model
%tol = 1e-6;
tol = 1e-6;
% compute the number of states and observations
[numStates,numObs] = size(emismat);
% calculate the length of the seq
T = length(seq);

maxiter = 500;

[ alpha, prob, scale ] = forward( seq, prior, transmat, emismat,SymbolList);
[ beta ] = backward( seq,transmat, emismat,scale,SymbolList );
[ gamma ] = computeGamma(alpha,beta,T);
[ Xi ] = computeXi(alpha,beta,seq,transmat, emismat,SymbolList);

prevProb = prob;

for k = 1:maxiter
    prior = eps + gamma(1,:);
    %prior = 0.001+0.999 .* gamma(1,:);
    transmat = sum(Xi(:,:,1:T-1),3);
    denominatorA = sum(gamma(1:T-1,:),1);
    for j=1:numStates
        transmat(:,j) = (transmat(:,j)./denominatorA')+eps;
        %transmat(:,j) = (transmat(:,j)./denominatorA') .* 0.999 + 0.001;
    end
    
    denominatorB = denominatorA + gamma(T,:);
    for i=1:numObs
        emismat(:,i) = (sum(gamma(find(seq == SymbolList(i)),:),1) ./ denominatorB)'+eps;
       %emismat(:,i) = (sum(gamma(find(seq == SymbolList(i)),:),1) ./ denominatorB)' .* 0.999 + 0.001;
    end
    
    [ alpha, prob, scale ] = forward( seq, prior, transmat, emismat,SymbolList);
    [ beta ] = backward( seq,transmat, emismat,scale,SymbolList );
    [ gamma ] = computeGamma(alpha,beta,T);
    [ Xi ] = computeXi(alpha,beta,seq,transmat, emismat,SymbolList);
    
    %delta = prob - prevProb;
    if((abs(prob-prevProb)/(1+abs(prevProb))) < tol)
        break;
    end
    prevProb = prob;
end


end

function [gamma] = computeGamma(alpha,beta,T)
gamma = alpha .* beta;
for i=1:T
    gamma(i,:) = gamma(i,:)./ sum(gamma(i,:));
end
end

function [Xi] = computeXi(alpha,beta,seq,transmat, emismat,SymbolList)
% compute the Xi matrix using the alpha and beta nad transition matrix and
% emmission matrix
[T,numStates] = size(alpha);

Xi = zeros(numStates,numStates,T);

for t = 1:T-1
    for j = 1:numStates
        for i = 1:numStates
            Xi(i,j,t) = alpha(t,i) .* transmat(i,j) .* emismat(j,find(SymbolList == seq(t+1))) .* beta(t+1,j);
        end
    end
    total = sum(sum(Xi(:,:,t)));
    Xi(:,:,t) = Xi(:,:,t)./total;
end

end
