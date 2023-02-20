clc
clear
% rand('seed',sum(100*clock));
%  for j = 1:2
%     for i = 1:2
%          Y(i,j)= rand
%     end
%  end
% KK = zeros(100,100);
% KK = KK + 1;
% for i = 2 : 3 : 100
%     for j = 1 : 100
%         if j~=i
%             KK(i,j)=0;
%             KK(j,i)=0;
%         end
%     end
% 
%     KK(i,i)=1;
% end
% yao = 100;
% 
% STR=sprintf('%s%d',num2str(yao),'saa','\.txt')
% 
%   fid = fopen(STR,'w');
% 
%  for i = 2 : 3 : 100
%     fprintf(fid,'速度是：%g\n',i);
%     fprintf(fid,'时间：%g\t');
%     fprintf(fid,'连接数：%g\t');
%     fprintf(fid,'支反力：%g\t');
%     fprintf(fid,'\r\n');
%      for j = 1 :3
%         fprintf(fid,'%g\t',j+1);      
%      end
%      fprintf(fid,'\r\n');
%     fprintf(fid,'----------------------------------------%g\n');
%     fprintf(fid,'\r\n');
%  end
%  fclose(fid);
close all; clear all; clc

fileID=fopen('E600-k0.03-v5.txt');

C=textscan(fileID,'%f %f %f');

fclose(fileID);

format compact

celldisp(C)


subplot(1,2,1)
plot(C{1},C{2});
title(['velocity is ',num2str(0.02),'nm/s'])
xlabel('时间 s')
ylabel('连接个数')

subplot(1,2,2)
plot(C{1},C{3});
title(['velocity is ',num2str(0.02),'nm/s'])
xlabel('时间 s')
ylabel('左端点支反力 pN')


