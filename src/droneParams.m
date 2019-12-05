function quad = droneParams
% Dynamic parameters for a quadrotor. Modified from a file on the
% Robotics Toolbox for MATLAB (RTB) specifically for this project
%
% Creates the workspace variable quad which
% describes the dynamic characterstics of a quadrotor flying robot.
%
% Properties::
%
% This is a structure with the following elements:
%
% nrotors   Number of rotors (1x1)
% J         Flyer rotational inertia matrix (3x3)
% h         Height of rotors above CoG (1x1)
% d         Length of flyer arms (1x1)
% nb        Number of blades per rotor (1x1)
% r         Rotor radius (1x1)
% c         Blade chord (1x1)
% e         Flapping hinge offset (1x1)
% Mb        Rotor blade mass (1x1)
% Mc        Estimated hub clamp mass (1x1)
% ec        Blade root clamp displacement (1x1)
% Ib        Rotor blade rotational inertia (1x1)
% Ic        Estimated root clamp inertia (1x1)
% mb        Static blade moment (1x1)
% Ir        Total rotor inertia (1x1)
% Ct        Non-dim. thrust coefficient (1x1)
% Cq        Non-dim. torque coefficient (1x1)
% sigma     Rotor solidity ratio (1x1)
% thetat    Blade tip angle (1x1)
% theta0    Blade root angle (1x1)
% theta1    Blade twist angle (1x1)
% theta75   3/4 blade angle (1x1)
% thetai    Blade ideal root approximation (1x1)
% a         Lift slope gradient (1x1)
% A         Rotor disc area (1x1)
% gamma     Lock number (1x1)
%
%
% Notes::
% - SI units are used.
%
% References::
% - Design, Construction and Control of a Large Quadrotor micro air vehicle.
%   P.Pounds, PhD thesis, 
%   Australian National University, 2007.
%   http://www.eng.yale.edu/pep5/P_Pounds_Thesis_2008.pdf
% - This is a heavy lift quadrotor

% MODEL: quadrotor

% Copyright (C) 1993-2015, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

%--------------------
% Update:
% date: 2019/11/10
% editor: Aleix Paris

% Update:
% date: 2015/08/23
% editor: Fabian Riether
% comment: This updated version now contains parameters for Peter Corke's
% Robotics Toolbox that match Parrot's Rolling Spider, parameters for
% the EducationalDroneToolbox are appended
%--------------------

quad.nrotors = 4;                %   4 rotors
quad.g = 9.81;                   %   g       Gravity                             1x1
quad.rho = 1.184;                %   rho     Density of air                      1x1
quad.muv = 1.5e-5;               %   muv     Viscosity of air                    1x1

% Airframe                 
quad.M = 0.5;                    %   M       Mass                                1x1

% Ixx,yy,zz                     Flyer rotational inertia matrix     3x3
% Mambo
%quad.J = [0.0000582857 0.0000716914 0.0001];
quad.Ix = 0.03;
quad.Iy = quad.Ix;
quad.Iz = 0.16;

quad.d = 0.0624;                %   d       Length of flyer arms                1x1

%Rotor
quad.nb = 2;                    %   b       Number of blades per rotor          1x1
quad.r = 33/1000;               %   r       Rotor radius                        1x1

quad.Mb = 0.0015/4;             %   Mb      Rotor blade mass                    1x1
quad.Mc = 0;                    %   Mc      Estimated hub clamp mass            1x1
quad.ec = 0;                    %   ec      Blade root clamp displacement       1x1
quad.Ib = quad.Mb*(quad.r-quad.ec)^2/4 ;        %   Ib      Rotor blade rotational inertia      1x1
quad.Ic = quad.Mc*(quad.ec)^2/4;                %   Ic      Estimated root clamp inertia        1x1
quad.mb = quad.g*(quad.Mc*quad.ec/2+quad.Mb*quad.r/2);    %   mb      Static blade moment                 1x1
quad.Ir = quad.nb*(quad.Ib+quad.Ic);            %   Ir      Total rotor inertia                 1x1

% Aerodynamic constants
quad.Axyz   = [0.10 0.10 0.20];

% Added by Aleix Paris, input limits, from a real experiment with a thrust stand
% DJI Snail Racing Propulsion System motor with a DJI Snail 5048 Tri-blade Propeller
quad.omegar = 764;  % rad/s
quad.ct   = 2.1099e-6;
quad.ctau = 2.6806e-8;
quad.omegar_max = 2054.92;  % rad/s
quad.ti_max = quad.ct*quad.omegar_max^2;  % maximum thrust per rotor (ct*w_max^2), N
quad.taui_max = 0.1105;  % maximum torque per rotor (ctau*w_max^2), N*m
quad.U1_max = quad.nrotors*quad.ti_max;  % max collective force
quad.U2_max = quad.nrotors/2*quad.ti_max;  %  maximum roll force, force of half the rotors with max force and the other half stopped
quad.U3_max = quad.U2_max;  % maximum pitch force
quad.U4_max = quad.nrotors*quad.taui_max;  % maximum yaw TORQUE, not force
