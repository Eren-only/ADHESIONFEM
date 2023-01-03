clc
clear
tic
%%
%%初始化
length = 100;
width = 1.5;
height = 2;
crossAera = width * height;
E =14;
kSpring = 0.3;

%%初始化梁平面
%%单元总数
TopElementTotal =1;
vLeft=5;
T = 5;

%%初始化刚平面
RigidLength = 200;%%刚体水平面的长度
ButtomElementTotal = TopElementTotal/length*RigidLength;%%单元总数
x_Rigid=zeros(1,ButtomElementTotal);%%每个刚体水平面节点x坐标

for i= 1:(ButtomElementTotal +1)
    x_Rigid(i) = (i-1)/TopElementTotal * length;
end



    vEnd = 50;
    result="E"+num2str(E)+"-k"+num2str(kSpring)+"-v"+num2str(vEnd/T)+".txt";
    fid = fopen(result,'w');
%     fprintf(fid,'速度是：%g\n',vEnd/T);
%     fprintf(fid,'时间：%g\t');
%     fprintf(fid,'连接数：%g\t');
%     fprintf(fid,'支反力：%g\t');
%     fprintf(fid,'\r\n');

    x=zeros(1,TopElementTotal+1);%%每个节点x坐标
    
    
    F = zeros(1,TopElementTotal+1);%%每个节点内力
    fSpringForce = zeros(1,TopElementTotal);%%除了约束端，弹簧施加在节点的力
    totalSpringForce = 0;%所有弹簧力相加
    Reaction = zeros(1,TopElementTotal+1);%%每个节点支反力
    sigma = zeros(1,TopElementTotal+1);
    disX = zeros(1,TopElementTotal+1);
    y = zeros(1,TopElementTotal+1);%用来画图
    
    for i= 1:(TopElementTotal+1)
        x(i) = (i-1)/TopElementTotal * length;
    end
    
    %%绑定节点编号
    %%刚体水平面绑定的梁结点编号，没绑定为0
    bond = zeros(1,ButtomElementTotal +1);
%     bondNum = [];

%     for i= 1:TopElementTotal
%         bond(i) = i;
%     end
   % bond(1) = 1;
    
    %%开始求解
    dt = 1;
    du = 1;
    U = 0;
    t = 0.1;
    x(TopElementTotal+1) = x(TopElementTotal+1) + du;

    
    while t < T
        fprintf(fid,'%g\t',t); 
        fprintf(fid,'%g\t',Reaction(TopElementTotal+1)); 
        fprintf(fid,'\r\n');

        [F,disX]=FEM(du,x,x_Rigid,TopElementTotal,ButtomElementTotal,crossAera,E,bond,kSpring); 
        %%load = F;
        for i=1:(TopElementTotal+1)
             x(i) = x(i) + disX(i);
        end
           

        %%支反力应该等于弹簧力加内力，弹簧力用位移算当前时刻，内力需要叠加
        for k = 1 : ButtomElementTotal+1
            if(bond(k) ~= 0)
                fSpringForce(x(bond(k))) = kSpring * (x(bond(k)) - x_Rigid(k));
                totalSpringForce = totalSpringForce + fSpringForce(x(bond(k))); 
            end

        end
         %Reaction = totalSpringForce + F;
         Reaction = Reaction + F;
       %% [detaTmin,bond,Num]=calstate(TopElementTotal,ButtomElementTotal,x,x_Rigid,bond,kSpring,Num);
        dt = 0.1;
        U = U + du;
        t = t + dt;
        plot(x,y);
        drawnow
        du = vEnd / T * dt;
        x(TopElementTotal+1) = x(TopElementTotal+1) + du;
%         bondNum = [bondNum,Num];
%         bond
%         t
    end

%     fprintf(fid,'----------------------------------------%g\n');
%     fprintf(fid,'\r\n');
    fclose(fid); 

%%
%%绘图



    vEnd = vLeft * 10;
    result1="E"+num2str(E)+"-k"+num2str(kSpring)+"-v"+num2str(vEnd/T)+".txt";
    fileID=fopen(result1);
    
    Infortxt=textscan(fileID,'%f %f');
    
    fclose(fileID);
    
    format compact;
    
    celldisp(Infortxt);
    

    plot(Infortxt{1},Infortxt{2});
    title(['velocity is ',num2str(vEnd/T),'nm/s']);
    xlabel('时间 s');
    ylabel('左端点支反力 pN');


toc
% 
% hold on
% plot(x_Rigid,y_Rigid);
% xlim([-10 300])
% ylim([-0.2 2])
