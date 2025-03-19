% 将图片转成灰度图并保存

photo_path = 'exp1/photo.jpg';
photo = imread(photo_path);
photo = rgb2gray(photo);

imwrite(photo, 'exp1/photo_gray.jpg', 'jpg');
