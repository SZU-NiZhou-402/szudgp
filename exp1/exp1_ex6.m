% 6、平滑空间滤波器实验。1）任意选取一张灰度图(记做图A3)，给图像A3加入高斯噪
% 声，结果记做图B3；2）实现3x3均值滤波器程序（不能调用matlab自带函数），对B3
% 进行平滑滤波，结果记为C3；如上显示结果，观察现象。

photo_path = 'exp1/photo_gray.jpg';

% 读取图片
photo = imread(photo_path);

% 加入高斯噪声
photo_b3 = imnoise(photo, 'gaussian', 0, 0.01);

% 3x3均值滤波器
function img = mean_filter(img)
    [h, w] = size(img);
    img = double(img);
    img_new = zeros(h, w);
    for i = 2:h-1
        for j = 2:w-1
            img_new(i, j) = (img(i-1, j-1) + img(i-1, j) + img(i-1, j+1) + ...
                            img(i, j-1) + img(i, j) + img(i, j+1) + ...
                            img(i+1, j-1) + img(i+1, j) + img(i+1, j+1)) / 9;
        end
    end
    img = uint8(img_new);
end

% 平滑滤波
photo_c3 = mean_filter(photo_b3);

% 拼成一张图
photo_all = [photo, photo_b3, photo_c3];

% 显示图片
imshow(photo_all);