function gui_UpdateRatiomImage(target_handle, handles)
dprintf('Updating Ratiometric Image');
handles = guidata(handles.figure_nanoxim);
set(handles.figure_nanoxim,'CurrentAxes',target_handle)
if getappdata(0,'calculating_flag'); return; end
set(target_handle,'Color','k');

% Channel Specific output
st = getappdata(handles.figure_nanoxim,'pix_vals_st');
if isempty(st); return; end
% Calculate ratio image based on channel specific output
ratio_img = st.numerator_backsub_vals ./ st.denominator_backsub_vals;

% Get ROI mask from memory (load from disk done when video loaded
bw_roi_ratiom = getappdata(handles.figure_nanoxim,'bw_roi_ratiom');
if isempty(bw_roi_ratiom); bw_roi_ratiom = true(size(ratio_img)); end

% Get pix pass
bw_pix_pass = getappdata(handles.figure_nanoxim,'bw_pix_pass');
% ROI is union of [ROI and pixpass]
bw_roi_pix_pass = bw_pix_pass & bw_roi_ratiom;

% Apply passed pixels and ROI for denominator and numerator pixel values
filtpix = @(x) x(bw_roi_pix_pass);

% Get range for colorbar range
color_range = [str2double(get(handles.edit_ratiom_low,'String')) ...
    str2double(get(handles.edit_ratiom_high,'String'))];

% Displaying a heatmap image with a color bar and black with excluded
% pixels requires an extensive hack

scaled_ratio_img = (ratio_img - color_range(1))/diff(color_range);
scaled_ratio_img(scaled_ratio_img>1)=1;


rgb_ratio = ind2rgb(im2uint8(scaled_ratio_img), jet(255));
rgb_ratio_passed = rgb_ratio;
rgb_ratio_passed(cat(3,~bw_roi_pix_pass,~bw_roi_pix_pass,~bw_roi_pix_pass)) = 0;
imshow(rgb_ratio_passed,'Parent',target_handle);

axes(target_handle);
colormap(jet);
caxis(color_range);
colorbar



% h=colorbar;
% cmap=[194 24 25;114 24 55;117 74 26;255 255 255];
% cmap=cmap/255;
% TickLabels={'Red Pepper','Green Pepper','Purple Cloth','White Garlic'};
% Ticks=linspace(0,1,numel(TickLabels)+1);Ticks=Ticks(2:end)-diff(Ticks)/2;
% colormap(cmap)
% h.TickLabels=TickLabels;
% h.Ticks=Ticks;
% 
% 
% imagesc(ratio_img, 'AlphaData', double(bw_roi_pix_pass), 'AlphaDataMapping', ...
%     'none', color_range);
% colorbar; axis image; axis off; 
% 
% 
% cmap = colormap(target_handle, jet);
% % colormap(target_handle, vertcat([0 0 0], cmap));
% h = colorbar(target_handle);
% 

% % Initialize colormap jet and add black to base
% cmap = colormap(target_handle, jet);
% colormap(target_handle, vertcat([0 0 0], cmap));
% 
% % Get range for colorbar range
% color_range = [str2double(get(handles.edit_ratiom_low,'String')) ...
%     str2double(get(handles.edit_ratiom_high,'String'))];
% color_slice = abs(diff(color_range))./64;
% 
% ratio_img_disp = ratio_img;
% ratio_img_disp(~bw_roi_pix_pass)=-10*color_slice;
% imshow(ratio_img_disp,'Parent',target_handle);
% 
% % Update caxis handles
% caxis(target_handle,color_range - [10*color_slice 0]);
% cmap = colormap(target_handle, jet);
% colormap(target_handle, vertcat([0 0 0], cmap));
% h = colorbar(target_handle);
% Do not display bottom of color bar range
% ylim = get(h,'ylim');
% set(h,'ylim',color_range);






% Channel index for top portion of ratio
chan_str = 'RGB';
numerator_label = get(get(handles.uibuttongroup_top,'SelectedObject'),'String');
% Channel index for bottom portion of ratio
denominator_label = get(get(handles.uibuttongroup_bot,'SelectedObject'),'String');


% Display output
out_str = sprintf('Ratiometric (%s/%s): %.3f +- %.3f, %0.3f Pixels Used from ROI',...
    numerator_label,denominator_label,...
    mean(ratio_img(bw_roi_pix_pass)),std(ratio_img(bw_roi_pix_pass)),...
    sum(bw_roi_pix_pass(:))./sum(bw_roi_ratiom(:)));
set(handles.text_ratiom_output,'String',out_str);


denominator_str = sprintf(['Denominator(%s): [backsub]: %.2f ' char(177) ' %.2f,  [fore]: %.2f ' char(177) ...
    ' %.2f,  [back]: %.2f ' char(177) ' %.2f'], denominator_label,...
    mean(filtpix(st.denominator_backsub_vals)), std(filtpix(st.denominator_backsub_vals)),...
    mean(filtpix(st.denominator_for_vals)), std(filtpix(st.denominator_for_vals)),...
    mean(filtpix(st.denominator_back_vals)), std(filtpix(st.denominator_back_vals)));
set(handles.denominator_output, 'String', denominator_str);

numerator_str = sprintf(['Numerator(%s): [backsub]: %.2f ' char(177) ' %.2f,  [fore]: %.2f ' char(177) ...
    ' %.2f,  [back]: %.2f ' char(177) ' %.2f'],numerator_label,...
    mean(filtpix(st.numerator_backsub_vals)), std(filtpix(st.numerator_backsub_vals)),...
    mean(filtpix(st.numerator_for_vals)), std(filtpix(st.numerator_for_vals)),...
    mean(filtpix(st.numerator_back_vals)), std(filtpix(st.numerator_back_vals)));
set(handles.numerator_output,'String',numerator_str);


dprintf(out_str);
dprintf(denominator_str);
dprintf(numerator_str);
% keyboard   
end