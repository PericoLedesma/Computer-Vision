%% Lab IV: Shape from Stereo
clear all
clc
close all
fprintf('Start of the script');

%% CONTROL PARAMETERS
ACCURATE_IMAGE = 0; % 1 to use the image of the webpage and not the one provided in doddle

IMG_COLUMN = 330; % Select the X value of the blob in the left image
IMG_ROW = 90;  % Select the Y value of the blob in the left image
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

fprintf('\nSize of the image(%d %d)', ysize, xsize);

%% LOOP
fprintf('\nRunning over the x axis to match blobs.\n');

min_error = 10^10;
HALF_BLOB_x= BLOB_SIZE_x/2;
HALF_BLOB_y= BLOB_SIZE_y/2;

BLOB_LEFT = LEFT_img(IMG_ROW-HALF_BLOB_y:IMG_ROW+HALF_BLOB_y,IMG_COLUMN-HALF_BLOB_x:IMG_COLUMN+HALF_BLOB_x);

for column_right = (HALF_BLOB_x+1):(xsize-(HALF_BLOB_x+1))
    if column_right > (xsize -2)
        fprintf('\nOut of X boundaries')
        break
    end
    if (IMG_ROW+BLOB_SIZE_y) > (ysize -2)
        fprintf('\nOut of Y boundaries')
        break
    end
    
    error = 0;
    
    BLOB_RIGHT = RIGHT_img(IMG_ROW-HALF_BLOB_y:IMG_ROW+HALF_BLOB_y,column_right-HALF_BLOB_x:column_right+HALF_BLOB_x);
    BLOB_LEFT = int8(BLOB_LEFT);
    BLOB_RIGHT = int8(BLOB_RIGHT);
    difference = (BLOB_LEFT - BLOB_RIGHT);
    
    % Uncomment for Sum of squared difference
    %difference = difference.^2;
    % Uncomment for sum of absolute differences
    difference = abs(difference);
    number_pixels = BLOB_SIZE_y * BLOB_SIZE_x;
    error = sum(difference, 'all');
    if error < min_error
        min_error = error;
        right_index = column_right;
    end
end

%% GROUND TRUTH
disparity = GROUND_TRUTH(IMG_ROW,IMG_COLUMN);

%% RESULTS

fprintf('\nBlob center in left image in the (%d, %d)', IMG_ROW, IMG_COLUMN);
fprintf('\n X-AXIS value left image: %d', IMG_COLUMN);
fprintf('\n X-AXIS value right image: %d', right_index);
fprintf('\nDisparaty: %d', (right_index - IMG_COLUMN));
fprintf('\nReal disparaty: %d', disparity);
fprintf('\nError: %d', min_error);

fprintf('\n')

%% DISPLAY RESULTS

fprintf('\nDisplaying plot\n')
% Right image
left = insertShape(LEFT_img,'Rectangle',[(IMG_COLUMN-HALF_BLOB_x) (IMG_ROW-HALF_BLOB_y) BLOB_SIZE_x BLOB_SIZE_y],'LineWidth',5);
ax3 = subplot(1,3,1);
imshow(left)


% Left image
right = insertShape(RIGHT_img,'Rectangle',[(right_index-HALF_BLOB_x) (IMG_ROW-HALF_BLOB_y) BLOB_SIZE_x BLOB_SIZE_y],'LineWidth',5);
ax4 = subplot(1,3,2);
imshow(right)


% Ground truth
imag2 = insertShape(GROUND_TRUTH,'Rectangle',[IMG_COLUMN IMG_ROW 1 1],'LineWidth',10);
ax5 = subplot(1,3,3);
imshow(imag2)
