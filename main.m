%% load data
load("TrainingSamplesDCT_8_new.mat");

pattern = dlmread("Zig-Zag Pattern.txt") + 1;

[cheetah, cheetacolorhmap] = imread("cheetah.bmp");

cheetah2 = im2double(cheetah);

cheetah2_temp = cheetah2;

cheetah2_temp(262,277) = 0;

[cheetah_mask, cheetah_mask_colormap] = imread("cheetah_mask.bmp");
cheetah_mask = im2double(cheetah_mask/255);

[rowGrass, ~] = size(TrainsampleDCT_BG);
[rowCheetah, ~] = size(TrainsampleDCT_FG);
p_bg = rowGrass / (rowCheetah + rowGrass);
p_fg = rowCheetah / (rowCheetah + rowGrass);

feature_dim = 64;

dct_vec = zeros(255*270, 64);
for i = 1 : 255
    for j = 1 : 270
        block = cheetah2_temp(i:i+7, j:j+7);
        block2vec = dct2(block);
        dct_vec(((i-1)*270+j),:) = vec2zigzag(pattern, block2vec);
    end
end

dims_lst = [1 2 4 8 16 24 32 40 48 56 64];
[~,dims_num] = size(dims_lst);
n_class = 8;
n_mix = 5;

mu_fg = zeros(n_mix, feature_dim*n_class);
sigma_fg = zeros(n_mix, feature_dim*n_class);
pi_fg = zeros(n_mix, n_class);
mu_bg = zeros(n_mix, feature_dim*n_class);
sigma_bg = zeros(n_mix, feature_dim*n_class);
pi_bg = zeros(n_mix, n_class);

%% training
fprintf('Loading completed... Starting Training.\n')

for mix = 1:n_mix
    [mu_bg(mix,:), sigma_bg(mix,:), pi_bg(mix,:)] = em(TrainsampleDCT_BG, n_class, feature_dim, 200);
    [mu_fg(mix,:), sigma_fg(mix,:), pi_fg(mix,:)] = em(TrainsampleDCT_FG, n_class, feature_dim, 200);
end

save('em_1_data.mat');
%% prediction and poe calculating

poe = zeros(n_mix*n_mix, dims_num);

for mix1 = 1:n_mix
    for mix2 = 1:n_mix
        for dim = 1:dims_num
            mix_mask = BDR(dct_vec,dims_lst(dim),...
                mu_fg(mix1,:),mu_bg(mix2,:),sigma_fg(mix1,:),sigma_bg(mix2,:),...
                pi_fg(mix1,:),pi_bg(mix2,:),p_fg,p_bg,255,270,n_class);
            poe((mix1-1)*5+mix2,dim) = Error(mix_mask,p_fg,p_bg);
        end
    end
end

%% save data
save('em1_1_finaldata.mat')

%% subplots
for i = 1:5
    figure;
    plot(dims_lst,poe((i-1)*5+1:(i-1)*5+5,:)');
    hold on
    for j = 1:5
        leg_str{j} = ['mix', num2str(5*(i-1)+j)];
    end
    legend(leg_str)
    title('PoE vs. Dimension')
    xlabel('Dimensions')
    ylabel('Probability of Error')
end
%% plot all mixture pair in one pic
plot(dims_lst,poe')
for j = 1:25       
    leg_str{j} = ['mix', num2str(j)];
end
% legend(leg_str)
title('PoE vs. Dimension')
xlabel('Dimensions')
ylabel('Probability of Error')





