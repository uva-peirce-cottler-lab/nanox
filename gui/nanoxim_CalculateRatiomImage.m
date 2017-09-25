function [ratio_img, bw_pixpass] = nanoxim_CalculateRatiomImage(vid_handle, ...
    bck_frame_range, for_frame_range)

rgb_sig_thresh = [3 3 3];
blur_rad_pix = 50;

% slider_val = get(handles.slider_frame_ind,'Value');

% Background image: Locate first frame,load specififed frames after
vid_handle.CurrentTime=(bck_frame_range(1)-1)/vid_handle.FrameRate;
bck_zimg = zeros(vid_handle.Height,vid_handle.Width,3,abs(diff(bck_frame_range))+1,'uint16');
for t=1:abs(diff(bck_frame_range))
    bck_zimg(:,:,:,t)=readFrame(vid_handle);
end
bck_img = imfilter(max(bck_zimg,[],4),fspecial('gaussian',blur_rad_pix, 10*4096));


% Background image: Locate first frame,load specififed frames after
vid_handle.CurrentTime=(for_frame_range(1)-1)/vid_handle.FrameRate;
for_zimg = zeros(vid_handle.Height,vid_handle.Width,3,abs(diff(for_frame_range))+1,'uint16');
for t=1:abs(diff(for_frame_range))
    for_zimg(:,:,:,t)=readFrame(vid_handle);
end
for_img = imfilter(max(for_zimg,[],4),fspecial('gaussian',blur_rad_pix, 10*4096));

% background subtraction 
bs_blue = for_img(:,:,3) - bck_img(:,:,3);
bs_red = for_img(:,:,1) - bck_img(:,:,1);

% Calculate ratio image
ratio_img = double(bs_blue)./double(bs_red);

% Filter only valid pixels
bw_pixpass = bs_blue>rgb_sig_thresh(3) & bs_red>rgb_sig_thresh(1); 
% keyboard
fprintf('Fraction of Image with Valid Data: %.2f\n',sum(bw_pixpass(:))/numel(bw_pixpass))

% keyboard
