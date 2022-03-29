function EMParam = EM_MStep(MearSet, EStepRes, EMParamLast, F, G, H, Q, R, matM, matN)
% Online supplementary materials of the paper titled 
% "Optimal Joint Estimation and Identification Theorem to Linear Gaussian System with Unknown Inputs"
% https://github.com/Spratm-Asleaf/LJEI
%
% Author: Shixiong Wang (s.wang@u.nus.edu)
% Department of Industrial Systems Engineering and Manegement, National University of Singapore
% Date: 20 - Jan - 2019

    %% intial values of states and their cov
    EMParam.State = EMParamLast.State;
    EMParam.PCov = EMParamLast.PCov;

    nSize = size(MearSet, 2);

    %% UI A
    EMParam.A = zeros(2, 1);
    matSumA = zeros(4, 1);
    for i = 1 :nSize
        if i == 1
            matSumA = (EStepRes.State(:, i) - F * EMParam.State);
        else
            matSumA = matSumA + (EStepRes.State(:, i) - F * EStepRes.State(:, i - 1));
        end
    end

    invGQG = pinv(G*Q*G');

    EMParam.A = pinv(matM'*invGQG*matM) * matM' * invGQG * matSumA / nSize;

    % Remove the small value
    [indexA, ~] = find(abs(EMParam.A) < 1e-4);
    if ~isempty(indexA)
        EMParam.A(indexA) = 0;
    end

    EMParam.A = repmat(EMParam.A, 1, nSize);

    %% UI B
    EMParam.B = zeros(2, nSize);
    matSumB = zeros(2, 1);
    for i = 1 : nSize
        matSumB = matSumB + (MearSet(:, i) - H * EStepRes.State(:, i));
    end

    EMParam.B = pinv(matN'*R^-1*matN) * matN' * R^-1 * matSumB / nSize;

    [indexA, ~] = find(abs(EMParam.B) < 1e-4);
    if ~isempty(indexA)
        EMParam.B(indexA) = 0;
    end

    EMParam.B = repmat(EMParam.B, 1, nSize);

end
