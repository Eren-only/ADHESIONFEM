function [ load ] = UpdataSpring(load,bond, x, x_Rigid, kSpring,TopElementTotal,ButtomElementTotal )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


for i = 1 : (ButtomElementTotal+1)
   if(bond(i) ~= 0)
    %%����y������غ�
%     load(i*3-1) = load(i*3-1) -  kSpring * (y(bond(1,i)) - y_Rigid(bond(2,i))); 
   
    %%����x������غ�
      load(bond(i)) = load(bond(i)) -  kSpring * (x(bond(i)) - x_Rigid(i));        
    end
   
end

