function gui_UpdateSliderMax(handles,num_frames)


set(handles.slider_frame_ind,'Max', num_frames)
set(handles.slider_frame_ind, 'SliderStep', [1/(num_frames-1) , 1/(num_frames-1) ]);

handles.rslider_bck.setMaximum(num_frames);
% handles.rslider_bck.setLabel
handles.rslider_bck.setLabelTable([]);
handles.rslider_bck.setMajorTickSpacing(round(num_frames/10));




handles.rslider_for.setMaximum(num_frames);
handles.rslider_for.setLabelTable([]);
handles.rslider_for.setMajorTickSpacing(round(num_frames/10));


% keyboard

end