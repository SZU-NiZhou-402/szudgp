clc; clear;

% 读取图像
image = imread('exp3/lena_color_256.tif');

% RGB 均衡化
R = histeq(image(:,:,1));
G = histeq(image(:,:,2));
B = histeq(image(:,:,3));
normimage_rgb = cat(3, R, G, B);

% 转换到 HSV 空间
hsvimage = rgb2hsv(image);
H = hsvimage(:,:,1);
S = hsvimage(:,:,2);
V = hsvimage(:,:,3);

% V 分量均衡化
V_int = uint8(V * 255); % 转换为 0-255 范围
V_eq = histeq(V_int);
V_eq = double(V_eq) / 255; % 归一化回 0-1 范围

% 创建新的 HSV 图像并转换回 RGB
hsvimage_eq = cat(3, H, S, V_eq);
normimage_hsv = hsv2rgb(hsvimage_eq);

% 显示结果
figure;
subplot(1, 2, 1); imshow(image); title('Original Image');
subplot(1, 2, 2); imshow(normimage_rgb); title('RGB Normalized Image');

figure;
subplot(2, 2, 1); imshow(V); title('Original Brightness (V)');
subplot(2, 2, 2); imshow(H); title('Original Hue (H)');
subplot(2, 2, 3); imshow(rgb2gray(normimage_rgb)); title('RGB Normalized GrayScale'); % corrected
subplot(2, 2, 4); imshow(H); title('Hue from RGB Normalized Image'); % corrected

figure;
subplot(1, 2, 1); imshow(image); title('Original Image');
subplot(1, 2, 2); imshow(normimage_hsv); title('Brightness (V) Channel Normalized Image');

figure;
subplot(1, 2, 1); imshow(V); title('Original Brightness (V)');
subplot(1, 2, 2); imshow(V_eq); title('Normalized Brightness (V)');
