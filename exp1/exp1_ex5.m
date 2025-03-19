% 5、图像直方图实验。1）任意选取一张灰度图(记做图A2)，使用通过灰度变换将它的灰
% 度值调整到[0, 0.5]之间(记做图B2)；2）根据直方图算法实现直方图均衡化程序（不能
% 调用matlab自带函数），对B2进行直方图均衡化，结果记为C2；如上显示结果，观察
% 现象。

photo_path = 'exp1/photo_gray.jpg';

% 灰度变换函数
function img = gray_transform(img, a, b)
    img = double(img) / 255;
    img = (img - a) * (b - a);
    img = uint8(img * 255);
end

% 直方图均衡化函数
function img = hist_equalization(img)
    [h, w] = size(img);
    img = double(img);
    % 计算直方图
    hist = zeros(1, 256);
    for i = 1:h
        for j = 1:w
            hist(img(i, j) + 1) = hist(img(i, j) + 1) + 1;
        end
    end
    % 计算累积直方图
    cdf = zeros(1, 256);
    cdf(1) = hist(1);
    for i = 2:256
        cdf(i) = cdf(i - 1) + hist(i);
    end
    % 直方图均衡化
    img = (cdf(img + 1) - 1) / (h * w) * 255;
    img = uint8(img);
end

% 读取图片
photo = imread(photo_path);

% 灰度变换
photo_b2 = gray_transform(photo, 0, 0.5);

% 直方图均衡化
photo_c2 = hist_equalization(photo_b2);

% 拼成一张图
photo_all = [photo, photo_b2, photo_c2];

% 显示图片
imshow(photo_all);

% 保存均衡化后的图片
imwrite(photo_c2, 'exp1/photo_hist_equalization.jpg', 'jpg');
