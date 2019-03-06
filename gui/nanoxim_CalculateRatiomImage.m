function [ratio_img, bw_pixpass, pix_st] = nanoxim_CalculateRatiomImage(bck_img, ...
    for_img,rgb_sig_thresh)

% Get back ground and forground images for each values (assigned to
% variables for clarity)
for_red = for_img(:,:,1);
back_red = bck_img(:,:,1);

for_blue = for_img(:,:,3);
back_blue = bck_img(:,:,3);


% background subtraction 
backsub_blue = for_blue - back_blue;
backsub_red = for_red - back_red;

% Calculate ratio image
ratio_img = double(backsub_blue)./double(backsub_red);

% Filter only valid pixels
bw_pixpass = backsub_blue>rgb_sig_thresh(3) & backsub_red>rgb_sig_thresh(1); 
% keyboard
fprintf('\tFraction of Image with Valid Data: %.2f\n',sum(bw_pixpass(:))/numel(bw_pixpass))

% keyboard

pix_st.red_back_vals = double(back_red(bw_pixpass));
pix_st.red_for_vals = double(for_red(bw_pixpass));
pix_st.red_backsub_vals = double(backsub_red(bw_pixpass));

pix_st.blue_back_vals = double(back_blue(bw_pixpass));
pix_st.blue_for_vals = double(for_blue(bw_pixpass));
pix_st.blue_backsub_vals = double(backsub_blue(bw_pixpass));





% keyboard
