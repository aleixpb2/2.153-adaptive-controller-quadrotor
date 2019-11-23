clc, clear, close all;

% Load drone parameters
quad = droneParams;

rho = 0.2;
max_states = [
    1; 1; 1;
    0.1; 0.1; 0.1;
    1; 1; 1;
    0.1; 0.1; 0.1;
    ];
max_inputs = [quad.U1_max; quad.U2_max; quad.U3_max; quad.U4_max];

Q = diag(1./max_states.^2);
R = diag(1./max_inputs.^2);
R = R.*rho;

Apbar = ;
B = ;
Abar = [Apbar ...];
[K,S,P] = lqr(Abar, B, Q, R)
