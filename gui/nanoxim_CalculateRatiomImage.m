function [ratio_img, bw_pixpass] = nanoxim_CalculateRatiomImage(bck_img, ...
    for_img,rgb_sig_thresh)


% background subtraction 
bs_blue = for_img(:,:,3) - bck_img(:,:,3);
bs_red = for_img(:,:,1) - bck_img(:,:,1);

% Calculate ratio image
ratio_img = double(bs_blue)./double(bs_red);

% Filter only valid pixels
bw_pixpass = bs_blue>rgb_sig_thresh(3) & bs_red>rgb_sig_thresh(1); 
% keyboard
fprintf('\tFraction of Image with Valid Data: %.2f\n',sum(bw_pixpass(:))/numel(bw_pixpass))

% keyboard
