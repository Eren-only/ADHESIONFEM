function y =PlaneFrameAssemble(KK,k,i,j)
%���Ϻ������е�Ԫ�նȾ������װ
%���뵥Ԫ�նȾ��� k����Ԫ�Ľڵ��� i�� j
%�������նȾ��� KK
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