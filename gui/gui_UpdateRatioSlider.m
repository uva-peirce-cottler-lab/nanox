function gui_UpdateRatioSlider(handles)

ratio_img = getappdata(handles.figure_nanoxim,'ratio_img');
bw_pix_pass = getappdata(handles.figure_nanoxim,'bw_pix_pass');
% 
% caxis([min(ratio_img(bw_pix_pass)) max(ratio_img(bw_pix_pass))]);

max_val = ceil(max(ratio_img(bw_pix_pass)));

% Set range of slider values
handles.rslider_ratiom.setMaximum(max_val);
handles.rslider_ratiom.setMinimum(0);
handles.rslider_ratiom.setLabelTable([]);
handles.rslider_ratiom.setMajorTickSpacing(ceil(max_val/10));
% Tick Marks

% Set tick position/values
handles.rslider_ratiom.setHighValue(max_val);
handles.rslider_ratiom.setLowValue(0);

set(handles.edit_ratiom_max,'String',num2str(ceil(max_val)))

end