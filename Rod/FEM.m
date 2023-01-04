function [F,disX]=FEM(du,x,x_Rigid,TopElementTotal,ButtomElementTotal,crossAera,E,bond,kSpring)

%%%%%平面梁系有限元计算变形
%整体单元矩阵组装
KK=sparse(TopElementTotal+1, TopElementTotal+1);
%KK=zeros(TopElementTotal+1,TopElementTotal+1);
load=zeros(1,TopElementTotal+1);
disX=zeros(1,TopElementTotal+1);
oriLength = zeros(1,TopElementTotal);
curLength = zeros(1,TopElementTotal);

for i=1:TopElementTotal
    oriLength(i) = PlaneElementLength(x(i),x(i+1),i);
    k = E*crossAera/oriLength(i)*[1 -1;-1 1];
    KK=PlaneFrameAssemble(KK,k,i,i+1);
end

cal_K = KK;


for i=1:(ButtomElementTotal+1) 
    if(bond(i) ~= 0)
       KK(bond(i),bond(i))=KK(bond(i),bond(i))+ 0.5*kSpring; 
    end
%     KK(i*3-1,i*3-1)=KK(i*3-1,i*3-1)+ kSpring;
end

[load] = UpdataSpring(load,bond, x, x_Rigid, kSpring,TopElementTotal,ButtomElementTotal);


% 
% for i=1:3
%     load(i)=0;
% end
% % %%qpply bc ：u1，v1,theta1=0；u2，v2,theta2=0； q and F
% % 
% %%%bc:左端点u v theta=0
% for i=1:6
%    if i~=1
%     KK(1,i)=0;
%     KK(i,1)=0;
%    end
%    
%     if i~=2
%     KK(2,i)=0;
%     KK(i,2)=0;
%     end
%     
%     if i~=3
%     KK(3,i)=0;
%     KK(i,3)=0;
%    end
% end

load(1) = 0;
KK(1,2)=0;
KK(2,1)=0;

%%%加位移
load(TopElementTotal+1)=10^10*KK((TopElementTotal+1),(TopElementTotal+1))*du;
KK((TopElementTotal+1),(TopElementTotal+1))=10^10*KK((TopElementTotal+1),(TopElementTotal+1));

%右端点y方向位移为0
% for i = ((TopElementTotal+1)*3 - 5) : (TopElementTotal+1)*3 
%     if i~=((TopElementTotal+1)*3 - 1)
%         KK(((TopElementTotal+1)*3 - 1),i)=0;
%         KK(i,((TopElementTotal+1)*3 - 1))=0;
%     end
% end
% 
% load((TopElementTotal+1)*3-1)=0;
% 
% for i = 1 : 6
%     if i~=2
%         KK(2,i)=0;
%         KK(i,2)=0;
%     end
% end
% 
% load(2)=0;
%%%

 %%%%%%%%%求解节点位移
 deltau=(load/KK)';

%  load = sparse(load');
%  deltau = solveEquation22(KK,load,1e-5);
 
 %%%%%计算每个节点的位移
% for i=1:(TopElementTotal+1)
%     x(i) = x(i) + deltau(i);
% end
for i=1:TopElementTotal+1
    disX(i) = deltau(i);
   % curLength(i) = PlaneElementLength(x(i),x(i+1),i);
end
%F = CalElementForce(cal_K,curLength,oriLength,E,crossAera);
F = (cal_K *  deltau)';
end

