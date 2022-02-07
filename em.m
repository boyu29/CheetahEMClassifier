function [mu, sigma, pi_c] = em(dct_vec, n_class, dct_dim, num_iter)
    [n_rows, ~] = size(dct_vec);
    dct_vec_dim = dct_vec(:,1:dct_dim);

    sigma_c = diag(diag(2*rand(dct_dim*n_class,dct_dim*n_class)+2));
    mu_c = 3*rand(n_class, dct_dim)+3;
    pi_c = (randi(20, 1, n_class));
    pi_c = pi_c/sum(pi_c);
    epsilon = (1e-06)*ones(size(sigma_c));
    z = zeros(n_rows, n_class);

    for iter = 1:num_iter
        % E-step
        z_pre = z;
        for row = 1:n_rows
            p_x = zeros(1, n_class);
            for comp = 1:n_class
                slide1 = (comp-1)*dct_dim;
                slide2 = comp*dct_dim;
                sigma = sigma_c(slide1+1:slide2, slide1+1:slide2);
                mu = mu_c(comp,:);
                p_x(comp) = mvnpdf(dct_vec_dim(row,:),mu,sigma)*pi_c(comp);
            end
            z(row,:) = p_x/sum(p_x);
        end
        pi_c = sum(z,1)/n_rows;

        % M-step
        for comp = 1:n_class
            slide1 = (comp-1)*dct_dim;
            slide2 = comp*dct_dim;
            sig = (dct_vec_dim-repmat(mu_c(comp,:),n_rows,1));
            sigma = sig.*(repmat(z(:,comp),1,dct_dim));
            tot = sum(z(:,comp));
            sigma_c(slide1+1:slide2, slide1+1:slide2) = (sigma'*sig)/tot;
            mu_c(comp,:) = sum(dct_vec_dim.*repmat(z(:,comp),1,dct_dim))/tot;
        end
        sigma_c = diag(diag(sigma_c + epsilon));
        if (log(z) - log(z_pre)) < 1e-06
            break;
        end
    end
    
    % return the final params
    mu = zeros(1, dct_dim*n_class);
    for comp = 1:n_class
        mu((comp-1)*dct_dim+1:comp*dct_dim) = mu_c(comp,:);
    end
    sigma = diag(sigma_c).';
end
