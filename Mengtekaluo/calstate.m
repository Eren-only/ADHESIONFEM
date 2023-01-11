function [detaTmin,bond,Num]=calstate(TopElementTotal,ButtomElementTotal,x,x_Rigid,bond,kSpring,Num)
    rand('seed',sum(100*clock));
   
    detaTmin = 100;
    TopId = 0;
    ButtonId = 0;
    ChangeTopId = 0;
    ChangeButtonId = 0;
    isConnect = 0;
    
    K_on0 = 100;
    K_off0 = 50;
    KBT = 4;
    Fb = 9;
    Koff = zeros(1,ButtomElementTotal+1);%������Ҫ�Ͽ���
    Kon = zeros(TopElementTotal,ButtomElementTotal+1);%�Ͽ���Ҫ���ӵģ���������β������Ҫ����
    
    alpha = 0.1;%�������Ƴ������ӽ�������

    for index1 = 1 : ButtomElementTotal+1
        randNum = rand;
        %�Ը���ƽ���������Ӹ�
        if(bond(index1)~= 0)%������
             ButtonId = index1;
             Koff(index1) = K_off0*exp(abs(kSpring*(x(bond(index1)) - x_Rigid(index1))/Fb));

             %���������Ҫ�Ͽ���ʱ��
             t = log(1/randNum)/Koff(index1);
             if(t <= 0)
                 test="t.txt";
                 fid = fopen(test,'w');
             end
             %���������Ҫ�Ͽ�����Сʱ�䣬�Լ���Ӧ��id
             if(detaTmin > t)
                detaTmin = t;
                ChangeTopId = TopId;
                ChangeButtonId = ButtonId;
             end

            %ʹ��������ڵ��Լ����������ĸսڵ㲻��ʹ��
            for index2 = 1 : ButtomElementTotal+1
               Kon(bond(index1),index2) = -1;
            end
            for index3 = 1 : TopElementTotal
               Kon(index3,index1) = -1;
            end
        else%������
            ButtonId = index1;
            Koff(index1) = -1;
            for index4 = 1 : TopElementTotal
                if(Kon(index4,index1)~=-1)
                   dist = x(index4) - x_Rigid(ButtonId);%ֻ������x����
                   if dist >= 0
                      Kon(index4,index1) = K_on0 * exp(-0.5*kSpring*dist^2/KBT); 
                   else
                      Kon(index4,index1) = alpha * K_on0*exp(-0.5*kSpring*dist^2/KBT); 
                   end
                end
            end   
        end  
    end
    
    %��������Ҫʱ��
    for index5 = 1 : ButtomElementTotal+1
        for index6 = 1 : TopElementTotal
            randNum = rand;
            if(Kon(index6,index5) ~= -1)
                    TopId = index6;
                    ButtonId = index5;
                    t = log(1/randNum)/Kon(index6,index5);
                    if(t <= 0)
                        pause;
                    end
                    if(detaTmin > t)
                        detaTmin = t;
                        ChangeTopId = TopId;
                        ChangeButtonId = ButtonId;
                        isConnect = 1;
                    end

            end    
        end
    end
    
    if(isConnect == 1)
        bond(ChangeButtonId) = ChangeTopId;
        Num = Num + 1;
    else
        bond(ChangeButtonId) = 0;
        Num = Num - 1;
    end
       
   detaTmin
end