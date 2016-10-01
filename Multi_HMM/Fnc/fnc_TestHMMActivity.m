function [finalPath, llstore] = fnc_TestHMMActivity(clusterLabelTest, TranMatList, EmissionMatList, PriorList, PriorHigh, lenSegment, NumState)

% NumState = size(TranMatList,3);

finalPath = [];
llstore = [];
stepLen  = 150;
lLen = 50;
for i = 1:stepLen:length(clusterLabelTest)
   curSeq = clusterLabelTest(max(1,i-lLen):min(i+stepLen+lLen, length(clusterLabelTest)),:);
   ll = [];
   for j = 1:NumState
       EmissionMat = EmissionMatList{j};
       Prior = PriorList{j};
       TranMat = TranMatList{j};
       
       ObsMatSeq = fnc_CompObsMat(curSeq, EmissionMat);
%        [ alpha, lltmp, scale ] = forward( curSeq, Prior', TranMat, EmissionMat,1:50);
       seqPath = fnc_Viterbilog(Prior, TranMat, ObsMatSeq);
       lltmp = log(PriorHigh(j));
       for k = 2:length(seqPath)
%            lltmp = lltmp + log(TranMat(seqPath(k-1),seqPath(k))) + log(ObsMatSeq(seqPath(k),k));
           lltmp = lltmp + log(TranMat(seqPath(k-1),seqPath(k))) + log(ObsMatSeq(seqPath(k),k));
       end
       ll(j) = lltmp;
   end
   
%    llstore(:,i:min(i+lenSegment, length(clusterLabelTest))) = repmat(ll(:),1,min(i+lenSegment, length(clusterLabelTest))-i+1);
   [maxll, statehigh] = max(ll);
   finalPath(i:min(i+stepLen, length(clusterLabelTest)),:) = statehigh;
end
