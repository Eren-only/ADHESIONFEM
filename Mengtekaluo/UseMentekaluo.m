clc
clear
tic
%%
%%初始化杆参数
length = 100;
width = 4;
height = 3;
crossAera = width * height;
E =14000;%单位Mpa
kSpring = 0.3;%pn/nm
TopElementTotal =100;%杆单元总数 
x=zeros(1,TopElementTotal+1);%%每个节点x坐标
for i= 1:(TopElementTotal+1)
    x(i) = (i-1)/TopElementTotal * length;
end

%%初始化刚平面
RigidLength = 200;%%刚体水平面的长度
ButtomElementTotal = TopElementTotal/length*RigidLength;%%刚平面单元总数
x_Rigid=zeros(1,ButtomElementTotal);%%每个刚体水平面节点x坐标
for i= 1:(ButtomElementTotal +1)
    x_Rigid(i) = (i-1)/TopElementTotal * length;
end

%%初始化界面弹簧连接数  ！！！杆尾部不加弹簧
bond = zeros(1,ButtomElementTotal +1);
Num = TopElementTotal/2;%弹簧连接数
for i= 1:1:Num
     bond(i) = i;
end

%初始化输出变量
F = zeros(1,TopElementTotal+1);%%每个节点内力
fSpringForce = zeros(1,TopElementTotal);%%除了约束端，弹簧施加在节点的力
totalSpringForce = 0;%所有弹簧力相加
Reaction = zeros(1,TopElementTotal+1);%%每个节点支反力
sigma = zeros(1,TopElementTotal+1);
disX = zeros(1,TopElementTotal+1);
y = zeros(1,TopElementTotal+1);%用来画图



%%开始求解
vEnd = 50;
T = 10;
dt = 0.1;
du = vEnd / T * dt;
U = 0;
t = dt;

result="测试.txt";
fid = fopen(result,'w');
while t < T

    [F,disX]=FEM(du,x,x_Rigid,TopElementTotal,ButtomElementTotal,crossAera,E,bond,kSpring); 
    for i=1:(TopElementTotal+1)
         x(i) = x(i) + disX(i);
    end
   
    %%只有右边约束时，根据静力平衡，支反力应该等于弹簧力总和，弹簧力用位移算当前时刻
    for k = 1 : ButtomElementTotal+1
        if(bond(k) ~= 0)
            fSpringForce(bond(k)) = kSpring * (x(bond(k)) - x_Rigid(k));
            totalSpringForce = totalSpringForce + fSpringForce(bond(k)); 
        end
    end

    Reaction = Reaction + F;%计算内力需要不断叠加
    fprintf(fid,'%g\t',totalSpringForce);
    fprintf(fid,'\r\n');
    totalSpringForce = 0;%将总弹簧力置0
    [detaTmin,bond,Num]=calstate(TopElementTotal,ButtomElementTotal,x,x_Rigid,bond,kSpring,Num);
    bond
    U = U + du;
    dt = detaTmin;
    t = t + dt;
    du = vEnd / T * dt;
end

fclose(fid);
toc

