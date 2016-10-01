function ObsMat = fnc_CompObsMat(Seq, EmissionMat)
ObsMat = zeros(size(EmissionMat,1), size(Seq,1));

for i = 1:size(Seq,1)
    ObsMat(:,i) = EmissionMat(:,Seq(i));
end
