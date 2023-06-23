%% Lab IV: Shape from Stereo
clear all
clc
close all
fprintf('Start of the script');

%% CONTROL PARAMETERS
ACCURATE_IMAGE = 0; % 1 to use the image of the webpage and not the one provided in doddle

BLOB_SIZE_x = 20;  % Select the blob size
BLOB_SIZE_y = 40;  % Select the blob size

%% READING IMAGES
% From RUG page
RIGHT_img_RGB = imread('tsukuba1.png');
LEFT_img_RGB = imread('tsukuba2.png');
GROUND_TRUTH = imread('tsukuba_gt.png');

% % Original images (better quality)
if ACCURATE_IMAGE == 1
    RIGHT_img_RGB = imread('scene1.row3.col1.ppm');
    LEFT_img_RGB = imread('scene1.row3.col2.ppm');
    GROUND_TRUTH = imread('truedisp.row3.col3.pgm');
end

% We transform the images to the grayscale
LEFT_img = rgb2gray(LEFT_img_RGB);
RIGHT_img = rgb2gray(RIGHT_img_RGB);

d = size(LEFT_img);

ysize = d(1);
xsize = d(2);

disparity_array = GROUND_TRUTH;
disparity_array(:,:) = 0;

fprintf('\nSize of the image(%d %d)', ysize, xsize);

d = size(disparity_array);

ysize = d(1);
xsize = d(2);

fprintf('\nSize of the image(%d %d)', ysize, xsize);

%% LOOP
fprintf('\nRunning to match blobs.\n');

HALF_BLOB_x= BLOB_SIZE_x/2;
HALF_BLOB_y= BLOB_SIZE_y/2;

for column = (HALF_BLOB_x+1):(xsize - HALF_BLOB_x)
    for row = 130:170%(HALF_BLOB_y+1):(ysize - HALF_BLOB_y)
        
        BLOB_LEFT = LEFT_img(row-HALF_BLOB_y:row+HALF_BLOB_y,column-HALF_BLOB_x:column+HALF_BLOB_x);
        BLOB_RIGHT = RIGHT_img(row-HALF_BLOB_y:row+HALF_BLOB_y,column-HALF_BLOB_x:column+HALF_BLOB_x);
        
        min_error = 10^10;

        for column_right = (HALF_BLOB_x+1):(xsize-(HALF_BLOB_x+1))           
            error = 0;
            
            BLOB_RIGHT = RIGHT_img(row-HALF_BLOB_y:row+HALF_BLOB_y, column_right-HALF_BLOB_x:column_right+HALF_BLOB_x);
            BLOB_LEFT = int8(BLOB_LEFT);
            BLOB_RIGHT = int8(BLOB_RIGHT);
            difference = (BLOB_LEFT - BLOB_RIGHT);
            
            % Uncomment for Sum of squared difference
            difference = difference.^2;
            % Uncomment for sum of absolute differences
%             difference = abs(difference);
            number_pixels = BLOB_SIZE_y * BLOB_SIZE_x;
            error = sum(difference, 'all');
            if error < min_error
                min_error = error;
                right_index = column_right;
            end
        end
        disparity_array(row, column) = abs(right_index - column);
    end
end

%% RESULTS
fprintf('\n')

%% DISPLAY RESULTS

% Ground truth
ax1 = subplot(1,2,1);
imshow(GROUND_TRUTH)

% Ground truth
ax2 = subplot(1,2,2);
imshow(disparity_array)

fprintf('\nEND\n');
