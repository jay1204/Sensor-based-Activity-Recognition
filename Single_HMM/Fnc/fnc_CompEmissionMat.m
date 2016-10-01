function [EmissionMat,SymbolList,StateList] = fnc_CompEmissionMat(Seq, State)
% SymbolList = unique(Seq);
% NumSymbol = length(SymbolList);
NumSymbol = max(Seq);
SymbolList = 1:NumSymbol;

StateList = unique(State);
NumState = length(StateList);

EmissionMat = zeros(NumState, NumSymbol);
for i = 1:NumState
    curState = StateList(i);
    ind = find(State == curState);
    for j = 1:NumSymbol
        EmissionMat(i,j) = nnz(Seq(ind) == SymbolList(j));
    end
    EmissionMat(i,:) = EmissionMat(i,:)./numel(ind);
end

