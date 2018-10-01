%% compare the performance
data=rand(1e8,1); 
%%
fprintf('comparing the performance for a 10^{%.1f} long vector\n',log10(numel(data)))
min_val=0.5;
max_val=0.51;
tic; 
mask=data<max_val & data>min_val; %the brute way
count_brute=sum(mask);
time_brute=toc;
subdata1=data(mask);
subdata1=sort(subdata1); 

data=sort(data);

fprintf('time for brute mask = %.2fms\n',time_brute*1e3)

tic;
mask_idx=fast_sorted_mask(data,min_val,max_val);
count_search=mask_idx(2)-mask_idx(1)+1;
time_search=toc;
subdata2=data(mask_idx(1):mask_idx(2)); 

fprintf('time for fast_sorted_mask = %.2fms\n',time_search*1e3)
LogicalStr = {'no', 'yes'};
fprintf('are the results equal? %s \n',LogicalStr{isequal(subdata1,subdata2)+1})

