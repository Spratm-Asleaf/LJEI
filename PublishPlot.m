% Online supplementary materials of the paper titled 
% "Optimal Joint Estimation and Identification Theorem to Linear Gaussian System with Unknown Inputs"
% https://github.com/Spratm-Asleaf/LJEI
%
% Author: Shixiong Wang (s.wang@u.nus.edu)
% Department of Industrial Systems Engineering and Manegement, National University of Singapore
% Date: 20 - Jan - 2019

%% Formal Plots for Publication

clear all;
close all;
clc;

isRunningTimeCompare = 0;

if ~isRunningTimeCompare
    load('SimResult 200-5-40-0.1.mat');
    
    pltTime = (0:N-1)*Ts;
    
    % The Model Error
    figure;
    plot(pltTime, CA(1,:),'r--', pltTime, CA(2,:),'b','linewidth',2);
    axis([0 NTime -1 12]);
    legend('Acceleration in X axis (m/s^2)','Acceleration in Y axis (m/s^2)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Acceleration (m/s^2)','fontsize',14);
    set(gca,'fontsize',14);

    %% The Measure Error
    figure;
    plot(pltTime, Bias(1,:),'r', pltTime, Bias(2,:),'b--','linewidth',2);
    axis([0 NTime 150 300]);
    legend('Sensor Bias in X axis (m)','Sensor Bias in Y axis (m)');
    hold on;plot(pltTime,250*ones(1,length(pltTime)),'g-.','linewidth',1);
    xlabel('Time (s)','fontsize',14);
    ylabel('Sensor Bias (m)','fontsize',14);
    set(gca,'fontsize',14);

    %% The Measure and Real
    figure;
    plot(pltTime, X_Real(1,:),'r--', pltTime, Y_Mear(1,:),'g','linewidth',2);
    legend('Real Position in X (m)','Measure in X (m)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Displacement (m)','fontsize',14);
    set(gca,'fontsize',14);

    figure;
    plot(pltTime, X_Real(3,:),'r--', pltTime, Y_Mear(2,:),'g','linewidth',2);
    legend('Real Position in Y (m)','Measure in Y (m)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Displacement (m)','fontsize',14);
    set(gca,'fontsize',14);

    %% True and Estimated State? Position
    figure;
    plot(pltTime,m_X_real(1,:),'r--',pltTime,m_X_est(1,:),'b',pltTime,m_Y_mear(1,:),'g-.','linewidth',2);
    axis([0 40.1 0 2000]);
    legend('Real Position in X (m)','Estimated Position in X (m)','Measure in X (m)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Displacement (m)','fontsize',14);
    set(gca,'fontsize',14);

    figure;
    plot(pltTime,m_X_real(1,:)-m_X_est(1,:),'r','linewidth',2);
    axis([0 40.1 -300 300]);
    xlabel('Time (s)','fontsize',14);
    ylabel('Position Estimated Error in X (m)','fontsize',14);
    set(gca,'fontsize',14);

    figure;
    plot(pltTime,m_X_real(3,:),'r--',pltTime,m_X_est(3,:),'b',pltTime,m_Y_mear(2,:),'g-.','linewidth',2);
    axis([0 40.1 -300 300]);
    legend('Real Position in Y (m)','Estimated Position in Y (m)','Measure in Y (m)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Displacement (m)','fontsize',14);
    set(gca,'fontsize',14);

    figure;
    plot(pltTime,m_X_real(3,:)-m_X_est(3,:),'r','linewidth',2);
    axis([0 40.1 -300 300]);
    xlabel('Time (s)','fontsize',14);
    ylabel('Position Estimated Error in Y (m)','fontsize',14);
    set(gca,'fontsize',14);

    %% True and Estimated State? Velocity
    figure;
    plot(pltTime,m_X_real(2,:),'r--',pltTime,m_X_est(2,:),'b','linewidth',2);
    axis([0 40.1 -10 50]);
    legend('Real Velocity in X (m/s)','Estimated Velocity in X (m/s)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Velocity (m/s)','fontsize',14);
    set(gca,'fontsize',14);

    figure;
    plot(pltTime,m_X_real(2,:)-m_X_est(2,:),'r','linewidth',2);
    axis([0 40.1 -20 20]);
    xlabel('Time (s)','fontsize',14);
    ylabel('Velocity Estimated Error in X (m/s)','fontsize',14);
    set(gca,'fontsize',14);

    figure;
    plot(pltTime,m_X_real(4,:),'r--',pltTime,m_X_est(4,:),'b','linewidth',2);
    axis([0 40.1 -40 30]);
    legend('Real Velocity in Y (m/s)','Estimated Velocity in Y (m/s)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Velocity (m/s)','fontsize',14);
    set(gca,'fontsize',14);

    figure;
    plot(pltTime,m_X_real(4,:)-m_X_est(4,:),'r','linewidth',2);
    axis([0 40.1 -20 20]);
    xlabel('Time (s)','fontsize',14);
    ylabel('Velocity Estimated Error in Y (m/s)','fontsize',14);
    set(gca,'fontsize',14);

    %% Running Time
    figure;
    plot(pltTime(1:end-1), m_Time(1,:),'b','linewidth',2,'markersize',0.5);
    hold on;
    plot(pltTime(1:end-1), Ts*ones(1,length(pltTime) - 1),'r--','linewidth',2);
    axis([0 pltTime(end)+1 0 Ts + 0.1]);
    legend('Running Time in Each Step (s)', 'Time Interval of Each Step (s)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Running Time (s)','fontsize',14);
    set(gca,'fontsize',14);

    %% The Estimated A
    figure;
    plot(pltTime,m_A_est(1,:),'b',pltTime,CA(1,:),'r--','linewidth',2);
    axis([0 NTime -1 12]);
    legend('Estimated Acceleration in X (m/s^2)','Real Acceleration in X (m/s^2)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Acceleration (m/s^2)','fontsize',14);
    set(gca,'fontsize',14);

    figure;
    plot(pltTime,m_A_est(2,:),'b',pltTime,CA(2,:),'r--','linewidth',2);
    axis([0 NTime -1 12]);
    legend('Estimated Acceleration in Y (m/s^2)','Real Acceleration in Y (m/s^2)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Acceleration (m/s^2)','fontsize',14);
    set(gca,'fontsize',14);

    %% The Estimated B
    figure;
    plot(pltTime,m_B_est(1,:),'b',pltTime,Bias(1,:),'r--','linewidth',2);
    legend('Estimated Sensor Bias in X (m)','Real Sensor Bias in X (m)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Sensor Bias (m)','fontsize',14);
    set(gca,'fontsize',14);

    figure;
    plot(pltTime,m_B_est(2,:),'b',pltTime,Bias(2,:),'r--','linewidth',2);
    legend('Estimated Sensor Bias in Y (m)','Real Sensor Bias in Y (m)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Sensor Bias (m)','fontsize',14);
    set(gca,'fontsize',14);
else
    isDifferentIterMax = 0;
    if ~isDifferentIterMax
        load('SimResult 200-1-40-0.1.mat');
        Data1 = m_Time;

        load('SimResult 200-3-40-0.1.mat');
        Data3 = m_Time;

        load('SimResult 200-5-40-0.1.mat');
        Data5 = m_Time;

        pltTime = (0:N-1)*Ts;

        figure;
        plot(pltTime(1:end-1), Data1(1,:),'m',pltTime(1:end-1), Data3(1,:),'b',pltTime(1:end-1), Data5(1,:),'g','linewidth',2);
        hold on;
        plot(pltTime(1:end-1), Ts*ones(1,length(pltTime) - 1),'r--','linewidth',2);
        axis([0 pltTime(end)+1 0 Ts + 0.1]);
        legend('Window Length l = 1', 'Window Length l = 3', 'Window Length l = 5', 'Ts');
        xlabel('Time (s)','fontsize',14);
        ylabel('Running Time (s)','fontsize',14);
        set(gca,'fontsize',14);
    else
        load('RunningTime 25-5.mat');
        Data25 = RunningTime;

        load('RunningTime 45-5.mat');
        Data45 = RunningTime;

        load('RunningTime 100-5.mat');
        Data100 = RunningTime;

        N = 400;
        Ts = 0.1;
        pltTime = (0:N-1)*Ts;

        figure;
        plot(pltTime(1:end-1), Data25(1,:),'m',pltTime(1:end-1), Data45(1,:),'b',pltTime(1:end-1), Data100(1,:),'g','linewidth',2);
        hold on;
        plot(pltTime(1:end-1), Ts*ones(1,length(pltTime) - 1),'r--','linewidth',2);
        axis([0 pltTime(end)+1 0 Ts + 0.1]);
        legend('Max Iteration = 25', 'Max Iteration = 45', 'Max Iteration = 100', 'Ts');
        xlabel('Time (s)','fontsize',14);
        ylabel('Running Time(s)','fontsize',14);
        set(gca,'fontsize',14);
    end
end
