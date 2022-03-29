% Online supplementary materials of the paper titled 
% "Optimal Joint Estimation and Identification Theorem to Linear Gaussian System with Unknown Inputs"
% https://github.com/Spratm-Asleaf/LJEIE
%
% Author: Shixiong Wang (s.wang@u.nus.edu)
% Department of Industrial Systems Engineering and Manegement, National University of Singapore
% Date: 20 - Jan - 2019

clc;

len_data = ResultData{1}.A_real(1,:);
N = length(len_data);

m_A_real = zeros(2,N);
m_A_est = zeros(2,N);
m_B_real = zeros(2,N);
m_B_est = zeros(2,N);

m_X_real = zeros(4,N);
m_Y_measurement = zeros(2,N);
m_X_est = zeros(4,N);

m_Time = zeros(1,N-1);

%% 100 indenpent Monte Carlo
for i = 1:100
    m_A_real = m_A_real + ResultData{i}.A_real;
    m_A_est = m_A_est + ResultData{i}.A_est;
    m_B_real = m_B_real + ResultData{i}.B_real;
    m_B_est = m_B_est + ResultData{i}.B_est;
    
    m_X_real = m_X_real + ResultData{i}.X_real;
    m_Y_measurement = m_Y_measurement + ResultData{i}.Y_measurement;
    m_X_est = m_X_est + ResultData{i}.X_est;
    
    m_Time = m_Time + ResultData{i}.Time;
end

m_A_real = m_A_real/100;
m_A_est = m_A_est/100;
m_B_real = m_B_real/100;
m_B_est = m_B_est/100;

m_X_real = m_X_real/100;
m_Y_measurement = m_Y_measurement/100;
m_X_est = m_X_est/100;

m_Time = m_Time/100;

PlotShow;