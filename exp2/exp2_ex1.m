% 选择任意灰度图像。计算和显示原始图像的频谱振幅和任意因子缩放的同一图像的频谱振幅。两者之间有什么区别吗，结合课本知识解释这一现象(要求同一窗口显示)？

photo_path = 'exp2/photo_gray.jpg';

photo_gray = imread(photo_path);

% 计算原始图像的频谱振幅
photo_gray_fft = fft2(photo_gray);
photo_gray_fft_shifted = fftshift(photo_gray_fft);
photo_gray_magnitude = abs(photo_gray_fft_shifted);
photo_gray_magnitude_log = log(1 + photo_gray_magnitude);

% 计算缩放因子
scale_factor = 2; % 缩放因子
photo_gray_scaled = imresize(photo_gray, scale_factor);
photo_gray_scaled_fft = fft2(photo_gray_scaled);
photo_gray_scaled_fft_shifted = fftshift(photo_gray_scaled_fft);
photo_gray_scaled_magnitude = abs(photo_gray_scaled_fft_shifted);
photo_gray_scaled_magnitude_log = log(1 + photo_gray_scaled_magnitude);

% 显示原始图像和缩放图像的图像及其频谱振幅
figure;
subplot(2, 2, 1);
imshow(photo_gray); title('原始图像');

subplot(2, 2, 2);
imshow(photo_gray_scaled); title('缩放图像');

subplot(2, 2, 3);
imshow(photo_gray_magnitude_log, []); title('原始图像频谱振幅');

subplot(2, 2, 4);
imshow(photo_gray_scaled_magnitude_log, []); title('缩放图像频谱振幅');