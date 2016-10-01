function [prior, transmat] = fnc_CompPriorTransMat(trainFeatureLabel, k)

labelList = 1:k;
% labelList = unique(trainFeatureLabel);
countState = [];
countTrans = [];
for i = 1:length(labelList)
    countState(i) = numel(find(trainFeatureLabel == labelList(i)));
    curInd = find(trainFeatureLabel == labelList(i));
    nextInd = curInd + 1;
    nextInd(nextInd > length(trainFeatureLabel)) = [];
    nextState = trainFeatureLabel(nextInd);
    for j = 1:length(labelList)
        countTrans(i,j) = numel(find(nextState == labelList(j)));
    end
    countTrans(i,:) = countTrans(i,:)./length(nextState);
end
prior = countState./length(trainFeatureLabel);
transmat = countTrans;

% % labelList(labelList==0) = [];
% trainFeatureLabel(trainFeatureLabel==0) = [];
% countTrans = [];
% for i = 1:length(labelList)
%     countState(i) = numel(find(trainFeatureLabel == labelList(i)));
%     curInd = find(trainFeatureLabel == labelList(i));
%     nextInd = curInd + 1;
%     nextInd(nextInd > length(trainFeatureLabel)) = [];
%     nextState = trainFeatureLabel(nextInd);
%     for j = 1:length(labelList)
%         countTrans(i,j) = numel(find(nextState == labelList(j)));
%     end
%     countTrans(i,:) = countTrans(i,:)./length(nextState);
% end
% prior = countState./length(trainFeatureLabel);
% transmat2 = countTrans;