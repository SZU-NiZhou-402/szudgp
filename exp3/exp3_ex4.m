clc; clear; close all;

%% 读取和预处理图像
try
    img = imread('lena_color_256.tif');
    img = im2gray(img);
    fprintf('成功读取图像，尺寸：%d x %d\n', size(img, 1), size(img, 2));
catch ME
    error('无法读取图像文件：%s', ME.message);
end

%% 定义边缘检测器配置
detectors = struct(...
    'LoG', struct('name', 'LoG边缘检测', 'func', @apply_log), ...
    'Laplace', struct('name', 'Laplace边缘检测', 'func', @apply_laplace), ...
    'Prewitt', struct('name', 'Prewitt边缘检测', 'func', @apply_prewitt), ...
    'Sobel', struct('name', 'Sobel边缘检测', 'func', @apply_sobel) ...
);

%% 应用边缘检测算法
results = struct();
detector_names = fieldnames(detectors);

for i = 1:length(detector_names)
    name = detector_names{i};
    tic;
    results.(name) = detectors.(name).func(img);
    fprintf('%s 处理时间：%.4f 秒\n', detectors.(name).name, toc);
end

display_edge_detection_results(img, results, detectors);

%% ======================== 边缘检测函数实现 ========================

function edge_img = apply_log(img)
    % LoG (Laplacian of Gaussian) 边缘检测
    filter = fspecial('log', [7, 7], 1);
    edge_img = imfilter(img, filter);
    edge_img = normalize_image(edge_img);
end

function edge_img = apply_laplace(img)
    % Laplace 边缘检测
    filter = fspecial('laplacian');
    edge_img = imfilter(img, filter);
    edge_img = normalize_image(edge_img);
end

function edge_img = apply_prewitt(img)
    % Prewitt 边缘检测
    kernels = get_prewitt_kernels();
    edge_img = apply_gradient_operator(img, kernels);
end

function edge_img = apply_sobel(img)
    % Sobel 边缘检测
    kernels = get_sobel_kernels();
    edge_img = apply_gradient_operator(img, kernels);
end

function kernels = get_prewitt_kernels()
    % 获取Prewitt算子核
    kernels.horizontal = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
    kernels.vertical = [-1, -1, -1; 0, 0, 0; 1, 1, 1];
end

function kernels = get_sobel_kernels()
    % 获取Sobel算子核
    kernels.horizontal = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
    kernels.vertical = [-1, -2, -1; 0, 0, 0; 1, 2, 1];
end

function edge_img = apply_gradient_operator(img, kernels)
    % 应用梯度算子进行边缘检测
    img_double = double(img);
    
    % 计算水平和垂直梯度
    grad_h = imfilter(img_double, kernels.horizontal);
    grad_v = imfilter(img_double, kernels.vertical);
    
    % 计算梯度幅值
    magnitude = sqrt(grad_h.^2 + grad_v.^2);
    
    % 归一化到0-255范围
    edge_img = uint8(255 * (magnitude / max(magnitude(:))));
end

function normalized_img = normalize_image(img)
    % 图像归一化函数
    img_double = double(img);
    img_min = min(img_double(:));
    img_max = max(img_double(:));
    
    if img_max > img_min
        normalized_img = uint8(255 * (img_double - img_min) / (img_max - img_min));
    else
        normalized_img = uint8(img_double);
    end
end

function display_edge_detection_results(original_img, results, detectors)
    % 创建图形窗口 - 优化尺寸和排版
    figure('Name', '边缘检测算法比较', 'NumberTitle', 'off', ...
           'Position', [100, 80, 1300, 400]);
    
    % 使用tiledlayout获得更好的排版控制
    tiledlayout(1, 5, 'TileSpacing', 'compact', 'Padding', 'compact');
    
    % 显示原始图像
    nexttile;
    imshow(original_img);
    title('原始图像', 'FontSize', 11, 'FontWeight', 'bold');
    
    % 显示各种边缘检测结果
    detector_names = fieldnames(results);
    for i = 1:length(detector_names)
        nexttile;
        imshow(results.(detector_names{i}));
        title(detectors.(detector_names{i}).name, 'FontSize', 11, 'FontWeight', 'bold');
    end
    
    % 添加整体标题 - 调整字体大小避免重叠
    sgtitle('经典边缘检测算法比较', 'FontSize', 13, 'FontWeight', 'bold');
    
    % 优化显示效果
    set(gcf, 'Color', 'white');
    drawnow;
end