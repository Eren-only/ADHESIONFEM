function [whole_displcement] = solveEquation2(K, P, tol)
% ��������ⷽ��
% ���룺 
    % ����������նȾ���K����
    % ����P
% �����ݶȷ��Է��̽������
% Ĭ�Ͼ���
    if nargin == 2
        tol = 1e-5;
    end

    [m, n] = size(K);
    [p, q] = size(P);

    % ��ʼ��
    x = sparse(zeros(m,1));

    % ����P��ʼ�� r0 and d
    r0 = P;
    d  = P;
    % ������
    counter = 0;            

    % ���������ֱ�ӷ���
    if sqrt(r0'*r0) < tol;
        return;
    else
        v       = K * d;
        % ���㲽��
        w       = r0' * r0 / (d' * v);
        % ���� x
        x       = x + w * d;
        % ����ʣ���
        r1      = r0 - w * v;
        counter = counter + 1;
    end

    while sqrt(r1'*r1) > tol
        P       = r1' * r1 / (r0' * r0);
        % ������������
        d       = r1 + P * d;
        r0      = r1;
        v       = K * d;
        % ���㲽��
        w       = r0' * r0 / (d' * v);
        x       = x + w * d;
        r1      = r0 - w * v;
        counter = counter + 1;
    end

    whole_displcement = x;
end