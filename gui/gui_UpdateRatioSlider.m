function gui_UpdateRatioSlider(handles)


% Get ratio image
ratio_img = getappdata(handles.figure_nanoxim,'ratio_img');
bw_pix_pass = getappdata(handles.figure_nanoxim,'bw_pix_pass');

% Determine max pixel value from pixels that pass validation and exist
% within ROI
max_val = ceil(max(ratio_img(bw_pix_pass)));
if isempty(max_val); error(['Max value of Ratiometric is empty:' ...
        ' likely there is no signal present after background subtraction']);
end
% Set range of slider values
handles.rslider_ratiom.setMaximum(max_val);
handles.rslider_ratiom.setMinimum(0);
handles.rslider_ratiom.setLabelTable([]);
handles.rslider_ratiom.setMajorTickSpacing(ceil(max_val/10));

% Set tick position/values
handles.rslider_ratiom.setHighValue(max_val);
handles.rslider_ratiom.setLowValue(0);
set(handles.edit_ratiom_max,'String',num2str(ceil(max_val)))

guidata(handles.figure_nanoxim,handles);
end