function datalist = fnc_ExtrFeature(ADLlist, colSelection, SubjectID, datapath, winSize, stepsize)
datalist = [];
for i = ADLlist
    filename = [datapath 'S' num2str(SubjectID,'%d') '-ADL' num2str(i,'%d') '.dat'];
    SensorData = load(filename);
    TrainingTmp = SensorData(:,colSelection);
    LenData = size(TrainingTmp,1);
    TrainingTmp((sum(isnan(TrainingTmp),1) > LenData/3),:) = [];
%     TrainingTmp((sum(isnan(TrainingTmp),2) > 18),:) = [];
    % ---- handle missing data --------
    TrainingTmp = handleMissingData(TrainingTmp);
    lenData = size(TrainingTmp,1);
    for j = 1:stepsize:lenData
        DataWin = TrainingTmp(j:min(j+winSize-1,lenData),:);
        
        sampleData = mean(DataWin(:,1:end-3),1);
        labelData = [mode(DataWin(:,end-2)), mode(DataWin(:,end-1)), mode(DataWin(:,end))];
        datalist = [datalist; [sampleData labelData]];
    end
end
% Remove data with too many zeros
% datalist((sum(datalist==0,2) > 10),:) = [];

end

function wholeData = handleMissingData(wholeData)
% replace nan of first row with 0
sampleData =  wholeData(1, :);
for colID = 1:length(sampleData)
    if (isnan(sampleData(colID)))
        wholeData(1,colID) = 0;
    end
end

for rowID = 2:size(wholeData,1)
    sampleData =  wholeData(rowID, :);
    for colID = 1:length(sampleData)
        if (isnan(sampleData(colID)))
            wholeData(rowID,colID) = wholeData(rowID-1,colID);
        end
    end
end
end