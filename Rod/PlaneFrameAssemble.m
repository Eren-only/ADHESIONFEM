function y =PlaneFrameAssemble(KK,k,i,j)
%以上函数进行单元刚度矩阵的组装
%输入单元刚度矩阵 k，单元的节点编号 i、 j
%输出整体刚度矩阵 KK
%-

DOF(1)=i;
DOF(2)=j;

for n1=1:2
    for n2=1:2
        KK(DOF(n1),DOF(n2))=KK(DOF(n1),DOF(n2))+k(n1,n2);
    end
end
y = KK;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end