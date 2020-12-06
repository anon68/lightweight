function [radius] = Radius(centers, data, z)
%     R1 = size(centers,1);
%     R2 = size(data,1);
%     D = sum(data.*data,2)*ones(1,R1) + ones(R2,1)*sum(centers.*centers,2)' - 2*data*centers';
    D = pdist2(data,centers);
    mD = maxk(min(D,[],2),z); 
    radius = mD(z,:);
end