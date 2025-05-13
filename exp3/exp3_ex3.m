clc; clear;
image = rgb2gray(imread('exp3/x-ray.jpg'));
[h, w] = size(image);
colorimage = zeros(h, w, 3);

color_indices = discretize(double(image), [0, 63, 127, 191, 256]);

colors = [
    0, 0, 255;      % Blue
    128, 0, 128;    % Purple
    0, 255, 0;      % Green
    255, 0, 0       % Red
];

for i = 1:h
    for j = 1:w
        colorimage(i, j, :) = colors(color_indices(i, j), :);
    end
end

subplot(121); imshow(image); title('Original Image');
subplot(122); imshow(uint8(colorimage)); title('False Color Image');