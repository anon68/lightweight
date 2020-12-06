function [purity]=kc_eval(true_label,pred_label,z)%true_label,pred_label
%% true_label: the true labels of data
%% pred_label: the labels obtained by clustering algorithm.
% true_label = [1,1,1,1,1,1,1,1,1,2,1,1,1,1,2];%class labels
% pred_label = [1,1,2,1,1,1,1,1,2,1,2,1,2,1,1];%cluster labels
% pred_label = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];%cluster labels
% true_label = [1,1,1,1,1,1,1,1,2,2,2,2,2,3,3,3,3];%class labels
% pred_label = [1,1,1,1,1,2,3,3,2,2,2,2,1,2,3,3,3];%cluster labels
%% function [NMI, RI, F] = compute_clutering_metric(idx, item_ids)
N = length(true_label);
%% cluster centers
class_label = unique(true_label);
num_classes = numel(class_label);
class_values = 1:num_classes;
class_map = containers.Map(class_label, class_values);
%fprintf('Number of centers: %d\n', num_classes);
%% count the number of objects in each class 
class_count = zeros(1, num_classes);
for i = 1:num_classes
    class_count(i) = numel(find(true_label == class_label(i)));
end
%% build a mapping from pred_label to item index
cluster_label = unique(pred_label);
num_clusters = numel(cluster_label);
cluster_values = 1:num_clusters;
cluster_map = containers.Map(cluster_label, cluster_values);
%% count the number of objects in each cluster 1:value 
cluster_count = zeros(1, num_clusters);
for i = 1:N
    index = cluster_map(pred_label(i));
    cluster_count(index) = cluster_count(index) + 1;
end
%% compute purity v2 
purity = 0;
for i = 1:num_clusters
    member = find(pred_label == cluster_label(i));
    member_ids = true_label(member); 
    count = zeros(1, num_classes);
    for j = 1:numel(member) 
        index = class_map(member_ids(j));
        count(index) = count(index) + 1;
    end
    purity = purity + max(count);
end
purity = purity / (N-z);

end