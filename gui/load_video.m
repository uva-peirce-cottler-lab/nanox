function [rgb_vid, rgb_mean,vid_handle] = load_video(current_mv_path)


% read video
vid_handle = VideoReader(current_mv_path);
num_frames = ceil(vid_handle.Duration * vid_handle.FrameRate);
% keyboard
rgb_vid = zeros(vid_handle.Height,vid_handle.Width,3,num_frames,'uint8');
% keyboard
rgb_mean = zeros(num_frames,3);

% keyboard

tic
hw = waitbar(0,'Loading Video...');
for t=1:num_frames
    rgb_vid(:,:,:,t)=readFrame(vid_handle);
    rgb_mean(t,1:3) = squeeze(mean(mean(rgb_vid(:,:,:,t),2),1)); 
    waitbar(t/num_frames,hw);
end
close(hw);
toc






end