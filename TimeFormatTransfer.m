function [result] = TimeFormatTransfer(input)
%将时间转化为小数格式
%清洗不合理时间
input=strrep(input,'"','');
input = [datenum(input(:,1),'yyyy/mm/dd HH:MM:SS'),datenum(input(:,2),'yyyy/mm/dd HH:MM:SS')];
input(input(:,1)<datenum('2018/04/05 01:00:00','yyyy/mm/dd HH:MM:SS'),:) = [];
input(input(:,2)<=input(:,1),:) = [];
TravelTime = input(:,2)-input(:,1);
ignore1 = prctile(TravelTime,80);
ignore2 = prctile(TravelTime,20);
Mean = mean(TravelTime(TravelTime<ignore1&TravelTime>ignore2));
input(TravelTime>1.2*Mean|TravelTime<0.1*Mean,:) = [];
result = input;
end

