clc
clear
tic
%%
%%��ʼ��
length = 100;
width = 1.5;
height = 2;
crossAera = width * height;
E =140000;
kSpring = 0.3;

%%��ʼ����ƽ��
%%��Ԫ����
TopElementTotal =99;
vLeft=5;
T = 5;

%%��ʼ����ƽ��
RigidLength = 200;%%����ˮƽ��ĳ���
ButtomElementTotal = TopElementTotal/length*RigidLength;%%��Ԫ����
x_Rigid=zeros(1,ButtomElementTotal);%%ÿ������ˮƽ��ڵ�x����

for i= 1:(ButtomElementTotal +1)
    x_Rigid(i) = (i-1)/TopElementTotal * length;
end


parfor v = 1 : vLeft
    vEnd = v*10;
    result="E"+num2str(E)+"-k"+num2str(kSpring)+"-v"+num2str(vEnd/T)+".txt";
    fid = fopen(result,'w');
%     fprintf(fid,'�ٶ��ǣ�%g\n',vEnd/T);
%     fprintf(fid,'ʱ�䣺%g\t');
%     fprintf(fid,'��������%g\t');
%     fprintf(fid,'֧������%g\t');
%     fprintf(fid,'\r\n');

    x=zeros(1,TopElementTotal+1);%%ÿ���ڵ�x����
    
    
    F = zeros(1,TopElementTotal+1);%%ÿ���ڵ���
    Reaction = zeros(1,TopElementTotal+1);%%ÿ���ڵ�֧����
    sigma = zeros(1,TopElementTotal+1);
    disX = zeros(1,TopElementTotal+1);
    y = zeros(1,TopElementTotal+1);%������ͼ
    
    for i= 1:(TopElementTotal+1)
        x(i) = (i-1)/TopElementTotal * length;
    end
    
    %%�󶨽ڵ���
    %%����ˮƽ��󶨵�������ţ�û��Ϊ0
    bond = zeros(1,ButtomElementTotal +1);
%     bondNum = [];
    %���ó�ʼ�󶨣�����һ�����ƽ���
    for i= 1:(TopElementTotal+1)/2
        bond(i) = i;
    end
    
     Num = (TopElementTotal+1)/2;
%     bondNum = [bondNum,Num];
    
    %%��ʼ���
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
        %%���ɲ�Ӧ�üӣ���Ϊ����Լ��
        %%֧����������Լ��λ�Ƶ�
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
%%��ͼ
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
    xlabel('ʱ�� s');
    ylabel('���Ӹ���');
    
    subplot(1,2,2)
    plot(Infortxt{1},Infortxt{3});
    title(['velocity is ',num2str(vEnd/T),'nm/s']);
    xlabel('ʱ�� s');
    ylabel('��˵�֧���� pN');
    figure
end


toc
% 
% hold on
% plot(x_Rigid,y_Rigid);
% xlim([-10 300])
% ylim([-0.2 2])
