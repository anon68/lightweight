# lightweight

This code replicates the experiments of our paper. 

> 

**This README file describes the structure of our codes. We will introduce our implementation**. 

### 1, Platform: 

CPU: 2.40GHz Intel(R) Xeon(R) E5-2680

Ubuntu: 18.04

MATLAB: R2018b

### 2, Files & Folders

    ├─baseline
    │  ├─kcenter     
    │  ├─kmeans      
    │  └─kmedian
    │              
    ├─datasets
    │  │  data_gen.m
    │  │  data_gen_k.m
    │  │  data_gen_otl.m
    │  │  data_gen_size.m
    │          
    └─lightweight
        ├─algorithm1
        ├─algorithm2
        ├─algorithm3
        ├─algorithm4
        ├─median_algorithm3
        └─median_algorithm4



### 3, Interface & Usage

#### 3.1 algorithm1 & algorithm3

```
[centers,sampNum,k_prime,time] = algorithm1(data,k,z,varargin)
[centers,sampNum,k_prime,time] = algorithm3(data,k,z,varargin)
```

INPUT: 

**data** is n*d matrix, including n vertices with d attributes; **k** is the number of clusters; **z** is the number of outliers; 

**varargin** configure other parameters: eta, delta, ksi, e1, e2, k_prime represent the parameters η, δ, ξ, ε1, ε2, k' respectively, which will affect the value of sampling size, k_prime. 

We can also set some parameters directly:  sampNum means sampling size, k_prime means the extra centers, RPT means times of repetition, ValdnRatio means Verification set proportion. 

OUTPUT: 

**centers** are the clustering centers; **sampNum** is the sampling size; **k_prime** is the k'; **time** is the running time. 

EXAMPLE: 

```
[centers,sampNum,k_prime,timer(j)] = algorithm1(data,k,z,'sampNum',S_num,'k_prime',k_prime,'RPT',5,'ValdnRatio',0.02);
```



#### 3.2 algorithm2 & algorithm4

```
[centers,sampNum,z_prime,time] = algorithm2(data,k,z,varargin)
[centers,sampNum,z_prime,time] = algorithm4(data,k,z,varargin)
```

INPUT: 

almost the same with algorithm1&algorithm3, except that we set **z_prime**  rather than **k_prime** in varargin. **z_prime**  represents the parameter z'. 

OUTPUT: 

almost the same with algorithm1&algorithm3, except that the algorithm outputs **z_prime**  rather than **k_prime**.

EXAMPLE: 

```
[centers,sampNum,z_prime,timer(j)] = algorithm2(data,k,X.z,'sampNum',S_num,'z_prime',z_prime,'RPT',5,'ValdnRatio',0.2);
```



### 4, Details

