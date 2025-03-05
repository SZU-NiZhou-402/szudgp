% 3.实现该256x256的图像块的灰度分辨率图(1-8 bits)，并存储为jpg图片;

photo_path = 'exp1/photo.jpg';
photo = imread(photo_path);

% 灰度化
photo = rgb2gray(photo);

% 灰度分辨显示函数
function gray_res = gray_resolution(img, bits)
    % 生成2^bits个灰度级
    gray_res = uint8(floor(double(img) / 2^(8-bits)) * 2^(8-bits));
end

% 定义变量名数组
var_names = {'photo_1_bit', 'photo_2_bit', 'photo_3_bit', 'photo_4_bit', 'photo_5_bit', 'photo_6_bit', 'photo_7_bit', 'photo_8_bit'};

% 使用循环处理所有灰度分辨率
for i = 1:8
    assignin('base', var_names{i}, gray_resolution(photo, i));
end

% 拼成一张图
photo_all = [photo_1_bit, photo_2_bit, photo_3_bit, photo_4_bit; photo_5_bit, photo_6_bit, photo_7_bit, photo_8_bit];
imwrite(photo_all, 'exp1/photo_gray_res.jpg', 'jpg');
