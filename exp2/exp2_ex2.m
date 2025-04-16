% 选择任意灰度图像。计算和显示原始图像的频谱振幅和任意角度旋转的同一图像的频谱振幅。两者之间有什么区别，结合课本知识解释这一现象(要求同一窗口显示)？

% 步骤
% 1.读取图像
% 2.计算原始图像的频谱振幅
% 3.计算旋转图像的频谱振幅
% 4.显示原始图像和旋转图像的图像及其频谱振幅

photo_path = 'exp2/photo_gray.jpg';

photo_gray = imread(photo_path);

% 计算原始图像的频谱振幅
photo_gray_fft = fft2(photo_gray);
photo_gray_fft_shifted = fftshift(photo_gray_fft);
photo_gray_magnitude = abs(photo_gray_fft_shifted);
photo_gray_magnitude_log = log(1 + photo_gray_magnitude);

% 顺时针旋转90度
photo_rotate = imrotate(photo_gray, -90);
photo_rotate_fft = fft2(photo_rotate);
photo_rotate_fft_shifted = fftshift(photo_rotate_fft);
photo_rotate_magnitude = abs(photo_rotate_fft_shifted);
photo_rotate_magnitude_log = log(1 + photo_rotate_magnitude);

% 显示原始图像和旋转图像的图像及其频谱振幅
figure;
subplot(2, 2, 1);
imshow(photo_gray); title('原始图像');

subplot(2, 2, 2);
imshow(photo_rotate); title('旋转图像');

subplot(2, 2, 3);
imshow(photo_gray_magnitude_log, []); title('原始图像频谱振幅');

subplot(2, 2, 4);
imshow(photo_rotate_magnitude_log, []); title('旋转图像频谱振幅');
