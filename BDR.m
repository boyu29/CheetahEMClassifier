function [mask] = BDR(dct_vec,dim,mu_fg,mu_bg,sigma_fg,sigma_bg,pi_fg,pi_bg,p_fg,p_bg,rows,cols,n_class)
mask = zeros(rows,cols);
k=1;
for x = 1:rows
    for y = 1:cols
        vec = dct_vec(k,:);
        k=k+1;
        if (p_fg*Prob(vec, dim, n_class, mu_fg, sigma_fg, pi_fg) > p_bg*Prob(vec, dim, n_class, mu_bg, sigma_bg, pi_bg))
            mask(x,y) = 1;
        end
    end
end
end