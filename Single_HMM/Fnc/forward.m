function [ alpha, prob, scale ] = forward( seq, prior, transmat, emismat,SymbolList)
%forward algorithm
%   

% the length of the seq
len = length(seq);

[numStates,numObs] = size(emismat);

alpha = zeros(len,numStates);
% set the scale factor
scale = zeros(len,1);

alpha(1,:) = prior .* emismat(:,find(SymbolList == seq(1)))';
scale(1) = sum(alpha(1,:));
alpha(1,:) = alpha(1,:)./scale(1);

for i=2:len
    alpha(i,:) = (alpha(i-1,:) * transmat) .* emismat(:,find(SymbolList == seq(i)))';
    scale(i) = sum(alpha(i,:));
    alpha(i,:) = alpha(i,:)./scale(i);
end

prob = sum(log(scale));
end

