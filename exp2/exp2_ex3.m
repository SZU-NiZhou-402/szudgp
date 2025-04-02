% 使用标准Lena灰度图片，添加高斯噪声imnoise(I,‘gaussian’, 0.05) 。请用合适的频域滤波器对图像进行质量提升，获得你认为最好的效果图并计算其峰值信噪比PSNR。（注：PSNR值越高，本题得分越高）

photo_path = 'exp2/lena_gray_256.tif';

photo_gray = imread(photo_path);

% 显示原始图像
figure;
subplot(1, 3, 1);
imshow(photo_gray); title('原始图像');

% 添加高斯噪声
noisy_img = im2double(photo_gray);
noisy_img = imnoise(noisy_img, 'gaussian', 0.05);
noisy_img = im2uint8(noisy_img);

% 显示添加噪声后的图像

subplot(1, 3, 2);
imshow(noisy_img); title('添加高斯噪声后的图像');

% 使用小波变换去噪
wavename = 'sym8'; % 小波基函数
level = 2; % 分解层数

% 将图像转换为双精度
noisy_img_double = im2double(noisy_img);

% 使用小波分解
[C, S] = wavedec2(noisy_img_double, level, wavename);

% 估计噪声标准差
sigma = median(abs(C(prod(S(1,:))+1:end)))/0.6745;

% 使用自适应阈值
alpha = 2; % 阈值系数
thr = alpha * sigma; % 计算阈值

% 对小波系数进行软阈值处理
C_thresholded = wthresh(C, 's', thr);

% 重建图像
filtered_img = waverec2(C_thresholded, S, wavename);

% 确保像素值在[0,1]范围内
filtered_img = max(0, min(filtered_img, 1));

% 计算PSNR
photo_gray_double = im2double(photo_gray);
psnr_value = psnr(filtered_img, photo_gray_double);
disp(['PSNR值: ', num2str(psnr_value)]);

% 显示去噪后的图像
subplot(1, 3, 3);
imshow(filtered_img); title('去噪后的图像');
