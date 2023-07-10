%% 处理灰色图像
close all;
clear,clc;


img = imread('./lena512.pgm');

% Display the image:
disp('Figure 1: the original image')
figure(1);
imshow(img);

% DCT transform:
timg = img_transform1(img, 1); % 0 内置方法 1 子编写方法 2 fft方法

%% Quantizations:
% - by quantization matrix:
q1 = img_quantize1(timg, 0, 0);

% - threshold (th=32):
q2 = img_quantize1(timg, 1, 32);

% - threshold (th=16):
q3 = img_quantize1(timg, 1, 16);

% - preserved 8 largest coefficients:
q4 = img_quantize1(timg, 2, 0);

% FFT transform:
fimg = img_transform(img, 2);

% Quantization of FFT transform using the quantization matrix:
q5 = img_quantize(fimg, 1, 128);

% Inverse transforms of all  quantizations:
im1 = img_inv_transform1(q1, 0);
im2 = img_inv_transform1(q2, 1);
im3 = img_inv_transform1(q3, 0);
im4 = img_inv_transform1(q4, 1);
im5 = img_inv_transform1(q5, 2);

%Display all compressed images:
% disp('Figure 2: compressed using the quantization matrix:');
% figure(2);
% imshow(im1);
% 
% disp('Figure 3: compressed using the threshold 32:');
% figure(3);
% imshow(im2);
% 
% disp('Figure 4: compressed using the threshold 16:');
% figure(4);
% imshow(im3);
% 
% disp('Figure 5: compressed by preserving 8 largest DCT coefficients:');
% figure(5);
% imshow(im4);
% 
% disp('Figure 6: Fourier transformed image, compressed using the threshold 128:');
% figure(6);
% imshow(im5);
%% 
figure
subplot(2,3,1)
imshow(img)
title('the original image')

subplot(2,3,2)
imshow(im1)
title('compressed using the quantization matrix')

subplot(2,3,3)
imshow(im4)
title('compressed by preserving 8 largest DCT coefficients')

subplot(2,3,4)
imshow(im3)
title('compressed using the threshold 16')

subplot(2,3,5)
imshow(im2)
title('compressed using the threshold 32')

subplot(2,3,6)
imshow(im5)
title('Fourier transformed image, compressed using the threshold 128')

%% 
rep = input('Press any key to continue...', 's');

close(figure(2));  close(figure(3));  
close(figure(4));  close(figure(5));  close(figure(6));
%%  解压缩结果与原始图像差值:
disp('Figure 1: The difference between original and threshold 16:');
E1 = int16(im3)-int16(img);
eh1 = err_hist(E1);

disp('Figure 2: The difference between original and threshold 32:');
E2 = int16(im2)-int16(img);
eh2 = err_hist(E2);

disp('Figure 3: The difference between original and threshold 128:');
E3 = int16(im5)-int16(img);
eh3 = err_hist(E3);


% figure(1);
% bar(eh1(1,:), eh1(2,:));
% H1 = err_entropy(eh1);
% fprintf('Entropy: %f\n\n', H1);
% 
% figure(2);
% bar(eh2(1,:), eh2(2,:));
% H2 = err_entropy(eh2);
% fprintf('Entropy: %f\n\n', H2);
% 
% figure(3);
% bar(eh3(1,:), eh3(2,:));
% H3 = err_entropy(eh3);
% fprintf('Entropy: %f\n\n', H3);
%%
figure
subplot(2,3,1)
imshow(E1,[])
title('The difference between original and threshold 16')
subplot(2,3,2)
imshow(E2,[])
title('The difference between original and threshold 32')
subplot(2,3,3)
imshow(E3,[])
title('The difference between original and threshold 128')

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
rep = input('Press any key to continue...', 's');

close(figure(2));  close(figure(3));  
close(figure(4));  close(figure(5));  close(figure(6));

%% Apply quantization on the original image 对原始图像量化
im1 = img_quantize(img, 0, 0);
im2 = img_quantize(img, 1, 32);
im3 = img_quantize(img, 1, 16);
im4 = img_quantize(img, 2, 0);
im5 = img_quantize(img, 1, 128);

% disp('Figure 2: Quantization of an image without performing DCT, use quantization matrix:')
% figure(2);
% imshow(im1);
% 
% disp('Figure 3: Quantization of an image without performing DCT, use threshold 32:')
% figure(3);
% imshow(im2);
% 
% disp('Figure 4: Quantization of an image without performing DCT, use threshold 16:')
% figure(4);
% imshow(im3);
% 
% disp('Figure 5: Quantization of an image without performing DCT, use preservation of 8 largest values:')
% figure(5);
% imshow(im4);
% 
% disp('Figure 6: Quantization of an image without performing DCT, use threshold 128:')
% figure(6);
% imshow(im5);
%%
figure
subplot(2,3,1)
imshow(img)
title('the original image')

subplot(2,3,2)
imshow(im1)
title('use quantization matrix')

subplot(2,3,3)
imshow(im4)
title('use preservation of 8 largest values')

subplot(2,3,4)
imshow(im3)
title('use threshold 16')

subplot(2,3,5)
imshow(im2)
title('use threshold 32')

subplot(2,3,6)
imshow(im5)
title('use threshold 128')

%%
rep = input('Press any key to close all figures, clear all variables and finish...', 's');

close all; clear;
