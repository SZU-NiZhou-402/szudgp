clc; clear; close all;

%% 读取和验证图像
try
    gray_img = imread('cameraman.tif');
    if size(gray_img, 3) > 1
        gray_img = rgb2gray(gray_img);
    end
    fprintf('成功读取图像，尺寸：%d x %d，数据类型：%s\n', ...
            size(gray_img, 1), size(gray_img, 2), class(gray_img));
catch ME
    error('无法读取图像文件：%s', ME.message);
end

%% 执行Otsu分割算法
fprintf('\n正在执行Otsu分割算法...\n');

% 基本二值化分割
tic;
[binary_img, threshold_main] = otsu_threshold(gray_img, 1, 256);
time_binary = toc;
fprintf('二值化分割完成，阈值：%d，耗时：%.4f秒\n', threshold_main, time_binary);

% 多级分割 - 分成4个区域
tic;
[thresholds, multilevel_img] = otsu_multilevel_segmentation(gray_img, 3);
time_multilevel = toc;
fprintf('多级分割完成，阈值：[%s]，耗时：%.4f秒\n', ...
        num2str(thresholds, '%d '), time_multilevel);

%% 创建彩色分割可视化图像
colormap_segments = create_segmentation_colormap(length(thresholds) + 1);
colored_segmentation = create_colored_segmentation(gray_img, thresholds, colormap_segments);

%% 统计分析
segment_stats = analyze_segmentation_statistics(gray_img, thresholds);
print_segmentation_statistics(segment_stats, thresholds);

display_otsu_results(gray_img, binary_img, colored_segmentation, ...
                     threshold_main, thresholds, segment_stats);

%% ======================== Otsu算法核心实现 ========================

function [binary_img, optimal_threshold] = otsu_threshold(img, start_val, end_val)
    % 高效的Otsu阈值计算
    % 输入：img - 灰度图像，start_val/end_val - 搜索范围
    % 输出：binary_img - 二值图像，optimal_threshold - 最佳阈值
    
    % 计算图像直方图
    [counts, ~] = imhist(img);
    total_pixels = numel(img);
    
    % 归一化直方图得到概率分布
    prob = counts / total_pixels;
    
    % 初始化变量
    max_variance = 0;
    optimal_threshold = start_val;
    
    % 搜索最佳阈值
    for t = start_val:(end_val-1)
        % 计算背景和前景的权重
        w0 = sum(prob(1:t));           % 背景权重
        w1 = sum(prob(t+1:end));       % 前景权重
        
        if w0 == 0 || w1 == 0
            continue;
        end
        
        % 计算背景和前景的均值
        mu0 = sum((0:t-1) .* prob(1:t)') / w0;
        mu1 = sum((t:255) .* prob(t+1:end)') / w1;
        
        % 计算类间方差
        between_class_variance = w0 * w1 * (mu0 - mu1)^2;
        
        % 更新最佳阈值
        if between_class_variance > max_variance
            max_variance = between_class_variance;
            optimal_threshold = t;
        end
    end
    
    % 生成二值图像
    binary_img = img >= optimal_threshold;
end

function [thresholds, segmented_img] = otsu_multilevel_segmentation(img, num_thresholds)
    % 多级Otsu分割
    % 输入：img - 灰度图像，num_thresholds - 阈值数量
    % 输出：thresholds - 阈值数组，segmented_img - 分割标签图像
    
    thresholds = zeros(1, num_thresholds);
    remaining_img = img;
    current_min = 1;
    
    % 递归应用Otsu算法
    for i = 1:num_thresholds
        if i == num_thresholds
            % 最后一个阈值使用全范围
            [~, thresh] = otsu_threshold(img, current_min, 256);
        else
            % 在当前范围内寻找阈值
            [~, thresh] = otsu_threshold(img, current_min, 256);
            % 为下一次迭代更新范围
            current_min = thresh + 1;
        end
        thresholds(i) = thresh;
    end
    
    % 排序阈值
    thresholds = sort(thresholds);
    
    % 创建分割标签图像
    segmented_img = zeros(size(img));
    for i = 1:length(thresholds)
        if i == 1
            segmented_img(img < thresholds(i)) = 1;
        else
            mask = (img >= thresholds(i-1)) & (img < thresholds(i));
            segmented_img(mask) = i;
        end
    end
    segmented_img(img >= thresholds(end)) = length(thresholds) + 1;
end

function colormap_matrix = create_segmentation_colormap(num_segments)
    % 创建分割可视化的颜色映射
    colors = [
        0, 0, 0;         % 黑色
        255, 0, 0;       % 红色
        0, 255, 0;       % 绿色
        0, 0, 255;       % 蓝色
        255, 255, 0;     % 黄色
        255, 0, 255;     % 品红
        0, 255, 255;     % 青色
        128, 128, 128    % 灰色
    ];
    
    if num_segments <= size(colors, 1)
        colormap_matrix = colors(1:num_segments, :);
    else
        % 如果需要更多颜色，生成随机颜色
        extra_colors = randi([0, 255], num_segments - size(colors, 1), 3);
        colormap_matrix = [colors; extra_colors];
    end
end

function colored_img = create_colored_segmentation(img, thresholds, colormap_matrix)
    % 使用向量化操作创建彩色分割图像
    [height, width] = size(img);
    colored_img = zeros(height, width, 3, 'uint8');
    
    % 为每个分割区域分配颜色
    for i = 1:length(thresholds) + 1
        if i == 1
            mask = img < thresholds(1);
        elseif i == length(thresholds) + 1
            mask = img >= thresholds(end);
        else
            mask = (img >= thresholds(i-1)) & (img < thresholds(i));
        end
        
        % 向量化颜色分配
        for c = 1:3
            channel = colored_img(:, :, c);
            channel(mask) = colormap_matrix(i, c);
            colored_img(:, :, c) = channel;
        end
    end
end

function stats = analyze_segmentation_statistics(img, thresholds)
    % 分析分割结果的统计信息
    total_pixels = numel(img);
    stats = struct();
    
    for i = 1:length(thresholds) + 1
        if i == 1
            mask = img < thresholds(1);
            range_str = sprintf('[0, %d)', thresholds(1));
        elseif i == length(thresholds) + 1
            mask = img >= thresholds(end);
            range_str = sprintf('[%d, 255]', thresholds(end));
        else
            mask = (img >= thresholds(i-1)) & (img < thresholds(i));
            range_str = sprintf('[%d, %d)', thresholds(i-1), thresholds(i));
        end
        
        region_pixels = img(mask);
        stats.(sprintf('region_%d', i)) = struct(...
            'pixel_count', sum(mask(:)), ...
            'percentage', 100 * sum(mask(:)) / total_pixels, ...
            'mean_intensity', mean(region_pixels), ...
            'std_intensity', std(double(region_pixels)), ...
            'range', range_str ...
        );
    end
end

function print_segmentation_statistics(stats, thresholds)
    % 打印分割统计信息
    fprintf('\n=== 分割区域统计信息 ===\n');
    region_names = fieldnames(stats);
    
    for i = 1:length(region_names)
        region = stats.(region_names{i});
        fprintf('区域 %d: 范围 %s\n', i, region.range);
        fprintf('  像素数量: %d (%.2f%%)\n', region.pixel_count, region.percentage);
        fprintf('  平均灰度: %.2f ± %.2f\n', region.mean_intensity, region.std_intensity);
        fprintf('\n');
    end
end

function display_otsu_results(original_img, binary_img, colored_img, ...
                              binary_threshold, multi_thresholds, stats)
    % 创建主窗口 - 增加高度以避免标题重叠
    figure('Name', 'Otsu自适应阈值分割结果', 'NumberTitle', 'off', ...
           'Position', [50, 50, 1400, 650]);
    
    % 使用tiledlayout获得更好的排版控制
    tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
    
    % 原始图像
    nexttile;
    imshow(original_img);
    title('原始灰度图像', 'FontSize', 11, 'FontWeight', 'bold');
    
    % 直方图 - 简化标题避免重叠
    nexttile;
    imhist(original_img);
    hold on;
    ylim_vals = ylim;
    
    % 在直方图上标记阈值
    plot([binary_threshold, binary_threshold], ylim_vals, 'r--', 'LineWidth', 2);
    for i = 1:length(multi_thresholds)
        plot([multi_thresholds(i), multi_thresholds(i)], ylim_vals, 'g--', 'LineWidth', 1.5);
    end
    
    title('灰度直方图', 'FontSize', 11, 'FontWeight', 'bold');
    legend({sprintf('二值阈值:%d', binary_threshold), '多级阈值'}, ...
           'Location', 'northeast', 'FontSize', 9);
    
    % 二值化结果
    nexttile;
    imshow(binary_img);
    title(sprintf('二值化分割 (阈值:%d)', binary_threshold), ...
          'FontSize', 11, 'FontWeight', 'bold');
    
    % 多级分割结果
    nexttile;
    imshow(colored_img);
    title(sprintf('多级分割 (阈值:%s)', num2str(multi_thresholds, '%d,')), ...
          'FontSize', 11, 'FontWeight', 'bold');
    
    % 阈值对比图
    nexttile;
    threshold_comparison = [binary_threshold; multi_thresholds'];
    bar(threshold_comparison, 'FaceColor', [0.2 0.6 0.8]);
    title('阈值对比', 'FontSize', 11, 'FontWeight', 'bold');
    ylabel('灰度值');
    xlabel('阈值序号');
    grid on;
    
    % 分割区域统计
    nexttile;
    region_names = fieldnames(stats);
    percentages = zeros(length(region_names), 1);
    labels = cell(length(region_names), 1);
    
    for i = 1:length(region_names)
        percentages(i) = stats.(region_names{i}).percentage;
        labels{i} = sprintf('区域%d\n%.1f%%', i, percentages(i));
    end
    
    pie(percentages, labels);
    title('区域面积占比', 'FontSize', 11, 'FontWeight', 'bold');
    
    % 添加整体标题 - 调整位置避免重叠
    sgtitle('Otsu自适应阈值分割算法分析', 'FontSize', 14, 'FontWeight', 'bold');
    
    % 设置窗口背景和更好的间距
    set(gcf, 'Color', 'white');
    
    % 微调布局以确保美观
    drawnow;
end 