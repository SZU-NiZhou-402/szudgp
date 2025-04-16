% 对标准Lena灰度图片分别使用5x5的高斯核进行空域滤波，结果记为A。实现其对应的频域滤波，结果记为B。分别计算A、B图像的PSNR，结合课本知识给出你的结论。（请使用本课程提供的实验图片数据）

photo_path = 'exp2/lena_gray_256.tif';

photo_gray = imread(photo_path);

h = fspecial('gaussian', 5, 1); % 5x5高斯核

% 空域滤波
A = imfilter(photo_gray, h, 'conv', 'same', 'replicate');

% 频域滤波
H = psf2otf(h, size(photo_gray));  % 将空域滤波核转换为频域
F = fft2(double(photo_gray));      % 图像傅里叶变换
G = H .* F;                        % 频域相乘
B = real(ifft2(G));                % 逆傅里叶变换
B = uint8(B);                      % 转回无符号8位整数

% 计算PSNR
psnr_A = psnr(A, photo_gray);
psnr_B = psnr(B, photo_gray);

% 显示图像和PSNR结果
figure;
subplot(2,2,1);
imshow(photo_gray);
title('原图像');

subplot(2,2,2);
imshow(h, []);
title('5x5高斯滤波核');

subplot(2,2,3);
imshow(A);
title(['空域滤波 (PSNR: ', num2str(psnr_A,'%.2f'), ')']);

subplot(2,2,4);
imshow(B);
title(['频域滤波 (PSNR: ', num2str(psnr_B,'%.2f'), ')']);

% 打印PSNR值和结论
fprintf('空域滤波 PSNR: %.2f\n', psnr_A);
fprintf('频域滤波 PSNR: %.2f\n', psnr_B);
