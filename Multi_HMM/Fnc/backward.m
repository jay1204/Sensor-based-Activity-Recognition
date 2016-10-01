function [ beta ] = backward( seq,transmat, emismat,scale,SymbolList )
%backward algorithm
%   
len = length(seq);

[numStates,numObs] = size(emismat);

beta = zeros(len,numStates);

beta(len,:) = 1/scale(len);

for i=(len-1):-1:1
    beta(i,:) = ((beta(i+1,:).* emismat(:,find(SymbolList == seq(i+1)))') * transmat')./scale(i);
end
end

