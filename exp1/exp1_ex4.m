% 4、灰度变换实验。1）从实验课专用图片中任意选取一张灰度图(记做图A1)，使用通过
% 灰度变换将它的灰度值调整到[0, 0.5]之间,结果记做图B1；将原图以及所有结果显示在
% 同一幅窗口中，观察现象，写出自己的心得体会。

photo_path = 'exp1/cameraman.tif';
photo = imread(photo_path);

% 灰度变换函数
function img = gray_transform(img, a, b)
    img = double(img) / 255;
    img = (img - a) * (b - a);
    img = uint8(img * 255);
end

% 灰度变换
photo_b1 = gray_transform(photo, 0, 0.5);

% 拼成一张图
photo_all = [photo, photo_b1];
imshow(photo_all);
% 从图中可以看出，灰度值调整到[0, 0.5]之间后，图像的亮度明显降低，整体变暗。
% 这是因为灰度值的范围缩小，原本的灰度值范围是[0, 255]，调整后的灰度值范围是[0, 127.5]，
