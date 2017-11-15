function img = nanoxim_GetFrameRangeImg(vid_handle, frame_range, blur_rad_pix)


if isa(vid_handle,'VideoReader')
    % If video is not loaded in ram, load specified frames into 4D zstack
    vid_handle.CurrentTime=(frame_range(1)-1)/vid_handle.FrameRate;
    bck_zimg = zeros(vid_handle.Height,vid_handle.Width,3,abs(diff(frame_range))+1,'uint8');
    for t=1:abs(diff(frame_range))
        bck_zimg(:,:,:,t)=readFrame(vid_handle);
    end
    
else
    % If video loaded in RAM, extract frames
    bck_zimg = vid_handle(:,:,:,frame_range(1):frame_range(2));
end
img = imfilter(mean(bck_zimg,4),fspecial('gaussian',blur_rad_pix, 10*4096),'symmetric');