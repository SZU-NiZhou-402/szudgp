% 2.对该图片截取为256x256的图像块（imcrop），进行1/2,1/4,1/8,1/16,1/32缩放的图像空间分辨率显示(如图所示),并存储为jpg图片;

photo_path = 'exp1/photo.jpg';
photo = imread(photo_path);

% 将原始图片resize为256x256
original_crop = imresize(photo, [256 256]);

% 定义缩放比例数组
scales = 1./(2.^(1:5));

% 定义变量名数组和标题数组
var_names = {'photo_1_2', 'photo_1_4', 'photo_1_8', 'photo_1_16', 'photo_1_32'};
titles = {'1/2', '1/4', '1/8', '1/16', '1/32'};

% 函数：缩放并保留原始像素
function resized = scale_and_restore(img, scale)
    small = imresize(img, scale, 'nearest');
    resized = imresize(small, [256 256], 'nearest');
end

% 使用循环处理所有缩放
for i = 1:length(scales)
    img = scale_and_restore(original_crop, scales(i));
    % 添加标题文字
    img = insertText(img, [10 10], titles{i}, 'FontSize', 18, 'BoxColor', 'white', 'BoxOpacity', 0.7);
    assignin('base', var_names{i}, img);
end

% 拼成一张图
photo_all = [photo_1_2, photo_1_4; photo_1_8, photo_1_16; photo_1_32, photo_1_32];
imwrite(photo_all, 'exp1/photo_all.jpg', 'jpg');