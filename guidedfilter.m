function filteredImg = guidedfilter(img, p, raduis, regularization)
    kernel = ones(raduis)/(raduis*raduis);
    N = imfilter(ones(size(img)), kernel);
    mean_I = imfilter(img, kernel)./N;
    mean_p = imfilter(p, kernel)./N;
    mean_Ip = imfilter(img.*p, kernel)./N;
    cov_Ip = mean_Ip - mean_I .* mean_p; 
    mean_II = imfilter(img.*img, kernel)./N;
    var_I = mean_II - mean_I .* mean_I;
    a = cov_Ip ./ (var_I + regularization); 
    b = mean_p - a .* mean_I; 
    mean_a = imfilter(a, kernel)./N;
    mean_b = imfilter(b, kernel)./N;
    filteredImg = mean_a .* img + mean_b; 
end
