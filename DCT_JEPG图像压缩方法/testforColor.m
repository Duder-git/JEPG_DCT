%% Compression of a color image: 处理彩色图像
close all;
clear,clc;


colimg = imread('./lena512color.tiff');

% 原始彩色图像
disp('Figure 1: the original color image');
figure(1);
imshow(colimg);

% 所有通道的量化阈值为8时的彩色图像
rgb1 = img_color_compress(colimg, 8, 8);
disp('Figure 2: color image comprassed with quantization threshold of 8 for all channels');
figure(2);
imshow(rgb1);

% 彩色图像压缩，Y通道的量化阈值为8，两个色度通道的量化阈值均为64
rgb2 = img_color_compress(colimg, 8, 64);
disp('Figure 3: color image compressed with quantization threshold of 8 for the Y channel');
disp('          and 64 for both chrominance channels')
figure(3);
imshow(rgb2);
%%
figure
subplot(1,3,1)
imshow(colimg);
title('the original color image')
subplot(1,3,2)
imshow(rgb1);
title('quantization threshold of 8 for all channels')
subplot(1,3,3)
imshow(rgb2);
title('quantization threshold of 8 for the Y channel and 64 for both chrominance channels')

%% 
rep = input('Press any key to continue...', 's');
close all;

%% Predicton methods:
disp('Figure 1: Prediction from pixel''s left neighbour:');
E1 = pred_error(img, 0);
eh1 = err_hist(E1);
figure(1);
bar(eh1(1,:), eh1(2,:));
H1 = err_entropy(eh1);
fprintf('Entropy: %f\n\n', H1);

disp('Figure 2: Prediction from pixel''s right neighbour:');
E2 = pred_error(img, 1);
eh2 = err_hist(E2);
figure(2);
bar(eh2(1,:), eh2(2,:));
H2 = err_entropy(eh2);
fprintf('Entropy: %f\n\n', H2);

disp('Figure 3: Prediction from pixel''s 3 neighbours:');
E3 = pred_error(img, 2);
eh3 = err_hist(E3);
figure(3);
bar(eh3(1,:), eh3(2,:));
H3 = err_entropy(eh3);
fprintf('Entropy: %f\n\n', H3);
%%
figure
subplot(2,3,1)
imshow(E1,[])
title('Prediction from pixel''s left neighbour')
subplot(2,3,2)
imshow(E2,[])
title('Prediction from pixel''s right neighbour')
subplot(2,3,3)
imshow(E3,[])
title('Prediction from pixel''s 3 neighbours')

subplot(2,3,4)
bar(eh1(1,:), eh1(2,:))
title(['Entropy: ',num2str(H1)])
subplot(2,3,5)
bar(eh2(1,:), eh2(2,:))
title(['Entropy: ',num2str(H2)])
subplot(2,3,6)
bar(eh3(1,:), eh3(2,:))
title(['Entropy: ',num2str(H3)])

%%
rep = input('Press any key to close all figures, clear all variables and finish...', 's');

close all; clear;