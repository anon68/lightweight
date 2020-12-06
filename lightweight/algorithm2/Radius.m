function [radius] = Radius(centers, data, z)
    D = pdist2(data,centers);
    mD = maxk(min(D,[],2),z+1); 
    radius = mD(z+1,:);
end