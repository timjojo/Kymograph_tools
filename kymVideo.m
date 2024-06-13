%==========================================================================
%                    KYMOGRAPH ROLLING VIDEO
%..........................................................................
% - Generates a rolling kymograph video 
% - Rotates kymograph % to make horizontal if source kymograph is vertical.
%
%
%           Created: 6/11/2024, Updated: 6/13/2924, Tim John
%--------------------------------------------------------------------------


%---------------------- Set these variables -------------------------------
path_main_image = "18.png";
path_laser_image = "18ch2.png";
n_lines_per_frame = 180;
frame_time = 100;           % in ms
laser_on_high = -1;         % Change to -1 if value goes down on laser ON

frame_width = 600;          % Frame height equals n_lines_per_frame
start_index = 12000;                 
end_index = 22000;
%--------------------------------------------------------------------------


% Computed variables
circle_time = frame_time/n_lines_per_frame;
%--------------------------------------------------------------------------

[img_main, map_main] = imread(path_main_image);
[img_laser, map_laser] = imread(path_laser_image);

if(~isempty(map_main))
    img_main = ind2rgb(img_main, map_main);
end

sz_laser = size(img_laser);
if(length(sz_laser) ~=3)
    img_laser = cat(3, img_laser, img_laser, img_laser);
end

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

sz = size(img_main);
img_emptyBar = 0*ones(20,sz(2),sz(3));  % For seconds counter

% Join laser to main kymograph
img_laser = im2double(img_laser);      % Make data types uniform for proper concatenation
imcomb = cat(1, img_main, img_laser(1:10,:,:), img_emptyBar);
% figure
imshow(imcomb(:,12000:22000,:));


%%
[filepath,name,ext] = fileparts(path_main_image);
v = VideoWriter(strcat(name, '_video.avi'));
v.Quality = 95;
v.FrameRate = 300;
open(v);

pos = [0,186];                  % location of seconds counter
for(i=start_index:end_index)
    frame = imcomb(:,i:i+frame_width-1,:);
    txt = [num2str((i-start_index)*0.55/1000,'%.2f'), ' s'];
    frame = insertText(frame,pos, txt, Font = "Arial Bold", Fontsize = 18,  FontColor = "white", BoxOpacity=0);
    % imshow(frame)
    % pause()
    writeVideo(v, frame);
end
close(v);



