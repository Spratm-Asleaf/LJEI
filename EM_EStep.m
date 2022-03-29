function EStepRes = EM_EStep(MearSet, EMParam, F, G, H, Q, R, matM, matN)
% Online supplementary materials of the paper titled 
% "Optimal Joint Estimation and Identification Theorem to Linear Gaussian System with Unknown Inputs"
% https://github.com/Spratm-Asleaf/LJEI
%
% Author: Shixiong Wang (s.wang@u.nus.edu)
% Department of Industrial Systems Engineering and Manegement, National University of Singapore
% Date: 20 - Jan - 2019

    NStep = size(MearSet, 2);      % Window length
    State = EMParam.State;         % init state
    PCov = EMParam.PCov;           % init cov

    XFor = zeros(4, NStep);        % forward smoother
    PFor = zeros(4, 4, NStep);     % cov of forward smoother
    PPreCov = zeros(4, 4, NStep);  % state prediction cov
    XFus = zeros(4, NStep);        % backward smoother
    PFus = zeros(4, 4, NStep);     % cov of backward smoother
    A = zeros(4, 4, NStep);        % cov of smoother

    for i = 1 : NStep
        %% forward smoother
        XPre = F * State + matM * EMParam.A(:,i);
        PPre = F * PCov * F' + G * Q * G';
        MearPre = H * XPre;

        Inv = MearSet(:, i) - MearPre - matN * EMParam.B(:, i);
        SCov = H * PPre *  H' + R;
        KGain = PPre *  H' * inv(SCov);
        XFor(:, i) = XPre + KGain * Inv;
        PFor(:, :, i) = PPre - KGain * SCov * KGain';
        PForPre = F * PFor(:, :, i) * F' + G * Q * G';
        A(:, :, i) = PFor(:, :, i) * F' * inv(PForPre);

        State = XFor(:, i);
        PCov = PFor(:, :, i);
        PPreCov(:, :, i) = PPre;
    end

    % backward smoother
    XFus = XFor;
    PFus = PFor;
    for i = NStep - 1 : -1 : 1
        XFus(:, i) = XFus(:, i) + A(:, :, i) * (XFus(:, i + 1) - F * XFus(:, i));
        PForPre = F * PFor(:, :, i) * F' + G * Q * G';
        PFus(:, :, i) = PFor(:, :, i) + A(:, :, i) * (PFus(:, :, i + 1) - PForPre) * A(:, :, i)';
    end

    %% reture the parameters of E of EM
    EStepRes.State = XFus;
    EStepRes.PCov = PFus;
end
