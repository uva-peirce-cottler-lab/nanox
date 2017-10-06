function gui_UpdateSliderMax(handles,num_frames)


set(handles.slider_frame_ind,'Max', num_frames)
set(handles.slider_frame_ind, 'SliderStep', [1/(num_frames-1) , 1/(num_frames-1) ]);

handles.rslider_bck.setMaximum(num_frames);
% handles.rslider_bck.setLabel
handles.rslider_bck.setMajorTickSpacing(round(num_frames/30));




handles.rslider_for.setMaximum(num_frames);
handles.rslider_for.setMajorTickSpacing(round(num_frames/20));
% handles.rslider_for.setPaintLabels(false);
% handles.rslider_for.setPaintTicks(false);
% handles.rslider_for.setPaintLabels(false);
% 
% handles.rslider_for.setPaintLabels(true);
% handles.rslider_for.setPaintTicks(true);
% handles.rslider_for.setPaintLabels(true);
% handles.rslider_for.updateUI();
% handles.
% handles.rslider_for.setMinorTickSpacing(round(num_frames/15));

keyboard

end