function [TimeTable] = PathTimeTableExtract(KeyStation)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
global  PathLineInf  TransferDirectionDetail...
    UpDepartTimeTable UpArrivalTimeTable  DownDepartTimeTable DownArrivalTimeTable...
    UpStationInLine DownStationInLine
TimeTable = cell(length(KeyStation)-1,1);
if length(KeyStation) == 2
    Line = unique(PathLineInf(PathIndex,find(PathLineInf(PathIndex)~=0)));
    if find(UpStationInLine{Line}==O) < find(DownStationInLine{Line}==D)
        TimeTable{1}(:,1) = UpDepartTimeTable(:,find(UpStationInLine{Line}==O));
        TimeTable{1}(:,2) = UpArrivalTimeTable(:,find(UpStationInLine{Line}==D));
    else
        TimeTable{1}(:,1) = DownDepartTimeTable(:,find(UpStationInLine{Line}==O));
        TimeTable{1}(:,2) = DownArrivalTimeTable(:,find(UpStationInLine{Line}==D));
    end
else
    for i = 1:length(KeyStation)-2
        if TransferDirectionDetail(LoopPath(i),3) == 1
        TimeTable{i}(:,1) = UpDepartTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
            (:,find(UpStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i)));
        TimeTable{i}(:,2) = UpArrivalTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
            (:,find(UpStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i+1)));
        else
            TimeTable{i}(:,1) = DownDepartTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
            (:,find(DownStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i)));
        TimeTable{i}(:,2) = DownArrivalTimeTable{TransferDirectionDetail(LoopPath(i),2)}...
            (:,find(DownStationInLine{TransferDirectionDetail(LoopPath(i),2)}==KeyStation(i+1)));
        end
    end
    if TransferDirectionDetail(LoopPath(end),5) == 1
    TimeTable{end}(:,1) = UpDepartTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
        (:,find(UpStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end-1)));
    TimeTable{end}(:,2) = UpDepartTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
        (:,find(UpStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end)));
    else
         TimeTable{end}(:,1) = DownDepartTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
        (:,find(DownStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end-1)));
    TimeTable{end}(:,2) = DownDepartTimeTable{TransferDirectionDetail(LoopPath(end),6)}...
        (:,find(DownStationInLine{TransferDirectionDetail(LoopPath(end),6)}==KeyStation(end)));
    end
end
end

