% 读取图片，图片反色（即用：255 - 像素灰度值），存储为jpg图片

photo_path = 'exp1/photo.jpg';
photo = imread(photo_path);
photo = 255 - photo;
imwrite(photo, 'exp1/photo_reverse.jpg', 'jpg');
