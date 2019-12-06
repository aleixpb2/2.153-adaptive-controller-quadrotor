clc, clear, close all;

np = 3*4;
m = 4;
n = np + m;  % 16

% Load drone parameters
quad = droneParams;
busInfo = Simulink.Bus.createObject(quad);

% Matrix definitions
Lambda = eye(m);  % unknown pos. def. matrix
Lambda(1,1) = 0.4;
t_failure = 12;

Ap = [
    zeros(3,3), zeros(3,3), eye(3), zeros(3,3);
    zeros(3,3), zeros(3,3), zeros(3,3), eye(3);
    zeros(3,3), [0 quad.g 0; -quad.g 0 0; 0 0 0], zeros(3,3), zeros(3,3);
    zeros(3, np)
    ];

Cp = zeros(m, np);
Cp(1,1) = 1; Cp(2,2) = 1; Cp(3,3) = 1;
Cp(4,6) = 1;

Abar = [Ap zeros(np,m); Cp zeros(m,m)];

Bp = zeros(np,m);
Bp(9,1) = 1/quad.M;
Bp(10,2) = quad.d/quad.Ix;
Bp(11,3) = quad.d/quad.Iy;
Bp(12,4) = 1/quad.Iz;
B = [Bp; zeros(m,m)];
Bc = [zeros(np,m); -eye(m)];

% Load LQR parameters. Bryson's rule:
rho = 100000;
max_pos = 100;
max_ang = 2*pi;
max_vel = 100;
max_rate = 4*pi;
max_eyI = 0.01;  % integral of tracking error
max_states = [
    max_pos; max_pos; max_pos;
    max_ang; max_ang; max_ang;
    max_vel; max_vel; max_vel;
    max_rate; max_rate; max_rate;
    max_eyI;max_eyI;max_eyI;max_eyI;
    ];
max_inputs = [quad.U1_max; quad.U2_max; quad.U3_max; quad.U4_max];

Q = diag(1./max_states.^2);
R = diag(1./max_inputs.^2);
R = R.*rho;

[K,~,~] = lqr(Abar, B, Q, R);
%K(abs(K)<1e-8) = 0;
% Slow states modification
%K(:,1) = 0;  % x terms
%K(:,2) = 0;  % y terms
Kbl = -K;

% Adaptive controller
p = m+n+1;
Gamma = eye(p)*1000;

Kx = -lqr(Abar, B, eye(n), eye(m));
Am = Abar + B*Kx;
%eigs(Am)  % has to be Hurwitz (stable)
P = lyap(Am.',eye(n));
check_minusI = Am.'*P + P*Am;  % check that this is -I
check_minusI(abs(check_minusI) < 1e-8) = 0;

