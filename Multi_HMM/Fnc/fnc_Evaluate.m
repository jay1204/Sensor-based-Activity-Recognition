function [accuracy, recall, precision, fscore, totalAccuracy] = fnc_Evaluate(Groundtruth, Estimate)
StateList = unique(Groundtruth);
NumState = numel(StateList);
N = length(Groundtruth);
for i = 1:NumState
%     p = nnz(Groundtruth == StateList(i));
%     n = length(Groundtruth) - p;
%     
    
    ind = find(Groundtruth == StateList(i));
    Nind = find(Groundtruth ~= StateList(i));
    tp = nnz(Estimate(ind) == StateList(i));
    tn = nnz(Estimate(Nind) ~= StateList(i));
    indE = find(Estimate == StateList(i));
    NindE = find(Estimate ~= StateList(i));
    fp = nnz(Groundtruth(indE) ~= StateList(i));
    fn = nnz(Groundtruth(NindE) == StateList(i));
%     accuracy(i) = (tp + tn)./(tp+tn+fn+fp);
    accuracy(i) = (tp + tn)./N;
    recall(i) = tp/(tp+fn);
    precision(i) = tp/(tp+fp);
    fscore(i) = 2*precision(i)*recall(i)/(precision(i)+recall(i));
end

totalAccuracy = 1-nnz(Groundtruth(:)-Estimate(:))./numel(Groundtruth);