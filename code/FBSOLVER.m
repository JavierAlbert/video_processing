function [F B] = FBSOLVER(covF, covB, barF, barB, cUN, gamma)

SIGMA_C = 8; 
SIGMA_C_SQ = SIGMA_C * SIGMA_C;
f_inv = inv(covF);
b_inv = inv(covB);
A_ul = f_inv + (eye(3)*gamma*gamma)/(SIGMA_C_SQ);
A_ur = (eye(3)*gamma*(1-gamma))/(SIGMA_C_SQ);
A_ll = (eye(3)*gamma*(1-gamma))/(SIGMA_C_SQ);
A_lr = b_inv + (eye(3)*(1-gamma)*(1-gamma))/ (SIGMA_C_SQ);
A = [A_ul A_ur; A_ll A_lr];
b_u = (f_inv*barF') + (cUN*gamma)/(SIGMA_C_SQ);
b_l = (b_inv*barB') + (cUN*(1-gamma))/(SIGMA_C_SQ);
b = [b_u; b_l];

x = A\b;
F = x(1:3);
B = x(4:6);
end

