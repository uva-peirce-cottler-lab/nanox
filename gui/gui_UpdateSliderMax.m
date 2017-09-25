function gui_UpdateSliderMax(handles,num_frames)


set(handles.slider_frame_ind,'Max', num_frames)
set(handles.slider_frame_ind, 'SliderStep', [1/(num_frames-1) , 1/(num_frames-1) ]);

handles.rslider_bck.setMaximum(num_frames);
handles.rslider_for.setMaximum(num_frames);




end