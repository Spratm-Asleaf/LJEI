% Online supplementary materials of the paper titled 
% "Optimal Joint Estimation and Identification Theorem to Linear Gaussian System with Unknown Inputs"
% https://github.com/Spratm-Asleaf/LJEI
%
% Author: Shixiong Wang (s.wang@u.nus.edu)
% Department of Industrial Systems Engineering and Manegement, National University of Singapore
% Date: 20 - Jan - 2019

clear all;
close all;
clc;

warning('Have you read the note here?');
%% Very Important Note
% In the function "EM_MStep", Line 29 and Line 46:
%       (Line 29) EMParam.A = pinv(matM'*invGQG*matM) * matM' * invGQG * matSumA / nSize;
%       (Line 46) EMParam.B = pinv(matN'*R^-1*matN) * matN' * R^-1 * matSumB / nSize;
% Is the average method really a good strategy? I do not think so!
% It seems the average method is too dull to track the quick change patterns of unknown inputs.
% Please try other strategies to obtain better performance.
disp('After reading, press any key to continue...');
pause;
disp('Ok, let''s go! Please wait.');

%% Load Scenario Data
NumOfMonteCarlo = 100;                  % How many monte carlo episodes?
ResultData = cell(1,NumOfMonteCarlo);
isIndependentMonteCarlo = false;        % Do you want to conduct independent Monte Carlo trial?

while NumOfMonteCarlo > 0
    %% Each Trial/Episode Starts
    
    % Load simulation data (n.b., all states, inputs, measurements are known therefrom)
    Scenario;                          

    DataMeasurement = Y_Measurement;    % System measurements (i.e., Y)

    %% ---------- Main Processing ---------
    nIterMax = 45;                      % Number of EM iterations
    L_Win = 3;                          % Window length, typical values are 3, 5 and 7

    % Assign Memories to Key Variables
    X_est = zeros(4, N);                % System state "x", to be estimated
    P_est = zeros(4, 4, N);             % State estimation error covariance "P"
    A_est = zeros(2, N);                % Unknown input "a", to be estimated
    B_est = zeros(2, N);                % Unknown input "b", to be estimated

    % Load Initializations
    X_est(:, 1) = paramInit.State;                
    P_est(:, :, 1) = paramInit.Cov;               
    A_est(:, 1) = paramInit.A;                    
    B_est(:, 1) = paramInit.B;                    

    RunningTime = [];
    for iTime = 2 : N                   % State estimation starts
        tStart = tic;

        % Measurement collection
        if iTime + L_Win - 1 > N
           L_Win = N + 1 - iTime;
        end
        MeasurementSet = DataMeasurement(:, iTime : iTime + L_Win - 1);   % Window processing measurement

        %% Local EM
        EMParam.State = X_est(:, iTime - 1);                   
        EMParam.PCov = P_est(:, :, iTime - 1);                 
        EMParam.A = repmat(A_est(:, iTime - 1), 1, L_Win); 
        EMParam.B = repmat(B_est(:, iTime - 1), 1, L_Win);

        for iIter = 1 : nIterMax
            % E-Step : estimate the target state via kalman smoothing
            EStepRes = EM_EStep(MeasurementSet, EMParam, F, G, H, Q, R, matM, matN);
            % M-Step : Update the parameters of UI a and b
            EMParam = EM_MStep(MeasurementSet, EStepRes, EMParam, F, G, H, Q, R, matM, matN);    
        end

        tEnd = toc(tStart); % how long the algorithm runs

        RunningTime = [RunningTime tEnd];

        EMParam.State = EStepRes.State(:, end);
        EMParam.PCov = EStepRes.PCov(:, :, end);

        X_est(:, iTime : iTime + L_Win - 1) = EStepRes.State;

        P_est(:, :, iTime : iTime + L_Win - 1) = EStepRes.PCov;

        A_est(:, iTime : iTime + L_Win - 1) = EMParam.A;        % (est)imated "a"
        B_est(:, iTime : iTime + L_Win - 1) = EMParam.B;        % (est)imated "b"
    end
    
    %% Save the data
    Results.A_real = CA;
    Results.A_est = A_est;
    Results.B_real = Bias;
    Results.B_est = B_est;
    
    Results.X_real = X_Real;
    Results.Y_measurement = Y_Measurement;
    Results.X_est = X_est;
    
    Results.Time = RunningTime;
    
    ResultData{100 - NumOfMonteCarlo + 1} = Results;
    
    %% Next Monte Carlo Episode
    NumOfMonteCarlo = NumOfMonteCarlo - 1;
    
    %% Break
    if ~isIndependentMonteCarlo
        break;
    else
        disp(['Current Loop: ' num2str(NumOfMonteCarlo)]);
    end
end

%% Let's plot
if isIndependentMonteCarlo
    MainPlot;
else
    %% Normal Plots
    PlotShow;
    
    %% Exponential Smoothing to A_est
    rawData = A_est(1,:);
    alpha=0.07;
    Smoothed_A = zeros(1,length(rawData));
    for i=2:length(rawData)
        Smoothed_A(i)=alpha*rawData(i-1)+(1-alpha)*Smoothed_A(i-1);
    end

    rawData = A_est(2,:);
    alpha=0.07;
    Smoothed_B = zeros(1,length(rawData));
    for i=2:length(rawData)
        Smoothed_B(i)=alpha*rawData(i-1)+(1-alpha)*Smoothed_B(i-1);
    end
    
    % Time Scale
    pltTime = (0:N-1)*Ts;

    figure;
    plot(pltTime,Smoothed_A,'b',pltTime,CA(1,:),'r--','linewidth',2);
    axis([0 NTime -1 12]);
    legend('Estimated Acceleration in X (m/s^2): Smoothed','Real Acceleration in X (m/s^2)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Acceleration (m/s^2)','fontsize',14);
    set(gca,'fontsize',14);

    figure;
    plot(pltTime,Smoothed_B,'b',pltTime,CA(2,:),'r--','linewidth',2);
    axis([0 NTime -1 12]);
    legend('Estimated Acceleration in Y (m/s^2): Smoothed','Real Acceleration in Y (m/s^2)');
    xlabel('Time (s)','fontsize',14);
    ylabel('Acceleration (m/s^2)','fontsize',14);
    set(gca,'fontsize',14);
end
