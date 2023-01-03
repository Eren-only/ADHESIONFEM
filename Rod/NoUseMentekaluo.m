clc
clear
tic
%%
%%初始化杆参数
length = 100;
width = 1.5;
height = 2;
crossAera = width * height;
E =14;
kSpring = 0.3;

%%杆单元总数
TopElementTotal =1;

%%初始化刚平面
RigidLength = 200;%%刚体水平面的长度
ButtomElementTotal = TopElementTotal/length*RigidLength;%%单元总数
x_Rigid=zeros(1,ButtomElementTotal);%%每个刚体水平面节点x坐标

for i= 1:(ButtomElementTotal +1)
    x_Rigid(i) = (i-1)/TopElementTotal * length;
end

x=zeros(1,TopElementTotal+1);%%每个节点x坐标
F = zeros(1,TopElementTotal+1);%%每个节点内力
fSpringForce = zeros(1,TopElementTotal);%%除了约束端，弹簧施加在节点的力
totalSpringForce = 0;%所有弹簧力相加
Reaction = zeros(1,TopElementTotal+1);%%每个节点支反力
sigma = zeros(1,TopElementTotal+1);
disX = zeros(1,TopElementTotal+1);
y = zeros(1,TopElementTotal+1);%用来画图
bond = zeros(1,ButtomElementTotal +1);

for i= 1:(TopElementTotal+1)
    x(i) = (i-1)/TopElementTotal * length;
end

%%开始求解
vEnd = 100;
T = 10;
dt = 0.1;
du = vEnd / T * dt;
U = 0;
t = dt;
x(TopElementTotal+1) = x(TopElementTotal+1) + du;

result="测试.txt";
fid = fopen(result,'w');
while t < T

    [F,disX]=FEM(du,x,x_Rigid,TopElementTotal,ButtomElementTotal,crossAera,E,bond,kSpring); 
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
     fprintf(fid,'%g\t',Reaction(TopElementTotal+1));
     fprintf(fid,'\r\n');
   %% [detaTmin,bond,Num]=calstate(TopElementTotal,ButtomElementTotal,x,x_Rigid,bond,kSpring,Num);
    U = U + du;
    t = t + dt;

    du = vEnd / T * dt;
    x(TopElementTotal+1) = x(TopElementTotal+1) + du;
    
end

fclose(fid);
toc

