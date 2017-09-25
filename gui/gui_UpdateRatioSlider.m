function gui_UpdateRatioSlider(handles)

ratio_img = getappdata(handles.figure_nanoxim,'ratio_img');
bw_pix_pass = getappdata(handles.figure_nanoxim,'bw_pix_pass');

caxis([min(ratio_img(bw_pix_pass)) max(ratio_img(bw_pix_pass))]);

max_val = max(ratio_img(bw_pix_pass));

% Set range of slider values
handles.rslider_ratiom.setMaximum(max_val);
handles.rslider_ratiom.setMinimum(0);

% Set tick position/values
handles.rslider_ratiom.setHighValue(max_val);
handles.rslider_ratiom.setLowValue(0);



% handles.rslider_ratiom.setI
% set(handles.slider_frame_ind, 'SliderStep', [1/(max_val-1) , 1/(max_val-1) ]);


end