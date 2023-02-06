function [F,disX]=FEM(du,x,x_Rigid,TopElementTotal,ButtomElementTotal,crossAera,E,bond,kSpring)

%%%%%ƽ����ϵ����Ԫ�������
%���嵥Ԫ������װ
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


% Լ�������λ��
% for i=1:3
%     load(i)=0;
% end
% % %%qpply bc ��u1��v1,theta1=0��u2��v2,theta2=0�� q and F
% % 
% %%%bc:��˵�u v theta=0
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

% Լ�������λ��
% load(1) = 0;
% KK(1,2)=0;
% KK(2,1)=0;

%%%�Ҷ˼�duλ��
load(TopElementTotal+1)=10^10*KK((TopElementTotal+1),(TopElementTotal+1))*du;
KK((TopElementTotal+1),(TopElementTotal+1))=10^10*KK((TopElementTotal+1),(TopElementTotal+1));



 %%%%%%%%%���ڵ�λ��
 deltau=(load/KK)';%ʹ��ֱ�ӷ�

%  load = sparse(load');
%  deltau = solveEquation22(KK,load,1e-5);%ʹ�ù����ݶȷ�
 

for i=1:TopElementTotal+1
    disX(i) = deltau(i);
end

F = (cal_K *  deltau)';
end

