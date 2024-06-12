%==========================================================================
%                 KYMOGRAPH WITH LASER BAR AND RULER
%..........................................................................
% - Joins laser activation bar and/or ruler to a kymograph. 
% - Rotates kymograph % to make horizontal if source kymograph is vertical.
%
% - Requires 3D matrix image. Open and save png in MS paint if PNG is 1D. 
%   This will convert PNG to colour
%
%           Created: 6/11/2024, Updated: 6/12/2924, Tim John
%--------------------------------------------------------------------------


%---------------------- Set these variables -------------------------------
path_main_image = "18v2.png";
path_laser_image = "18ch2v2.png";
n_lines_per_frame = 180;
frame_time = 100;           % in ms
laser_on_high = -1;          % Change to -1 if value goes down on laser ON

ruler_tick_length = 20;
ruler_tick_interval = 100;  % in ms
minor_ticks_per_major_tick = 4;
show_laser = true;
show_ruler = true;
%--------------------------------------------------------------------------


% Computed variables
circle_time = frame_time/n_lines_per_frame;
%--------------------------------------------------------------------------

img_main = imread(path_main_image);
img_laser = imread(path_laser_image);

% Make horizontal
sz = size(img_main);
if(sz(2) == n_lines_per_frame)
    img_main = imrotate(img_main,90);
    img_laser = imrotate(img_laser,90);
end

if(laser_on_high == -1)
    img_laser = imcomplement(img_laser);
end

% Make green
img_laser(:,:,1) = 0;
img_laser(:,:,3) = 0;

% Ruler at bottom
ruler = 244*ones(ruler_tick_length,length(img_main),3);
ruler(:,1:ruler_tick_interval/circle_time:end,:) = 0;     % Major tick
ruler(:,2:ruler_tick_interval/circle_time:end,:) = 0;     % Additional tick to look thick
ruler(1:2:end,1:ruler_tick_interval/...
    circle_time/minor_ticks_per_major_tick:end,:) = 100;  % Minor dotted tick

if(show_laser)
    ruler(1:2,:,:) = 0;
else
    ruler(end-1:end,:,:) = 0;
end

% Join laser/ruler to main kymograph
if(show_ruler && show_laser)
    imcomb = cat(1, ruler, img_main, img_laser(1:20,:,:));   % Both laser & ruler
elseif(~show_ruler && show_laser)
    imcomb = cat(1, img_main, img_laser(1:20,:,:));          % Only laser
elseif(show_ruler && ~show_laser)
    imcomb = cat(1, img_main, ruler);                        % Only ruler
end

figure
imshow(imcomb(:,17500:20000,:));
% imshow(imcomb);






