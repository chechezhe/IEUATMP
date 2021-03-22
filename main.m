%| Itinerary estimation using Automated Fare Collection and train operation timetable data for metro passengers.
%|       Published by ³ÂÐÀ (Xin Chen) from (Southwest Jiaotong University School of transportation and logistics)
%| and (Transport Division of Technical University of Denmark).
%|       This code is a part of code for an unpublished paper ¡®Crowding Valuation Using Itinerary Preference
%| Estimated from Automated Fare Collection Data in Metro Systems¡¯
%|       Due to the difference in computing environment, running time calculate method, and data, we cannot 
%| guarantee that the program is efficient than previous research, the code is for algorithm reference only.
%| If you want to use these codes, be prepared to spend some time understanding them. The naming is easy
%| to understand, hope it will help you. The codes come with no warranty; however, certain errors may remain.
%| You can use the program for academic purposes. What I ask in return is that you reference my paper.
%| When the paper is published, I will attach the link.
%| If you have any questions feel free to contact me. My E-mail is: swjtu_chenxin@163.com
%|       This script takes passengers from ChunXiLu(O = 8) to HuaiShuDian (D = 83) of Chengdu Metro as an example. 
%| All data can be found in ¡®InitialData.mat¡¯. Due to the confidentiality of the data, some data has been added with noise.

clear
clc
load('InitialData');
O = 7;
D = 83;
[~,~,TapTime] = xlsread('TapTime');
TapTime = TimeFormatTransfer(TapTime);%--->Data cleearning
Itinerary = cell(PathCounterUb(O,D)-PathCounterLb(O,D)+1,1);
Probability = zeros(size(TapTime,1),PathCounterUb(O,D)-PathCounterLb(O,D)+1);
RouteChoiceRelatedPro = zeros(size(TapTime,1),PathCounterUb(O,D)-PathCounterLb(O,D)+1);
for PathIndex = PathCounterLb(O,D):PathCounterUb(O,D)
    LoopPath = PathTransDetail(PathIndex,PathTransDetail(PathIndex,:)~=0);
    [Itinerary{PathIndex-PathCounterLb(O,D)+1},Probability(:,PathIndex-PathCounterLb(O,D)+1),RouteChoiceRelatedPro(:,PathIndex-PathCounterLb(O,D)+1)]...%,OAndDPro(:,PathIndex-PathCounterLb(O,D)+1)
        = ItineraryExtract(O,D,TapTime,LoopPath,PathIndex);
end
Probability = Probability.*(RouteChoiceRelatedPro./repmat(sum(RouteChoiceRelatedPro,2),1,PathCounterUb(O,D)-PathCounterLb(O,D)+1));
[~,Route]=max(Probability,[],2);