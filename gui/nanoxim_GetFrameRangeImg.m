function img = nanoxim_GetFrameRangeImg(vid_handle, frame_range, blur_rad_pix);


% Background image: Locate first frame,load specififed frames after
vid_handle.CurrentTime=(frame_range(1)-1)/vid_handle.FrameRate;
bck_zimg = zeros(vid_handle.Height,vid_handle.Width,3,abs(diff(frame_range))+1,'uint8');
for t=1:abs(diff(frame_range))
    bck_zimg(:,:,:,t)=readFrame(vid_handle);
end
img = imfilter(max(bck_zimg,[],4),fspecial('gaussian',blur_rad_pix, 10*4096),'symmetric');