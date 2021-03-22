function  [Itinerary,Probability,RouteChoiceRelatedPro] = ItineraryExtract(O,D,TapTime,LoopPath,PathIndex)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
global  PathLineInf  UpAccessTimeParameter UpEgressTimeParameter DownAccessTimeParameter DownEgressTimeParameter...
    UpDelayboardingParameter DownDelayboardingParameter TimeInterval TransferDirectionDetail...
    UpDepartTimeTable UpArrivalTimeTable  DownDepartTimeTable DownArrivalTimeTable...
    UpStationInLine DownStationInLine TransferTimeParameter ConM7 DownLoopTrainNumChange UpLoopTrainNumChange PathSet
KeyStation = [O TransferDirectionDetail(LoopPath,4)' D];
%-------------------------------------路径上的时刻表提取开始-------------------------------------
TimeTable = cell(length(KeyStation)-1,1);
AccEgrMean = zeros(2,1);
AccEgrVariance = zeros(2,1);
DelayboardingParameter = cell(length(KeyStation)-1,1);
if length(KeyStation) == 2
    Line = unique(PathLineInf(PathIndex,PathLineInf(PathIndex)~=0));
    if Line ~=7
        if find(UpStationInLine{Line}==O) < find(UpStationInLine{Line}==D)
            TimeTable{1}(:,1) = UpDepartTimeTable{Line}(:,UpStationInLine{Line}==O);
            TimeTable{1}(:,2) = UpArrivalTimeTable{Line}(:,UpStationInLine{Line}==D);
            AccEgrMean(1) = UpAccessTimeParameter{Line}(UpStationInLine{Line}==O,2);
            AccEgrVariance(1) = UpAccessTimeParameter{Line}(UpStationInLine{Line}==O,3);
            AccEgrMean(2) = UpEgressTimeParameter{Line}(UpStationInLine{Line}==D,2);
            AccEgrVariance(2) = UpEgressTimeParameter{Line}(UpStationInLine{Line}==D,3);
            DelayboardingParameter{1} = UpDelayboardingParameter{Line}{UpStationInLine{Line}==O};
        else
            TimeTable{1}(:,1) = DownDepartTimeTable{Line}(:,DownStationInLine{Line}==O);
            TimeTable{1}(:,2) = DownArrivalTimeTable{Line}(:,DownStationInLine{Line}==D);
            AccEgrMean(1) = DownAccessTimeParameter{Line}(DownStationInLine{Line}==O,2);
            AccEgrVariance(1) = DownAccessTimeParameter{Line}(DownStationInLine{Line}==O,3);
            AccEgrMean(2) = DownEgressTimeParameter{Line}(DownStationInLine{Line}==D,2);
            AccEgrVariance(2) = DownEgressTimeParameter{Line}(DownStationInLine{Line}==D,3);
            DelayboardingParameter{1} = DownDelayboardingParameter{Line}{DownStationInLine{Line}==O};
        end
    else
        path = PathSet(PathIndex,:);
        if path(find(path==KeyStation(1))+1)==105
            Godbless =2;
        else
            Godbless = 1;
        end
        if graphshortestpath(ConM7,find(UpStationInLine{7}==KeyStation(1)),find(UpStationInLine{7}==path(find(path==KeyStation(1))+Godbless))) < ...
                graphshortestpath(ConM7,find(DownStationInLine{7}==KeyStation(1)),find(DownStationInLine{7}==path(find(path==KeyStation(1))+Godbless)))
            AccEgrMean(1) = UpAccessTimeParameter{Line}(UpStationInLine{Line}==O,2);
            AccEgrVariance(1) = UpAccessTimeParameter{Line}(UpStationInLine{Line}==O,3);
            AccEgrMean(2) = UpEgressTimeParameter{Line}(UpStationInLine{Line}==D,2);
            AccEgrVariance(2) = UpEgressTimeParameter{Line}(UpStationInLine{Line}==D,3);
            DelayboardingParameter{1} = UpDelayboardingParameter{Line}{UpStationInLine{Line}==O};
            if find(UpStationInLine{Line}==O) < find(UpStationInLine{Line}==D)
                TimeTable{1}(:,1) = UpDepartTimeTable{Line}(:,UpStationInLine{Line}==O);
                TimeTable{1}(:,2) = UpArrivalTimeTable{Line}(:,UpStationInLine{Line}==D);
            else
                TimeTable{1}(:,1) = UpDepartTimeTable{Line}(:,UpStationInLine{Line}==O);
                TimeTable{1}(:,2) = zeros(length(TimeTable{1}(:,1)),1);
                ignore = UpArrivalTimeTable{Line}(:,UpStationInLine{Line}==D);
                TimeTable{1}(UpLoopTrainNumChange~=0,2) = ignore(UpLoopTrainNumChange(UpLoopTrainNumChange~=0));
            end
        else
            AccEgrMean(1) = DownAccessTimeParameter{Line}(DownStationInLine{Line}==O,2);
            AccEgrVariance(1) = DownAccessTimeParameter{Line}(DownStationInLine{Line}==O,3);
            AccEgrMean(2) = DownEgressTimeParameter{Line}(DownStationInLine{Line}==D,2);
            AccEgrVariance(2) = DownEgressTimeParameter{Line}(DownStationInLine{Line}==D,3);
            DelayboardingParameter{1} = DownDelayboardingParameter{Line}{DownStationInLine{Line}==O};
            if find(DownStationInLine{Line}==O) < find(DownStationInLine{Line}==D)
                TimeTable{1}(:,1) = DownDepartTimeTable{Line}(:,DownStationInLine{Line}==O);
                TimeTable{1}(:,2) = DownArrivalTimeTable{Line}(:,DownStationInLine{Line}==D);
            else
                TimeTable{1}(:,1) = DownDepartTimeTable{Line}(:,DownStationInLine{Line}==O);
                TimeTable{1}(:,2) = zeros(length(TimeTable{1}(:,1)),1);
                ignore = DownArrivalTimeTable{Line}(:,DownStationInLine{Line}==D);
                TimeTable{1}(DownLoopTrainNumChange~=0,2) = ignore(DownLoopTrainNumChange(DownLoopTrainNumChange~=0));
            end
        end
    end
else
    for i = 1:length(KeyStation)-2
        if TransferDirectionDetail(LoopPath(i),2) ~= 7
            if TransferDirectionDetail(LoopPath(i),3) == 1
                TimeTable{i}(:,1) = UpDepartTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
                    (:,UpStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i));
                TimeTable{i}(:,2) = UpArrivalTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
                    (:,UpStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i+1));
            else
                TimeTable{i}(:,1) = DownDepartTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
                    (:,DownStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i));
                TimeTable{i}(:,2) = DownArrivalTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
                    (:,DownStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i+1));
            end
        else
            if TransferDirectionDetail(LoopPath(i),3) == 1
                TimeTable{i}(:,1) = UpDepartTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
                    (:,UpStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i));
                if find(UpStationInLine{7}==KeyStation(i)) < find(UpStationInLine{7}==KeyStation(i+1))
                    TimeTable{i}(:,2) = UpArrivalTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
                        (:,UpStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i+1));
                else
                    TimeTable{i}(:,2) = zeros(size(TimeTable{i}(:,1)));
                    ignore = UpArrivalTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
                        (:,UpStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i+1));
                    TimeTable{i}(UpLoopTrainNumChange~=0,2) = ignore(UpLoopTrainNumChange(UpLoopTrainNumChange~=0));
                end
            else
                TimeTable{i}(:,1) = DownDepartTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
                    (:,DownStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i));
                if find(DownStationInLine{7}==KeyStation(i)) < find(DownStationInLine{7}==KeyStation(i+1))
                    TimeTable{i}(:,2) = DownArrivalTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
                        (:,DownStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i+1));
                else
                    TimeTable{i}(:,2) = zeros(size(TimeTable{i}(:,1)));
                    ignore =DownArrivalTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
                        (:,DownStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i+1));
                    TimeTable{i}(DownLoopTrainNumChange~=0,2) = ignore(DownLoopTrainNumChange(DownLoopTrainNumChange~=0));
                end
            end
        end
    end
    if TransferDirectionDetail(LoopPath(end),6) ~= 7
        if TransferDirectionDetail(LoopPath(end),5) == 1
            TimeTable{end}(:,1) = UpDepartTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
                (:,UpStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end-1));
            TimeTable{end}(:,2) = UpArrivalTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
                (:,UpStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end));
        else
            TimeTable{end}(:,1) = DownDepartTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
                (:,DownStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end-1));
            TimeTable{end}(:,2) = DownArrivalTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
                (:,DownStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end));
        end
    else
        if TransferDirectionDetail(LoopPath(end),5) == 1
            TimeTable{end}(:,1) = UpDepartTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
                (:,UpStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end-1));
            if  find(UpStationInLine{7}==KeyStation(end-1)) < find(UpStationInLine{7}==KeyStation(end))
                TimeTable{end}(:,2) = UpArrivalTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
                    (:,UpStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end));
            else
                TimeTable{end}(:,2) = zeros(size(TimeTable{end}(:,1)));
                ignore = UpArrivalTimeTable{7}(:,UpStationInLine{7}==KeyStation(end));
                TimeTable{end}(UpLoopTrainNumChange~=0,2) = ignore(UpLoopTrainNumChange(UpLoopTrainNumChange~=0));
            end
        else
            TimeTable{end}(:,1) = DownDepartTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
                (:,DownStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end-1));
            if  find(DownStationInLine{7}==KeyStation(end-1)) < find(DownStationInLine{7}==KeyStation(end))
                TimeTable{end}(:,2) = DownArrivalTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
                    (:,DownStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end));
            else
                TimeTable{end}(:,2) = zeros(size(TimeTable{end}(:,1)));
                ignore = DownArrivalTimeTable{7}(:,DownStationInLine{7}==KeyStation(end));
                TimeTable{end}(DownLoopTrainNumChange~=0,2) = ignore(DownLoopTrainNumChange(DownLoopTrainNumChange~=0));
            end
        end
    end
end
%-------------------------------------路径上的时刻表提取结束-------------------------------------
%-----------------------------------------提取各leg可行列车---------------------------------------
IndexBound = zeros(length(KeyStation)-1,2,size(TapTime,1));
[~,ignore]=max(TapTime(:,1)<TimeTable{1}(:,1)',[],2);
IndexBound(1,1,:) = reshape(ignore,[1,1,size(TapTime,1)]);
[~,ignore]=max(TapTime(:,2)<TimeTable{end}(:,2)',[],2);
ignore(ignore==0) = length(TimeTable{end});
ignore(ignore==1) = 2;
IndexBound(end,2,:) = reshape(ignore-1,[1,1,size(TapTime,1)]);
for i = 2:length(KeyStation)-1
    [~,ignore] = max(TimeTable{i-1}(reshape(IndexBound(i-1,1,:),[size(TapTime,1),1]),2) < TimeTable{i}(:,1)',[],2);
    IndexBound(i,1,:) = reshape(ignore,[1,1,size(TapTime,1)]);
end
for i = length(KeyStation)-2:-1:1
    [~,ignore] =  max(TimeTable{i+1}(reshape(IndexBound(i+1,2,:),[size(TapTime,1),1]),1) < TimeTable{i}(:,2)',[],2);
    ignore(ignore==0) = length(TimeTable{i});
    ignore(ignore==1) = 2;
    IndexBound(i,2,:) = reshape(ignore-1,[1,1,size(TapTime,1)]);
end
%-----------------------------------------提取各leg可行列车结束---------------------------------------
%-------------------------------------------提取可行列车组合-------------------------------------------
TrainCombine = cell(size(TapTime,1),1);
% InVehicleTime = 0;
% for i = 1:length(TimeTable)
%     InVehicleTime = InVehicleTime +TimeTable{i}(1,2)-TimeTable{i}(1,1);
% end
for i = 1:size(TapTime,1)
    if sum(IndexBound(:,1,i)<=IndexBound(:,2,i)) == length(KeyStation)-1
        %&& TapTime(i,2)-TapTime(i,1)<  InVehicleTime+480*(datenum('12:00:01')-datenum('12:00:00'))*length(KeyStation)
        TrainCombine{i} = zeros(prod(IndexBound(:,2,i)-IndexBound(:,1,i)+1),length(KeyStation));
        for j = 2:length(KeyStation)-2
            TrainCombine{i}(:,j) = repmat(kron((IndexBound(j,1,i):IndexBound(j,2,i))',ones(prod(IndexBound(j+1:end,2,i)-IndexBound(j+1:end,1,i)+1),1))...
                ,[prod(IndexBound(1:j-1,2,i)-IndexBound(1:j-1,1,i)+1),1]);
        end
        TrainCombine{i}(:,1) = kron((IndexBound(1,1,i):IndexBound(1,2,i))',ones(prod(IndexBound(2:end,2,i)-IndexBound(2:end,1,i)+1),1));
        if length(KeyStation)>2
            TrainCombine{i}(:,end-1) = repmat((IndexBound(end,1,i):IndexBound(end,2,i))',[prod(IndexBound(1:end-1,2,i)-IndexBound(1:end-1,1,i)+1),1]);
        end
        for j = 1:length(KeyStation)-1
            TrainCombine{i}(TimeTable{j}(TrainCombine{i}(:,j),1)==0|TimeTable{j}(TrainCombine{i}(:,j),2)==0,:) = [];
        end
        JudgeMatrix = zeros(size(TrainCombine{i},1),size(TrainCombine{i},2)-1);
        for j = 1:length(KeyStation)-2
            JudgeMatrix(:,j) = TimeTable{j+1}(TrainCombine{i}(:,j+1),1) - TimeTable{j}(TrainCombine{i}(:,j),2);
        end
        TrainCombine{i}(any(JudgeMatrix<0,2),:) = [];
        TrainCombine{i}(:,length(KeyStation)) = i;
    else
        TrainCombine{i} = [];
    end
    if size(TrainCombine{i},1) > 50
        TrainCombine{i}=[];
    end
end

%-----------------------------------------提取可行列车组合结束-------------------------------------------
%-------------------------------------------提取可行行程组合---------------------------------------------
TrainCombine = cell2mat(TrainCombine);
if ~isempty(TrainCombine)
    EarlistTrain = zeros(size(TrainCombine,1),size(TrainCombine,2)-1);
    for i = 1:max(TrainCombine(:,end))
        EarlistTrain(TrainCombine(:,end)==i,1) = min(TrainCombine(TrainCombine(:,end)==i,1));
        for j = 2:size(TrainCombine,2)-1
            for k = min(unique(TrainCombine(TrainCombine(:,end)==i,j-1))):max(unique(TrainCombine(TrainCombine(:,end)==i,j-1)))
                EarlistTrain(TrainCombine(:,end)==i&TrainCombine(:,j-1)==k,j) = min(TrainCombine(TrainCombine(:,end)==i&TrainCombine(:,j-1)==k,j));
            end
        end
    end
    RepTimes = prod(TrainCombine(:,1:end-1) -EarlistTrain+1,2);
    ArriveMark = zeros(sum(RepTimes),length(KeyStation)-1);
    counter = 0;
    for  i = 1:size(TrainCombine,1)
        ignore = zeros(RepTimes(i),length(KeyStation)-1);
        for j = 2:length(KeyStation)-2
            ignore(:,j) = repmat(kron((EarlistTrain(i,j):TrainCombine(i,j))',ones(prod(TrainCombine(i,j+1:end-1)-EarlistTrain(i,j+1:end)+1),1))...
                ,[prod(TrainCombine(i,1:j-1)-EarlistTrain(i,1:j-1)+1),1]);
        end
        ignore(:,1) = kron((EarlistTrain(i,1):TrainCombine(i,1))',ones(prod(TrainCombine(i,2:end-1)-EarlistTrain(i,2:end)+1),1));
        ignore(:,end) = repmat((EarlistTrain(i,end):TrainCombine(i,end-1))',[prod(TrainCombine(i,1:end-2)-EarlistTrain(i,1:end-1)+1),1]);
        ArriveMark(counter+1:counter+size(ignore,1),:) = ignore;
        counter = counter+size(ignore,1);
    end
    ItineraryTrain = zeros(size(ArriveMark,1),size(TrainCombine,2));
    for i = 1:size(TrainCombine,2)
        ItineraryTrain(:,i) = repelem(TrainCombine(:,i),RepTimes);
    end
    % EarlistTrain = EarlistTrainExpend;
    % clear EarlistTrainExpend
    %-------------------------------------------提取可行行程组合结束---------------------------------------------
    %---------------------------------------------提取可行行程特征------------------------------------------------
    DepartTime = zeros(size(ArriveMark,1),length(KeyStation)-1);
    ArrivalTime = DepartTime;
    for i = 1:length(KeyStation)-1
        DepartTime(:,i) = TimeTable{i}(ArriveMark(:,i),1);
        ArrivalTime(:,i) = TimeTable{i}(ItineraryTrain(:,i),2);
    end
    Itinerary = zeros(size(ArriveMark,1),5*(length(KeyStation)-1)+2);
    Itinerary(:,2) = DepartTime(:,1)-TapTime(ItineraryTrain(:,end),1);
    Itinerary(:,7:5:5*(length(KeyStation)-2)+2) = DepartTime(:,2:length(KeyStation)-1) - ArrivalTime(:,1:length(KeyStation)-2);
    for i = 1:length(KeyStation)-1
        Itinerary(ArriveMark(:,i)~=1,5*(i-1)+1) = Itinerary(ArriveMark(:,i)~=1,5*(i-1)+2) -...
            (DepartTime(ArriveMark(:,i)~=1,i) - TimeTable{i}(ArriveMark(ArriveMark(:,i)~=1,i)-1));
    end
    Itinerary(Itinerary<0) = 0;
    Itinerary(:,3:5:3+5*(length(KeyStation)-2)) = ArriveMark;
    Itinerary(:,4:5:4+5*(length(KeyStation)-2)) = ItineraryTrain(:,1:end-1) - ArriveMark;
    Itinerary(:,5:5:5*(length(KeyStation)-1)) = ItineraryTrain(:,1:end-1);
    Itinerary(:,end-1) = TapTime(ItineraryTrain(:,end),2) - ArrivalTime(:,end);
    Itinerary(:,end) = ItineraryTrain(:,end);
    index = [1:5:1+5*(length(KeyStation)-2),2:5:2+5*(length(KeyStation)-2),size(Itinerary,2)-1];
    Itinerary(:,index) = round(Itinerary(:,index)/(datenum('12:00:01')-datenum('12:00:00')));
    %-------------------------------------------提取可行行程特征结束---------------------------------------------
    %---------------------------------------------计算可行行程概率-----------------------------------------------
    ArrivalInterval = zeros(size(ArrivalTime));
    for i = 1:length(KeyStation)-1
        [~,ArrivalInterval(:,i)] = max(ArrivalTime(:,i)>TimeInterval(:,1)'&ArrivalTime(:,i)<TimeInterval(:,2)',[],2);
    end
    if length(KeyStation) > 2
        LoopTransferParameter = TransferTimeParameter(LoopPath,:);
        if TransferDirectionDetail(LoopPath(1),3) == 1
            AccEgrMean(1) = UpAccessTimeParameter{TransferDirectionDetail(LoopPath(1),2)}...
                (UpStationInLine{TransferDirectionDetail(LoopPath(1),2)}==O,2);
            AccEgrVariance(1) = UpAccessTimeParameter{TransferDirectionDetail(LoopPath(1),2)}...
                (UpStationInLine{TransferDirectionDetail(LoopPath(1),2)}==O,3);
            DelayboardingParameter{1} = UpDelayboardingParameter{TransferDirectionDetail(LoopPath(1),2)}...
                {UpStationInLine{TransferDirectionDetail(LoopPath(1),2)}==O};
        else
            AccEgrMean(1) = DownAccessTimeParameter{TransferDirectionDetail(LoopPath(1),2)}...
                (DownStationInLine{TransferDirectionDetail(LoopPath(1),2)}==O,2);
            AccEgrVariance(1) = DownAccessTimeParameter{TransferDirectionDetail(LoopPath(1),2)}...
                (DownStationInLine{TransferDirectionDetail(LoopPath(1),2)}==O,3);
            DelayboardingParameter{1} = DownDelayboardingParameter{TransferDirectionDetail(LoopPath(1),2)}...
                {DownStationInLine{TransferDirectionDetail(LoopPath(1),2)}==O};
        end
        if TransferDirectionDetail(LoopPath(end),5) == 1
            AccEgrMean(end) = UpEgressTimeParameter{TransferDirectionDetail(LoopPath(end),6)}...
                (UpStationInLine{TransferDirectionDetail(LoopPath(end),6)}==D,2);
            AccEgrVariance(end) = UpEgressTimeParameter{TransferDirectionDetail(LoopPath(end),6)}...
                (UpStationInLine{TransferDirectionDetail(LoopPath(end),6)}==D,3);
        else
            AccEgrMean(end) = DownEgressTimeParameter{TransferDirectionDetail(LoopPath(end),6)}...
                (DownStationInLine{TransferDirectionDetail(LoopPath(end),6)}==D,2);
            AccEgrVariance(end) = DownEgressTimeParameter{TransferDirectionDetail(LoopPath(end),6)}...
                (DownStationInLine{TransferDirectionDetail(LoopPath(end),6)}==D,3);
        end
        for i = 1:length(KeyStation)-2
            if TransferDirectionDetail(LoopPath(i),5) == 1
                DelayboardingParameter{i+1} = UpDelayboardingParameter{TransferDirectionDetail(LoopPath(i),6)}...
                    {UpStationInLine{TransferDirectionDetail(LoopPath(i),6)} == KeyStation(i+1)};
            else
                DelayboardingParameter{i+1} = DownDelayboardingParameter{TransferDirectionDetail(LoopPath(i),6)}...
                    {DownStationInLine{TransferDirectionDetail(LoopPath(i),6)} == KeyStation(i+1)};
            end
        end
    end
    ignore = zeros(length(TimeInterval),max(max(Itinerary(:,4:5:4+5*(length(KeyStation)-2))))+1);
    DelayBoardingPro = zeros(size(ArrivalInterval));
    for i = 1:length(KeyStation)-1
        ignore(:,1:size(DelayboardingParameter{i},2)) = DelayboardingParameter{i};
        DelayBoardingPro(:,i) = ignore(ArrivalInterval(:,i)+Itinerary(:,4+(i-1)*5)*length(TimeInterval));
    end
    clear DelayboardingParameter
    if length(KeyStation)>2
        TransferPro = zeros(size(ArrivalTime,1),length(KeyStation)-2);
        for i  = 2:length(KeyStation)-1
            TransferPro(:,i-1) = LoopTransferParameter(i-1,3)*(cdf('normal',Itinerary(:,7+5*(i-2)),LoopTransferParameter(i-1,1),LoopTransferParameter(i-1,2))...
                -cdf('normal',Itinerary(:,6+5*(i-2)),LoopTransferParameter(i-1,1),LoopTransferParameter(i-1,2)))...
                +(1-LoopTransferParameter(i-1,3))*(cdf('normal',Itinerary(:,7+5*(i-2)),LoopTransferParameter(i-1,4),LoopTransferParameter(i-1,5))...
                -cdf('normal',Itinerary(:,6+5*(i-2)),LoopTransferParameter(i-1,4),LoopTransferParameter(i-1,5)));
        end
        Probability = (cdf('normal',Itinerary(:,2),AccEgrMean(1),AccEgrVariance(1)) - cdf('normal',Itinerary(:,1),AccEgrMean(1),AccEgrVariance(1)))...
            .* prod(TransferPro,2).*prod(DelayBoardingPro,2) ...
            .*pdf('normal',Itinerary(:,end-1),AccEgrMean(2),AccEgrVariance(2));
    else
        Probability = (cdf('normal',Itinerary(:,2),AccEgrMean(1),AccEgrVariance(1)) - cdf('normal',Itinerary(:,1),AccEgrMean(1),AccEgrVariance(1)))...
            .*pdf('normal',Itinerary(:,end-1),AccEgrMean(2),AccEgrVariance(2))...
            .*prod(DelayBoardingPro,2);
    end
    RouteChoiceRelatedPro =  (cdf('normal',Itinerary(:,2),AccEgrMean(1),AccEgrVariance(1)) - cdf('normal',Itinerary(:,1),AccEgrMean(1),AccEgrVariance(1)))...
            .*pdf('normal',Itinerary(:,end-1),AccEgrMean(2),AccEgrVariance(2))...
            .*DelayBoardingPro(:,1);
    MaxProIndex = zeros(size(TapTime,1),1);
    for i = 1:size(TapTime)
        PassengerIndex = find(Itinerary(:,end)==i);
        if ~isempty(PassengerIndex)
            [~,ItiMax] = max(Probability(PassengerIndex));
            MaxProIndex(i) = PassengerIndex(ItiMax);
            Probability( PassengerIndex) = Probability( PassengerIndex)/sum(Probability( PassengerIndex));
        end
    end
RouteChoiceRelatedPro(setdiff(1:size(Probability,1),MaxProIndex),:)=[]; 
    Itinerary(setdiff(1:size(Itinerary,1),MaxProIndex),:) = [];
    Probability(setdiff(1:size(Probability,1),MaxProIndex),:) = [];

    if length(KeyStation)>2
        Itinerary(:,[6:5:5*(length(KeyStation)-2)+1,7:5:5*(length(KeyStation)-2)+2,4:5:4+5*(length(KeyStation)-2)]) = [];
    else
        Itinerary(:,4) = [];
    end
    if size(Probability,1)<size(TapTime,1)
        ignore1 = zeros(size(TapTime,1),size(Itinerary,2));
        ignore2 = zeros(size(TapTime,1),1);
        ignore3 = zeros(size(TapTime,1),1);
        ignore1(logical(MaxProIndex),:) = Itinerary;
        ignore2(logical(MaxProIndex),:) = Probability;
        ignore3(logical(MaxProIndex),:) = RouteChoiceRelatedPro;
        Itinerary = ignore1;
        Probability = ignore2;
        RouteChoiceRelatedPro = ignore3;
    end
else
    Probability = zeros(size(TapTime,1),1);
    Itinerary = Probability;
end
end