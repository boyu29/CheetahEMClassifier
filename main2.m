%% Load data and define parameters. 
load('em1_1_finaldata.mat'); % MATLAB data array that contains information already loaded in the first section of em_main.

dims_lst = [1 2 4 8 16 24 32 40 48 56 64]; % Desired dimensions.
[~,dims] = size(dims_lst);
classes = [1 2 4 8 16 32];
n_classes = size(classes,2);
poe2 = zeros(n_classes,dims);

%% EM model training and prediction.
for class = 1:n_classes

   mix_mask2 = zeros(255,270);
   [mu_fg_c,sigma_fg_c,pi_fg_c] = em(TrainsampleDCT_FG,classes(class),M,200);
   [mu_bg_c,sigma_bg_c,pi_bg_c] = em(TrainsampleDCT_BG,classes(class),M,200);
   for dim = 1:dims

       mix_mask2 = BDR(dct_vec,dims_lst(dim),mu_fg_c,mu_bg_c,sigma_fg_c,sigma_bg_c,...
           pi_fg_c,pi_bg_c,p_fg,p_bg,255,270,classes(class));
       poe2(class,dim) = Error(mix_mask2,p_fg,p_bg);
   end
end

%% plot poe vs dimensions

plot(dims_lst,poe2');
legend('C=1','C=2','C=4','C=8','C=16','C=32') %1 2 4 8 16 32
title('PoE vs. Dimension')
xlabel('Dimensions')
ylabel('Probability of Error')










