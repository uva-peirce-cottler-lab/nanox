function nanoxim_RangeSliderEdit_Callback(hObject, eventdata, handles)

% keyboard
% regexp(
reg_cell = regexp(get(hObject,'Tag'),'_([a-zA-Z]+)_([a-zA-Z]+)','tokens','once');

% reg_cell

eval_str = ['handles.rslider_' reg_cell{1,1} '.set' ...
    [upper(reg_cell{1,2}(1)) reg_cell{1,2}(2:end)]  ...
    'Value(str2double(get(hObject,''String'')));'];


gui_UpdateRatiomImage(handles.axes_ratiom,handles);

% eval(eval_str);
% keyboard
% handles.(['rslider_' reg_cell{1,2}]).setHighValue(str2double(get(hObject,'String')));

end