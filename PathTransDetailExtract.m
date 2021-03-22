clear
clc
TotalLineNum = 10;%--->线网中线编号最大值，为线网升级做准备
TransferDirectionDetail = xlsread('D:\MATLABCode\Initial_data\TransferDirectionDetail');
PathCounterLb = xlsread('D:\MATLABCode\Initial_data\PathCounter',1);
ConnectionMatrix = xlsread('D:\MATLABCode\Initial_data\Connection_matrix');
ConnectionMatrix = ConnectionMatrix+ConnectionMatrix';
PathCounterUb = xlsread('D:\MATLABCode\Initial_data\PathCounter',2);
PathSet = xlsread('D:\MATLABCode\Initial_data\PathSet');
UpStationInLine = cell(10,1);DownStationInLine = cell(10,1);
for Line = 1:TotalLineNum
    UpStationInLine{Line} = xlsread('D:\MATLABCode\Processed_data\UpStationInLine',Line);
    DownStationInLine{Line} = xlsread('D:\MATLABCode\Processed_data\DownStationInLine',Line);
end
PathLineInf = zeros(size(PathSet,1),size(PathSet,2));PathDireInf = PathLineInf;
for i = 1:length(PathSet)
    for j = 1:size(PathSet,2)-1
        if PathSet(i,j+1) ~= 0
            PathLineInf(i,j) = ConnectionMatrix(PathSet(i,j),PathSet(i,j+1));
            if find(UpStationInLine{PathLineInf(i,j)}==PathSet(i,j+1))-find(UpStationInLine{PathLineInf(i,j)}==PathSet(i,j)) == 1
                PathDireInf(i,j) = 1;
            else
                PathDireInf(i,j) = 2;
            end
        end
    end
end
TransferStation = zeros(size(PathSet));
for i = 1:length(PathSet)
    for j = 2:size(PathSet,2)-1
        if PathSet(i,j+1)
            if PathLineInf(i,j-1) ~= PathLineInf(i,j)
                TransferStation(i,j) = PathSet(i,j);
            end
        else
            break
        end
    end
end
PathTransDetail = zeros(length(PathSet),max(sum(logical(TransferStation),2)));
ignore = 1:length(TransferDirectionDetail);
for i = 1:length(PathSet)
    counter = 0;
    for j = 2:size(PathSet,2)-1
        if TransferStation(i,j)~=0
            counter = counter+1;
            [~,index2]=ismember(...
                            [PathLineInf(i,j-1) PathDireInf(i,j-1) TransferStation(i,j) PathDireInf(i,j) PathLineInf(i,j) ],TransferDirectionDetail(:,2:6),'rows');
                        PathTransDetail(i,counter) = ignore(index2);
        end
    end
end
xlswrite('D:\MATLABCode\Processed_data\PathLineInf',PathLineInf);
xlswrite('D:\MATLABCode\Processed_data\PathTransDetail',PathTransDetail);