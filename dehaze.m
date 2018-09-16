function [dehazedImg, darkChannel, transmission] = dehaze(img)
% dehaze by dark channel prior
    radius = 7; % window radius
    omiga = 0.95; % dehaze weight
    [m, n, k] = size(img);
    % calculate light for image
    if k == 3 % if image is color, light is the mean value of three channels
        RGBMin = min(img, [], 3);
        light = mean(img, 3);
    else % if not, light is its first (and only) channel value
        RGBMin = img(:, :, 1);
        light = img(:, :, 1);
    end
    % calculate dark channel
    darkChannel = zeros(m, n);
    for a = 1 : m
        for b = 1 : n
            pitch = RGBMin(max(1, a-radius) : min(m, a+radius), max(1, b-radius) : min(n, b+radius));
            darkChannel(a, b) = min(pitch(:));
        end
    end
    % choose pixels with 0.1% highest value of dark channel
    sortedDarkChannel = sort(darkChannel(:), 'descend');
    threshold = sortedDarkChannel(round(0.001*m*n));
    brightestPixels = light;
    brightestPixels(darkChannel<threshold) = 0;
    % choose the largest light from these pixels as atmospheric light
    [row, col] = find(brightestPixels==max(brightestPixels(:)), 1);
    atmosphericLight = img(row, col, :);
    % calculate the transmission
    transmission = 1 - omiga*darkChannel/atmosphericLight;
    % perform guided filter on the transmission
    r = 80;
    regularization = 0.01;
    % if you don't want to use buid-in function, uncomment second line below
    transmission_filter = imguidedfilter(transmission, img, 'NeighborhoodSize',[r r], 'DegreeOfSmoothing', regularization*diff(getrangefromclass(img)).^2);
    % transmission_filter = guidedfilter(img, transmission, r, regularization);
    transmission = max(0.1, transmission_filter);
    % J = (I-A)/t+A
    dehazedImg= (img - atmosphericLight) ./ transmission + atmosphericLight;  
end
