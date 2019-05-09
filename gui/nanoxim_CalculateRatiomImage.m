function [ratio_img, bw_pixpass, pix_st] = nanoxim_CalculateRatiomImage(bck_img, ...
    for_img,rgb_sig_thresh, numerator_chan_ind, denominator_chan_ind)

% Get back ground and forground images for each values (assigned to
% variables for clarity)
for_denominator = for_img(:,:,denominator_chan_ind);
back_denominator = bck_img(:,:,denominator_chan_ind);

for_numerator = for_img(:,:,numerator_chan_ind);
back_numerator = bck_img(:,:,numerator_chan_ind);


% background subtraction 
backsub_numerator = for_numerator - back_numerator;
backsub_denominator = for_denominator - back_denominator;

% Calculate ratio image
ratio_img = double(backsub_numerator)./double(backsub_denominator);

% Filter only valid pixels
bw_pixpass = backsub_numerator>rgb_sig_thresh(3) & backsub_denominator>rgb_sig_thresh(1); 
% keyboard
fprintf('\tFraction of Image with Valid Data: %.2f\n',sum(bw_pixpass(:))/numel(bw_pixpass))

% keyboard

pix_st.denominator_back_vals = double(back_denominator(bw_pixpass));
pix_st.denominator_for_vals = double(for_denominator(bw_pixpass));
pix_st.denominator_backsub_vals = double(backsub_denominator(bw_pixpass));

pix_st.numerator_back_vals = double(back_numerator(bw_pixpass));
pix_st.numerator_for_vals = double(for_numerator(bw_pixpass));
pix_st.numerator_backsub_vals = double(backsub_numerator(bw_pixpass));





% keyboard
