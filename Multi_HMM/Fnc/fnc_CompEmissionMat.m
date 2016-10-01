function EmissionMat = fnc_CompEmissionMat(Seq, State, NumSymbol, NumState)
% SymbolList = unique(Seq);
% NumSymbol = length(SymbolList);
% NumSymbol = max(Seq);
% NumSymbol = k;
SymbolList = 1:NumSymbol;
StateList = 1:NumState;
% StateList = unique(State);
% NumState = length(StateList);

EmissionMat = zeros(NumState, NumSymbol);
for i = 1:NumState
    curState = StateList(i);
    ind = find(State == curState);
    for j = 1:NumSymbol
        EmissionMat(i,j) = nnz(Seq(ind) == SymbolList(j));
    end
    EmissionMat(i,:) = EmissionMat(i,:)./numel(ind);
end

