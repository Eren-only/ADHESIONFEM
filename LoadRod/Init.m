clc
clear
tic
%%
%%初始化
length = 100;
width = 1.5;
height = 2;
crossAera = width * height;
E =140000;
kSpring = 0.3;

%%初始化梁平面
%%单元总数
TopElementTotal =99;
vLeft=5;
T = 5;

%%初始化刚平面
RigidLength = 200;%%刚体水平面的长度
ButtomElementTotal = TopElementTotal/length*RigidLength;%%单元总数
x_Rigid=zeros(1,ButtomElementTotal);%%每个刚体水平面节点x坐标

for i= 1:(ButtomElementTotal +1)
    x_Rigid(i) = (i-1)/TopElementTotal * length;
end


parfor v = 1 : vLeft
    vEnd = v*10;
    result="E"+num2str(E)+"-k"+num2str(kSpring)+"-v"+num2str(vEnd/T)+".txt";
    fid = fopen(result,'w');
%     fprintf(fid,'速度是：%g\n',vEnd/T);
%     fprintf(fid,'时间：%g\t');
%     fprintf(fid,'连接数：%g\t');
%     fprintf(fid,'支反力：%g\t');
%     fprintf(fid,'\r\n');

    x=zeros(1,TopElementTotal+1);%%每个节点x坐标
    
    
    F = zeros(1,TopElementTotal+1);%%每个节点力
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
    %设置初始绑定，梁的一半与刚平面绑定
    for i= 1:(TopElementTotal+1)/2
        bond(i) = i;
    end
    
     Num = (TopElementTotal+1)/2;
%     bondNum = [bondNum,Num];
    
    %%开始求解
    dt = 0;
    du = 0;
    U = 0;
    t = 0;
    
    
    while t <= T
        fprintf(fid,'%g\t',t); 
        fprintf(fid,'%g\t',Num); 
        fprintf(fid,'%g\t',F(TopElementTotal+1)); 
        fprintf(fid,'\r\n');

        [F,disX]=FEM(du,x,x_Rigid,TopElementTotal,ButtomElementTotal,crossAera,E,bond,kSpring); 
        %%load = F;
        for i = 1 : (TopElementTotal+1)
            x(i) = x(i) + disX(i);
        end
        %%弹簧不应该加，因为不是约束
        %%支反力是那种约束位移的
    %     Reaction = Reaction + F
        [detaTmin,bond,Num]=calstate(TopElementTotal,ButtomElementTotal,x,x_Rigid,bond,kSpring,Num);
        dt = detaTmin;
        U = U + du;
        t = t + dt;
        plot(x,y);
        drawnow
        du = vEnd / T * dt;
%         bondNum = [bondNum,Num];
%         bond
%         t
    end
    fprintf(fid,'%g\t',t); 
    fprintf(fid,'%g\t',Num); 
    fprintf(fid,'%g\t',F(TopElementTotal+1)); 

    fprintf(fid,'\r\n');
%     fprintf(fid,'----------------------------------------%g\n');
%     fprintf(fid,'\r\n');
    fclose(fid); 
end
%%
%%绘图
for v = 1 : vLeft
    vEnd = v * 10;
    result1="E"+num2str(E)+"-k"+num2str(kSpring)+"-v"+num2str(vEnd/T)+".txt";
    fileID=fopen(result1);
    
    Infortxt=textscan(fileID,'%f %f %f');
    
    fclose(fileID);
    
    format compact
    
    celldisp(Infortxt);
    
    
    subplot(1,2,1)
    plot(Infortxt{1},Infortxt{2});
    title(['velocity is ',num2str(vEnd/T),'nm/s']);
    xlabel('时间 s');
    ylabel('连接个数');
    
    subplot(1,2,2)
    plot(Infortxt{1},Infortxt{3});
    title(['velocity is ',num2str(vEnd/T),'nm/s']);
    xlabel('时间 s');
    ylabel('左端点支反力 pN');
    figure
end


toc
% 
% hold on
% plot(x_Rigid,y_Rigid);
% xlim([-10 300])
% ylim([-0.2 2])
