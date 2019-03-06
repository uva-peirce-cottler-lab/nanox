function gui_UpdateRatiomImage(target_handle, handles)
dprintf('Updating Ratiometric Image');
% keyboard    
handles = guidata(handles.figure_nanoxim);


% Get image
ratio_img = getappdata(handles.figure_nanoxim,'ratio_img');
if isempty(ratio_img); return; end
 
% Get ROI mask from memory (load from disk done when video loaded
bw_roi_ratiom = getappdata(handles.figure_nanoxim,'bw_roi_ratiom');
if isempty(bw_roi_ratiom)
    bw_roi_ratiom = true(size(ratio_img));
end

% Get Pix pass
bw_pix_pass = getappdata(handles.figure_nanoxim,'bw_pix_pass');

% ROI is union of ROI and pixpass
bw_roi_pix_pass = bw_pix_pass & bw_roi_ratiom;


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

% Display output
out_str = sprintf('Ratiometric (B/R): %.3f +- %.3f, %0.4f Pixels Used',...
    mean(ratio_img(bw_roi_pix_pass)),std(ratio_img(bw_roi_pix_pass)),...
    sum(bw_roi_pix_pass(:))./numel(bw_roi_pix_pass));
set(handles.text_ratiom_output,'String',out_str);


% Channel Specific output
st = getappdata(handles.figure_nanoxim,'pix_vals_st');
red_str = sprintf(['Rbs: %.2f ' char(177) ' %.2f,  Rf: %.2f ' char(177) ...
    ' %.2f,  Rb: %.2f ' char(177) ' %.2f'],...
    mean(st.red_backsub_vals), std(st.red_backsub_vals),...
    mean(st.red_for_vals), std(st.red_for_vals),...
    mean(st.red_back_vals), std(st.red_back_vals));
set(handles.red_output,'String',red_str);

blue_str = sprintf(['Bbs: %.2f ' char(177) ' %.2f,  Bf: %.2f ' char(177) ...
    ' %.2f,  Bb: %.2f ' char(177) ' %.2f'],...
    mean(st.blue_backsub_vals), std(st.blue_backsub_vals),...
    mean(st.blue_for_vals), std(st.blue_for_vals),...
    mean(st.blue_back_vals), std(st.blue_back_vals));
set(handles.blue_output,'String',blue_str);


dprintf(out_str);
dprintf(red_str);
dprintf(blue_str);

end