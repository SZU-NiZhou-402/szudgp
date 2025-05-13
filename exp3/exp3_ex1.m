displayColorComponents

function displayColorComponents()
    % Clear workspace and command window
    clc; clear;
    
    % Read and process image
    imagePath = 'exp3/lena_color_256.tif';
    rgbImage = imread(imagePath);
    hsvImage = rgb2hsv(rgbImage);
    
    % Extract color components
    rgbComponents = {
        rgbImage(:,:,1);
        rgbImage(:,:,2);
        rgbImage(:,:,3);
    };
    
    hsvComponents = {
        hsvImage(:,:,1);
        hsvImage(:,:,3);
    };
    
    % Setup figure
    figure('Name', 'Color Components Analysis');
    
    % Display original image
    subplot(231);
    imshow(rgbImage);
    title('Original Image');
    
    % Display RGB components
    titles = {'R', 'G', 'B'};
    for i = 1:3
        subplot(2,3,i+1);
        imshow(rgbComponents{i});
        title(titles{i});
    end
    
    % Display HSV components
    subplot(235);
    imshow(hsvComponents{2});
    title('Luminance');
    
    subplot(236);
    imshow(hsvComponents{1});
    title('Hue');
end
