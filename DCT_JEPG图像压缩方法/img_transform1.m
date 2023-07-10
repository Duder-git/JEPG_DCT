function [ T ] = img_transform1( image, method )
%IMG_TRANSFORM Transforms the (grayscale) image
%   Splits the image into 8x8 blocks, on each block, DCT (either the built-in
%   function or own implementation) or FFT is applied.
%   Any image's dimension is truncated if it is not a multiplier of 8.
%
% Input:
%   image  - a matrix of pixels 图像矩阵
%   method - transform to be performed on 8x8 blocks:
%            (0: built-in DCT2, 1: own implementation of DCT2, 2: FFT2)
%             (0: 使用内置函数 1: 自身实现 2: FFT2变换)
%
% Return:
%   T - transformation of the image
%
% An error is reported if 'method' is invalid.

% size of a block (NxN)
N = 8;

% image's dimension
[rows, cols, ~] = size(image);

% Number of 8x8 blocks
NR = floor( rows / N );
NC = floor( cols / N );

% Preallocation of T
T = zeros(NR * N, NC * N);

%% method 0 built-in DCT2
if ( method == 0 )
    for i = 1 : NR
        for j = 1 : NC
            % submatrix for the corresponding 8x8 block
            subm = double(image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ));

            % built in DCT2:
            T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = dct2(subm);
        end
    end

%% method 1 own implementation of DCT2
elseif ( method == 1 )
    % Precalculated table of cosines:
    c = zeros(N, N);

    % The table of cosines is actually only necessary if method==1
    for i = 1 : N % x,y
        for j = 1 : N % u,v
            % note that matrix indices are 1-based!
            c(i, j) = (2*i-1)*(j-1)*pi/(2*N);
        end  % for j
    end  % for i

    c = cos (c);

    for i = 1 : NR
        for j = 1 : NC
            % submatrix for the corresponding 8x8 block
            subm = double(image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ));

            % Finally copy B into the corresponding region of T:
            %T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = Btest(subm,c,N);
            T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = Btest2(subm,c,N);
        end
    end

%% method 2 FFT2
elseif ( method == 2 )
    for i = 1 : NR
        for j = 1 : NC
            % submatrix for the corresponding 8x8 block
            subm = double(image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ));

            % built in FFT
            T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = fft2(subm);
        end
    end

%%
else
    error('Invalid method');
end  % if method

end


%%
function B = Btest(subm, c, N)
% own implementation of DCT2
B = zeros(N, N);

% Should this be done? It is mentioned in:
% https://en.wikipedia.org/wiki/JPEG#Discrete_cosine_transform
%subm = subm - 128;

% Calculate B(u,v) as described in the lecture 4 (week 2)
for u = 1 : N
    for v = 1 : N
        B(u, v) = 0;

        for x = 1 : N
            for y = 1 : N
                B(u, v) = B(u, v) + subm(x, y) * c(x, u) * c(y, v) * 2 / N;
            end  % for y
        end  % for x
    end  % for v
end  % for u

% Normalization of B:
% All B's values are multiplied by 2/N,
% then all elements of B's first column and first row
% are additionally divided by sqrt(2):
B(:, 1) = B(:, 1) / sqrt(2);
B(1, :) = B(1, :) / sqrt(2);

end


function B = Btest2(subm,c,N)
% own implementation of DCT2
B = zeros(N, N);

% Should this be done? It is mentioned in:
% https://en.wikipedia.org/wiki/JPEG#Discrete_cosine_transform
%subm = subm - 128;

% Calculate B(u,v) as described in the lecture 4 (week 2)
for u = 1 : N
    for v = 1 : N
        c_tmp = c(:,u)*c(:,v)';
        B(u, v) = sum(subm.*c_tmp,'all');
    end  % for v
end  % for u

% Normalization of B:
% All B's values are multiplied by 2/N,
% then all elements of B's first column and first row
% are additionally divided by sqrt(2):
B = 2 * B / N;
B(:, 1) = B(:, 1) / sqrt(2);
B(1, :) = B(1, :) / sqrt(2);

end


