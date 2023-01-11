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
    Koff = zeros(1,ButtomElementTotal+1);%连接需要断开的
    Kon = zeros(TopElementTotal,ButtomElementTotal+1);%断开需要连接的，！！！杆尾部不需要连接
    
    alpha = 0.1;%用来抑制出现连接交叉的情况

    for index1 = 1 : ButtomElementTotal+1
        randNum = rand;
        %对刚体平面有无连接杆
        if(bond(index1)~= 0)%有连接
             ButtonId = index1;
             Koff(index1) = K_off0*exp(abs(kSpring*(x(bond(index1)) - x_Rigid(index1))/Fb));

             %求出连接需要断开的时间
             t = log(1/randNum)/Koff(index1);
             if(t <= 0)
                 test="t.txt";
                 fid = fopen(test,'w');
             end
             %求出连接需要断开的最小时间，以及对应的id
             if(detaTmin > t)
                detaTmin = t;
                ChangeTopId = TopId;
                ChangeButtonId = ButtonId;
             end

            %使上面的梁节点以及与它相连的刚节点不被使用
            for index2 = 1 : ButtomElementTotal+1
               Kon(bond(index1),index2) = -1;
            end
            for index3 = 1 : TopElementTotal
               Kon(index3,index1) = -1;
            end
        else%无连接
            ButtonId = index1;
            Koff(index1) = -1;
            for index4 = 1 : TopElementTotal
                if(Kon(index4,index1)~=-1)
                   dist = x(index4) - x_Rigid(ButtonId);%只考虑了x方向
                   if dist >= 0
                      Kon(index4,index1) = K_on0 * exp(-0.5*kSpring*dist^2/KBT); 
                   else
                      Kon(index4,index1) = alpha * K_on0*exp(-0.5*kSpring*dist^2/KBT); 
                   end
                end
            end   
        end  
    end
    
    %求连接需要时间
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