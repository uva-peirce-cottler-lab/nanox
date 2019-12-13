function gui_UpdateRatiomImage(target_handle, handles)
dprintf('Updating Ratiometric Image');
handles = guidata(handles.figure_nanoxim);
if getappdata(0,'calculating_flag'); return; end
 
% Get ROI mask from memory (load from disk done when video loaded
bw_roi_ratiom = getappdata(handles.figure_nanoxim,'bw_roi_ratiom');
if isempty(bw_roi_ratiom); bw_roi_ratiom = true(size(ratio_img)); end

% Get pix pass
bw_pix_pass = getappdata(handles.figure_nanoxim,'bw_pix_pass');
% ROI is union of [ROI and pixpass]
bw_roi_pix_pass = bw_pix_pass & bw_roi_ratiom;

% Channel Specific output
st = getappdata(handles.figure_nanoxim,'pix_vals_st');
if isempty(st); return; end
% Must apply passed pixels and ROI for denominator and numerator pixel
% values
filtpix = @(x) x(bw_roi_pix_pass);
% Calculate ratio image based on channel specific output
ratio_img = st.numerator_backsub_vals ./ st.denominator_backsub_vals;

mean(filtpix(st.numerator_backsub_vals ./ st.denominator_backsub_vals))

% Displaying a heatmap image with a color bar and black with excluded
% pixels requires an extensive hack

 
% Initialize colormap jet and add black to base
cmap = colormap(target_handle, jet);
colormap(target_handle, vertcat([0 0 0], cmap));

% Get range for colorbar range
color_range = [str2double(get(handles.edit_ratiom_low,'String')) ...
    str2double(get(handles.edit_ratiom_high,'String'))];
color_slice = abs(diff(color_range))./64;


ratio_img_disp = ratio_img;
ratio_img_disp(~bw_roi_pix_pass)=-10*color_slice;
imshow(ratio_img_disp,'Parent',target_handle);

% Update caxis handles
caxis(target_handle,color_range - [10*color_slice 0]);

cmap = colormap(target_handle, jet);
colormap(target_handle, vertcat([0 0 0], cmap));

h = colorbar(target_handle);

% Do not display bottom of color bar range
ylim = get(h,'ylim');
set(h,'ylim',color_range);

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