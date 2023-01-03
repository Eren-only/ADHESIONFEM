function [ load ] = UpdataSpring(load,bond, x, x_Rigid, kSpring,TopElementTotal,ButtomElementTotal )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明


for i = 1 : (ButtomElementTotal+1)
   if(bond(i) ~= 0)
    %%更新y方向的载荷
%     load(i*3-1) = load(i*3-1) -  kSpring * (y(bond(1,i)) - y_Rigid(bond(2,i))); 
   
    %%更新x方向的载荷
      load(bond(i)) = load(bond(i)) -  kSpring * (x(bond(i)) - x_Rigid(i));        
    end
   
end

