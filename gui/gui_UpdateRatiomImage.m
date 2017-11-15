function gui_UpdateRatiomImage(target_handle, handles)
dprintf('Updating Ratiometric Image');
% keyboard    
handles = guidata(handles.figure_nanoxim);
% target_handle = handles.axes_ratiom;

% Get image
ratio_img = getappdata(handles.figure_nanoxim,'ratio_img');
if isempty(ratio_img); return; end
 
% Get ROI mask
bw_ratiom_for_roi = getappdata(handles.figure_nanoxim,'bw_ratiom_for_roi');
if isempty(bw_ratiom_for_roi)
    bw_ratiom_for_roi= true(size(ratio_img));
end

% Get Pix pass
bw_pix_pass = getappdata(handles.figure_nanoxim,'bw_pix_pass');

% ROI is union of ROI and pixpass
bw_roi_pix_pass = bw_pix_pass & bw_ratiom_for_roi;


% Displaying a heatmap image with a color bar and black with excluded
% pixels requires an extensive hack


% Initialize colormap jet and add black to base
cmap = colormap(target_handle, jet);
colormap(target_handle, vertcat([0 0 0], cmap));


color_range = [handles.rslider_ratiom.getLowValue() ...
    handles.rslider_ratiom.getHighValue()];
color_slice = abs(diff(color_range))./64;

ratio_img_disp = ratio_img;
ratio_img_disp(~bw_roi_pix_pass)=-10*color_slice;
imshow(ratio_img_disp,'Parent',target_handle);

% Update caxis handles
caxis(target_handle,color_range - [10*color_slice 0]);

cmap = colormap(target_handle, jet);
colormap(target_handle, vertcat([0 0 0], cmap));


h=colorbar(target_handle);

% Do not display bottom of color bar range
ylim = get(h,'ylim');
set(h,'ylim',[0 ylim(2)]);

out_str = sprintf('Output: %0.4f Pixels Used, RatioM: %.3f +- %.3f',...
    sum(bw_roi_pix_pass(:))./numel(bw_roi_pix_pass),...
    mean(ratio_img(bw_roi_pix_pass)),std(ratio_img(bw_roi_pix_pass)));


% Display output
set(handles.text_ratiom_output,'String',out_str);
dprintf(out_str);

% keyboard 
end