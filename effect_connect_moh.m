function [F]=effect_connect_moh(Sig_1,Sig_2)
%variables of Toolbox
ntrials=1; % number of trials
regmode=[]; % VAR model estimation regression mode ('OLS', 'LWR' or empty for default)
icregmode=[];  % information criteria regression mode ('OLS', 'LWR' or empty for default)
morder='AIC'; % model order to use ('actual', 'AIC', 'BIC' or supplied numerical value)
momax=3;  % maximum model order for model order estimation
%momax=4,5,6 error
acmaxlags=[]; % maximum autocovariance lags (empty for automatic calculation)
tstat='F';  % statistical test for MVGC:  'F' for Granger's F-test (default) or 'chi2' for Geweke's chi2 test
alpha=0.05; % significance level for significance test
mhtc='FDR'; % significance level for significance test
fs=1;   % sample rate (Hz)
fres=[];  % frequency resolution (empty for automatic calculation)
nvars = 2; % number of variables
% Residuals covariance matrix.
SIGT = eye(nvars);
%%
%model order estimation
AIC={}; BIC={}; moAIC={}; moBIC={}; A={}; SIG={}; info={}; G={}; F={}; pval={}; sig={}; cd={};

Signal=[Sig_1 Sig_2];

if~isempty(Signal)
    sumx=single(sum(Signal(:,1)));
    zarbx=single((Signal(1,1))*(length(Signal)));
    sumxx=single(sum(Signal(:,2)));
    zarbxx=single(Signal(1,2))*(length(Signal));
    if (sumx==zarbx | sumxx==zarbxx)
        Signal={};
    end
end
if~isempty(Signal)
    
    X=Signal';
else
    X={};
end
if~isempty(Signal)
    [AIC,BIC,moAIC,moBIC] = tsdata_to_infocrit(X,momax,icregmode);
    amo = size(2,3);
    if     strcmpi(morder,'actual')
        morder = amo;
    elseif strcmpi(morder,'AIC')
        morder = moAIC;
    elseif strcmpi(morder,'BIC')
        morder = moBIC;
    else
    end
    % VAR model estimation
    [A,SIG] = tsdata_to_var(X,morder,regmode);
    assert(~isbad(A),'VAR estimation failed');
    % Autocovariance calculation
    [G,info] = var_to_autocov(A,SIG,acmaxlags);
%     var_info(G,true);
    %Granger causality calculation: time domain
    F = autocov_to_pwcgc(G);
%     assert(~isbad(F,false),'GC calculation failed');
%     pval = mvgc_pval(F,morder,nobs,ntrials,1,1,nvars-2,tstat);
%     sig = significance(pval,alpha,mhtc);
%     cd = mean(F(~isnan(F)));
end

