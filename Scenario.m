% Author: Shixiong Wang (s.wang@u.nus.edu)
% Department of industrial systems engineering and manegement, National University of Singapore
% Date: 20 - Jan - 2019

%% Parameters setting
NTime = 40;         % Total simulation time 
Ts = 0.1;           % Sampling time
N = NTime / Ts;     % Total time steps

R = diag([1, 1]);   % Measurement noise covariance
Q = diag([1, 0.2, 1, 0.2])*0.01; % Processing noise covariance

F = [1 Ts; 0 1];    % CV motion state transition matrix F
F = blkdiag(F, F);

%G = [Ts^2 / 2 0; 0 Ts]; % Control matrix Gamma 
%G = blkdiag(G, G);
G = eye(4);

H = [1 0 0 0;
     0 0 1 0];     % Measurement matrix H
 
matM = blkdiag([Ts^2 / 2 Ts]', [Ts^2 / 2 Ts]');          % Control matrix of UI a
matN = eye(2);                                           % Control matrix of UI b

%% Simulation data production --- Real target trajectory
X_Real = zeros(4, N);           % True state
X_Real(:, 1) = [0, 5, 0, -5]';  % Initial state

% Constant Acceleration (CA) Maneuver
CA_Start = 60;          % The begin time of CA motion
CA_End = 100;           % The end time of CA motion
CA_Value = [10, 0]';    % The value of acceleration

% Target trajectory 
for i = 2 : CA_Start - 1            % without CA
    X_Real(:, i) = F * X_Real(:, i - 1);
end

for i = CA_Start : CA_End - 1       % CA appears
    X_Real(:, i) = F * X_Real(:, i - 1) + matM * CA_Value;
end

for i = CA_End : N                  % without CA
    X_Real(:, i) = F * X_Real(:, i - 1);
end

%% Simulation data production --- Measurement
% sensor bias
A = 20;    % The bias amplitude
Bias = A * [sin(0.01*(0:N-1)); cos(0.01*(0:N-1)) ] + repmat([250;250],1,N);
% real measuremnt plus sensor bias 
Y_Measurement = H * X_Real + sqrt(R) * randn(2, N) + Bias;

%% Initial Parameter
paramInit.A = zeros(2, 1);                      % for unknown input "a"
paramInit.B = zeros(2, 1);                      % for unknown input "b"
paramInit.Cov = diag([5, 1, 5, 1])*0.5;
paramInit.State = 0;

%% Combined CA values
CA_k1 = repmat([0 0]', 1, CA_Start - 1);
CA_k2 = repmat(CA_Value, 1, CA_End - CA_Start + 1);
CA_k3 = repmat([0, 0]', 1, N - length(CA_k1) - length(CA_k2));
CA = [CA_k1, CA_k2, CA_k3];

%% Save data
save SimData X_Real Y_Measurement paramInit NTime N Ts R Q F G H matN matM CA Bias;
