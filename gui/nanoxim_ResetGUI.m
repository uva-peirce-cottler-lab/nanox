function nanoxim_ResetGUI(handles)

% Clear all Variables
st = getappdata(handles.figure_nanoxim);

f = fields(st);
for n=6:numel(f)
    if ~strcmp(f{n},'browse_path')
        setappdata(handles.figure_nanoxim, f{n},[]);
    end
end

% Clear axes,
cla(handles.axes_img);
cla(handles.axes_ratiom);
colorbar(handles.axes_ratiom,'off')

% Clear Listboxes, Edit boxes
set(handles.edit_bck_img_path,'String','');
set(handles.edit_for_img_path,'String','');
set(handles.text_ratiom_output,'String','Output:');

% Reset Sliders
handles.rslider_bck.setMaximum(100);
handles.rslider_bck.setMinimum(1);
handles.rslider_bck.setHighValue(2);
handles.rslider_bck.setLowValue(1);

handles.rslider_for.setMaximum(100);
handles.rslider_for.setMinimum(1);
handles.rslider_for.setHighValue(100);
handles.rslider_for.setLowValue(90);

handles.rslider_ratiom.setMaximum(1);
handles.rslider_ratiom.setMinimum(0);
handles.rslider_ratiom.setValue(1);
% keyboard
