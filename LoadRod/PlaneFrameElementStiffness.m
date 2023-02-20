function y = PlaneFrameElementStiffness(E,area,L)
%PlaneFrameElementStiffness This function returns the element
% stiffness matrix for a plane frame
% element with modulus of elasticity E,
% cross-sectional area A, moment of
% inertia I, length L, and angle
% theta (in degrees).
% The size of the element stiffness
% matrix is 6 x 6.

% C = cos(theta);
% 
% w1 = area*C*C;

%%这个需要检验一下   
y = E*area/L*[1 0;0 1];

end