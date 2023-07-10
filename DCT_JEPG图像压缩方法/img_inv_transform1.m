function [ image ] = img_inv_transform1( T, method )
%IMG_INV_TRANSFORM Transforms the transform (typically DCT) to an image.
% 逆DCT变换，将DCT矩阵转换为图像矩阵
%   Splits the transform into 8x8 blocks, on each block, inverse DCT (either
%   the built-in function or own implementation) or FFT is applied.
%   Any transform's dimension is truncated if it is not a multiplier of 8.
%
% Input:
%   T      - a matrix with the transform's coefficients
%   method - transform to be performed on 8x8 blocks:
%            (0: built-in IDCT2, 1: own implementation of IDCT2, 3: IFFT2)
%
% Return:
%   image - a matrix with image's pixels
%
% An error is reported if 'method' is invalid.



% size of a block (NxN)
N = 8;

% image's dimension
[rows, cols] = size(T);

% Number of 8x8 blocks
NR = floor( rows / N );
NC = floor( cols / N );

% Preallocation of T
image = zeros(NR * N, NC * N);

%% method 0 built-in DCT2
if ( method == 0 )
    % For each 8x8 block...:
    for i = 1 : NR
        for j = 1 : NC
            % submatrix for the corresponding 8x8 block
            subm = double(T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ));

            % built-in IDCT2:
            image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = idct2(subm);
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
            subm = double(T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ));

            % Finally copy B into the corresponding region of T:
            image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = iBtest(subm, c, N);
            image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = iBtest2(subm, c, N);
        end
    end

    %% method 2 FFT2
elseif ( method == 2 )
    for i = 1 : NR
        for j = 1 : NC
            % submatrix for the corresponding 8x8 block
            subm = double(T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ));

            % built-in FFT
            image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = real(ifft2(subm));
        end
    end

    %%
else
    error('Invalid method');
end  % if method

image = uint8( round(image) );

end

%%
function B = iBtest(subm, c, N)
% own implementation of IDCT2
B = zeros(N, N);

% Calculate B(x,y) as described in the lecture 4 (week 2)
for x = 1 : N
    for y = 1 : N
        B(x, y) = 0;

        for u = 1 : N
            for v = 1 : N
                term = subm(u, v) * c(x, u) * c(y, v) * 2 / N;

                % normalization (multiplication by
                % alpha(u)*alpha(v)):
                if ( u == 1 )
                    term = term / sqrt(2);
                end  % if
                if ( v == 1 )
                    term = term / sqrt(2);
                end  % if

                B(x, y) = B(x, y) + term;
            end  % for v
        end  % for u
    end  % for y
end  % for x

end


function B = iBtest2(subm,c,N)
% own implementation of DCT2
B = zeros(N, N);

% Should this be done? It is mentioned in:
% https://en.wikipedia.org/wiki/JPEG#Discrete_cosine_transform
%subm = subm - 128;

% Calculate B(u,v) as described in the lecture 4 (week 2)
for x = 1 : N
    for y = 1 : N
        c_tmp = c(x,:)'*c(y,:);
        c_tmp = c_tmp * 2 / N;
        c_tmp(:, 1) = c_tmp(:, 1) / sqrt(2);
        c_tmp(1, :) = c_tmp(1, :) / sqrt(2);
        B(x, y) = sum(subm.*c_tmp,'all');
    end  % for v
end  % for u

end