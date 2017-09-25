function gui_UpdateRatiomImage(rangeSlider, eventdata, handles)
% keyboard 
handles = guidata(handles.figure_nanoxim);
  
caxis(handles.axes_ratiom,[rangeSlider.getLowValue() rangeSlider.getHighValue()]);


end