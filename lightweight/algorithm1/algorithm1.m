function [centers,sampNum,k_prime,time] = algorithm1(data,k,z,varargin)
%function [centers,sampNum,k_prime,time] =  algorithm1(data,k,z,varargin)
%data is n*d matrix�� including n vertexs with d attributes
%input k is the number of clusters. z is the number of outliers
%varargin configure other parameters:
%eta, delta, ksi, e1, e2, k_prime are the parameters ��, ��, ��, ��1, ��2, k'
tic
n_data = size(data,1);
p = inputParser;
%set defaults
defaulteta = 0.1; defaultdelta = 0.2; defaultksi = 0.2;
defaulte1 = 0.2; defaulte2 = 0.2; defaultsampNum = 1000;
defaultk_prime = 100; defaultRPT = 10; defaultValdnRatio = 0.1;
%check and parse the input
p.addRequired('data',@(x)validateattributes(x,{'numeric'},...
    {}));
p.addRequired('k',@(x)validateattributes(x,{'numeric'},...
    {'nonzero'}));
p.addParameter('eta',defaulteta,...
    @(x)validateattributes(x,{'numeric'},{'>',0,'<',1}));
p.addParameter('delta',defaultdelta,...
    @(x)validateattributes(x,{'numeric'},{'>',0,'<',1}));
p.addParameter('ksi',defaultksi,...
    @(x)validateattributes(x,{'numeric'},{'>',0,'<',1}));
p.addParameter('e1',defaulte1,...
    @(x)validateattributes(x,{'numeric'},{'>',0,'<',1}));
p.addParameter('e2',defaulte2,...
    @(x)validateattributes(x,{'numeric'},{'>',0,'<',1}));
%set some parameters directly
%sampNum means sampling size, k_prime means the extra centers, 
%RPT means times of repetition, ValdnRatio means Verification set proportion
p.addParameter('sampNum',defaultsampNum,...
    @(x)validateattributes(x,{'numeric'},{'>',0,'<=',n_data}));
p.addParameter('k_prime',defaultk_prime,...
    @(x)validateattributes(x,{'numeric'},{'>=',0,'<=',n_data,'integer'}));
p.addParameter('RPT',defaultRPT,...
    @(x)validateattributes(x,{'numeric'},{'>',0,'integer'}));
p.addParameter('ValdnRatio',defaultValdnRatio,...
    @(x)validateattributes(x,{'numeric'},{'>=',0,'<=',1}));
p.parse(data,k,varargin{:});
RPT = p.Results.RPT;

modeA = {'eta','delta','ksi','e1','e2'};
modeB = {'sampNum'};
modeC = {'k_prime'};
if sum(ismember(modeA,p.Parameters)) == 5
    eta = p.Results.eta; delta = p.Results.delta;
    ksi = p.Results.ksi; e1 = p.Results.e1; e2 = p.Results.e2;
    s(1) = 3*k/(delta *delta*e1)*log(2*k/eta);
    s(2) = k/(2*ksi*ksi*e1*(1-delta))*log(2*k/eta);%set beta=1,2,3,4
    sampNum = round(max(s));
    sampNum = min([10000, sampNum, n_data]);
    k_prime = round(1/eta*e2/k*sampNum);
end
if ismember(modeB,p.Parameters) == 1
    sampNum = p.Results.sampNum;
end
if ismember(modeC,p.Parameters) == 1
    k_prime = p.Results.k_prime;
end
if ismember('ValdnRatio',p.Parameters) == 1
    ValdnRatio = p.Results.ValdnRatio;
end
rpt_cost_min = inf;
rpt_cost = zeros(1, RPT);
ValdnSet = data(randperm(n_data,round(n_data * ValdnRatio)),:);
for i = 1:RPT
    %algorithm1
    if k+k_prime > sampNum
        fprintf('k+k_prime is larger than S_num, we set S_num= 2*(k+k_prime)!!\n');
        sampNum = 2*(k+k_prime);
    end
    S = data(randperm(n_data,sampNum),:);%random sampling
    [centers_t] = Gonzalez(S,k+k_prime);
    %
    if RPT>1
        rpt_cost(i) = Radius(centers_t,ValdnSet,round(z*ValdnRatio));
        if rpt_cost(i) < rpt_cost_min %update
            rpt_centers_best = centers_t;
            rpt_cost_min = rpt_cost(i);
        end
    end
end
if RPT>1
    centers = rpt_centers_best;
else
    centers = centers_t;
end
time = toc;

%calculating the sum distance needs O(knd), more than sub-linear
%running time, you can running without the next statement and only return
%the centers
%Sum_dis = Sum_distance(centers,data,z_prime);
end