% 7、锐化空间滤波器实验。1）任意选取一张灰度图(记做图A4)，使用通过5x5的高斯核
% 对图像A4进行模糊,结果记为B4；2）使用中心系数为正的拉普拉斯算子对B4进行锐
% 化提升图像质量，结果记为C4；3）使用高提升滤波对B4进行锐化提升图像质量，结
% 果记为D4。如上显示结果，观察现象。

photo_path = 'exp1/photo_gray.jpg';

% 读取图片
photo = imread(photo_path);

% 高斯核
gaussian_kernel = fspecial('gaussian', 5, 1);

% 模糊
photo_b4 = imfilter(photo, gaussian_kernel);

% 拉普拉斯算子
laplacian_kernel = [0 -1 0; -1 4 -1; 0 -1 0];

% 锐化
photo_c4 = imfilter(photo_b4, laplacian_kernel);

% 高提升滤波
photo_d4 = photo_b4 + photo - photo_c4;

% 拼成一张图
photo_all = [photo, photo_b4, photo_c4, photo_d4];

% 显示图片
imshow(photo_all);