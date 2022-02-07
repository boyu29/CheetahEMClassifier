function result = Prob(vec, dim, n_class, mu, sigma, pi)
    result = 0;
    vec = vec(:,1:dim);
    for c=1:n_class
        slideStart = 64*(c-1);
        mu_temp = mu(slideStart+1:slideStart+dim);
        sigma_temp = diag(sigma(slideStart+1:slideStart+dim));
        result = result + pi(c) * mvnpdf(vec, mu_temp, sigma_temp);
    end
end