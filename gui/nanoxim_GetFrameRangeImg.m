function img = nanoxim_GetFrameRangeImg(vid_handle, frame_range)


if isa(vid_handle,'VideoReader')
    bck_zimg = zeros(vid_handle.Height,vid_handle.Width,3,abs(diff(frame_range))+1,'uint8');
    
    % If video is not loaded in ram, load specified frames into 4D zstack
    vid_handle.CurrentTime=(frame_range(1)-1)/vid_handle.FrameRate;
    
    for t=1:abs(diff(frame_range))+1
        bck_zimg(:,:,:,t)=readFrame(vid_handle);
    end
    
else
    % If video loaded in RAM, extract frames
    bck_zimg = vid_handle(:,:,:,frame_range(1):frame_range(2));
end

img = bck_zimg;

% keyboard