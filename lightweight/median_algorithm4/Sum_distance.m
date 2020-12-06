function [sum_dis] = Sum_distance(centers, data, z)
% calculate the k-means objective value sum distance with z outliers. 
    D = pdist2(data,centers,'euclidean');
    dis = min(D,[],2);
    [~,index] = maxk(dis,z); 
    dis(index,:) = [];
    sum_dis = sum(dis);
end
