function varargout = nanoxim(varargin)
% NANOXIM MATLAB code for nanoxim.fig
%      NANOXIM, by itself, creates a new NANOXIM or raises the existing
%      singleton*.
%
%      H = NANOXIM returns the handle to a new NANOXIM or the handle to
%      the existing singleton*.
%
%      NANOXIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NANOXIM.M with the given input arguments.
%
%      NANOXIM('Property','Value',...) creates a new NANOXIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nanoxim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nanoxim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nanoxim

% Last Modified by GUIDE v2.5 25-Sep-2017 22:23:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nanoxim_OpeningFcn, ...
                   'gui_OutputFcn',  @nanoxim_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before nanoxim is made visible.
function nanoxim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nanoxim (see VARARGIN)

% Choose default command line output for nanoxim
handles.output = hObject;

% Create a background range slider 
pos = get(handles.slider_frame_ind,'position');
[handles.rslider_bck_hcomp, handles.rslider_bck_hcont, handles.rslider_bck] = ...
    gui_RangeSlider([1 100],[pos(1) pos(2)-45 pos(3) 40],'BCK','horizontal',handles);
% Create a forground range slider 
[handles.rslider_bck_hcomp, handles.rslider_bck_hcont, handles.rslider_for] = ...
    gui_RangeSlider([1 100],[pos(1) pos(2)-85 pos(3) 40],'FOR','horizontal',handles);
% Ratiometrix threshold slider
pos = get(handles.uipanel_ratiom,'position');
[handles.rslider_ratiom_hcomp, handles.rslider_ratiom_hcont, handles.rslider_ratiom] = ...
    gui_RangeSlider([0 100],[pos(1)+pos(3) pos(2) 40 pos(4)],'RAT','vertical',handles);

% Update handles structure
guidata(hObject, handles);

% Add continuous callback for video index slider
hListener = addlistener(handles.slider_frame_ind,'ContinuousValueChange',@slider_frame_ind_Callback);
setappdata(handles.slider_frame_ind,'sliderListener',hListener)



% UIWAIT makes nanoxim wait for user response (see UIRESUME)
% uiwait(handles.figure_nanoxim);


% --- Outputs from this function are returned to the command line.
function varargout = nanoxim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_frame_ind_Callback(hObject, eventdata, handles)
% hObject    handle to slider_frame_ind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% keyboard
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = guidata(hObject);
vid_handle = getappdata(handles.figure_nanoxim,'vid_handle');

slider_val = get(handles.slider_frame_ind,'Value');
vid_handle.CurrentTime=(slider_val-1)/vid_handle.FrameRate;
img=readFrame(vid_handle);

set(handles.text_frame_ind,'String',sprintf('%0.f',slider_val));
imshow(img,'Parent',handles.axes_img);
% keyboard  


% --- Executes during object creation, after setting all properties.
function slider_frame_ind_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_frame_ind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton_load_video.
function pushbutton_load_video_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
browse_path = getappdata(handles.figure_nanoxim,'browse_path');

% Get list of movies
mv_list = get(handles.listbox_mv_names,'String');

current_mv_path = [browse_path '/' mv_list{get(handles.listbox_mv_names,'Value')}];
setappdata(handles.figure_nanoxim,'current_mv_path',current_mv_path);

% read video
v = VideoReader(current_mv_path);
% Store video data
setappdata(handles.figure_nanoxim,'vid_dim',...
    [v.Height,v.Width,3,v.Duration * v.FrameRate]);
setappdata(handles.figure_nanoxim,'vid_handle',v);

% show FIrst Image
imshow(readFrame(v), 'Parent', handles.axes_img);

set(handles.text_img,'String', sprintf('Input: %.fx%.f',v.Height,v.Width)); 

% Initialize sliders to correc tange
gui_UpdateSliderMax(handles,v.Duration * v.FrameRate)

% --- Executes on selection change in listbox_mv_names.
function listbox_mv_names_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_mv_names (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_mv_names contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_mv_names


% --- Executes during object creation, after setting all properties.
function listbox_mv_names_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_mv_names (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_browse.
function pushbutton_browse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

browse_path = pwd;
% If previous browse path is saved to disk, load and use that
temp_data_path = getappdata(0, 'temp_data_path');
if ~isempty(dir([temp_data_path '/nanoxim_gui.mat']))
    st = load([temp_data_path '/nanoxim_gui.mat']);
    if isfield(st,'browse_path')
        browse_path = st.browse_path;
    end
else; st=struct();
end
% keyboard
browse_path = uigetdir(browse_path,'Select Movie Folder');
if browse_path==0; return; end

% Save path to memory and file system
setappdata(handles.figure_nanoxim,'browse_path',browse_path);
st.browse_path = browse_path;
save([temp_data_path '/nanoxim_gui.mat'],'-struct','st');


% Get list of movies
mv_list = dir([browse_path '/*.*']);
mv_names = {mv_list(:).name};
bv = cellfun(@(x) ~isempty(regexpi(x,'(\.mov)|(\.avi)','once')),mv_names);
set(handles.listbox_mv_names,'String',mv_names(bv)');
% keyboard


% --- Executes on button press in pushbutton_calculate.
function pushbutton_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dprintf('Claculating Ratiometric Image');

% Get background range
bck_frame_range = [handles.rslider_bck.getLowValue() handles.rslider_bck.HighValue()];
for_frame_range = [handles.rslider_for.getLowValue() handles.rslider_for.HighValue()];

% Load background video
vid_handle = getappdata(handles.figure_nanoxim,'vid_handle');

blur_rad = str2double(get(handles.edit_blur_rad,'String'));

rgb_thresh = [str2double(get(handles.edit_red_threshold,'String')) 0 ...
    str2double(get(handles.edit_blue_threshold,'String'))];


[ratio_img, bw_pix_pass] = nanoxim_CalculateRatiomImage(vid_handle, ...
    bck_frame_range, for_frame_range, rgb_thresh, blur_rad);
setappdata(handles.figure_nanoxim,'ratio_img',ratio_img);
setappdata(handles.figure_nanoxim,'bw_pix_pass',bw_pix_pass);

% keyboard
gui_UpdateRatioSlider(handles);
gui_UpdateRatiomImage(handles.axes_ratiom,handles);






% --- Executes on slider movement
function slider_ratiom_range_Callback(hObject, eventdata, handles)
% hObject    handle to slider_ratiom_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_ratiom_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_ratiom_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton_save_metadata.
function pushbutton_save_metadata_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_metadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_add_roi.
function pushbutton_add_roi_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_add_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% keyboard
if strcmp(get(hObject,'String'),'Add ROI')
    poly_ratiom_for_roi = impoly(handles.axes_ratiom);
    setappdata(handles.figure_nanoxim,'vert_ratiom_for_roi',...
        poly_ratiom_for_roi.getPosition);
    bw_ratiom_for_roi = imresize(poly_ratiom_for_roi.createMask(),...
        size(getappdata(handles.figure_nanoxim, 'ratio_img')));
    setappdata(handles.figure_nanoxim,'bw_ratiom_for_roi',...
        bw_ratiom_for_roi);
    delete(poly_ratiom_for_roi);
else % Delete ROI
    handle_ratiom_for_roi = getappdata(handles.figure_nanoxim, 'handle_ratiom_for_roi');
    try delete(handle_ratiom_for_roi); catch; fprintf('Handle DNE\n'); end
    setappdata(handles.figure_nanoxim,'vert_ratiom_for_roi', []);
     setappdata(handles.figure_nanoxim,'bw_ratiom_for_roi', []);
    setappdata(handles.figure_nanoxim, 'handle_ratiom_for_roi',[]);
    set(handles.pushbutton_add_roi,'String','Add ROI');
    set(handles.pushbutton_show_roi,'String','Show ROI');
end

gui_UpdateRatiomImage(handles.axes_ratiom, handles);


% --- Executes on button press in pushbutton_show_roi.
function pushbutton_show_roi_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_show_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vert_ratiom_for_roi = getappdata(handles.figure_nanoxim,'vert_ratiom_for_roi');

if isempty(vert_ratiom_for_roi); return; end

if strcmp(get(hObject,'String'),'Show ROI')
    handle_ratiom_for_roi= impoly(handles.axes_ratiom, vert_ratiom_for_roi);
    setappdata(handles.figure_nanoxim, 'handle_ratiom_for_roi',handle_ratiom_for_roi);
    set(handles.pushbutton_add_roi,'String','Delete ROI');
    set(handles.pushbutton_show_roi,'String','Hide ROI');
else % Hide ROI
    handle_ratiom_for_roi = getappdata(handles.figure_nanoxim, 'handle_ratiom_for_roi');
    try delete(handle_ratiom_for_roi); catch; fprintf('Handle DNE\n'); end
    set(handles.pushbutton_add_roi,'String','Add ROI');
    set(handles.pushbutton_show_roi,'String','Show ROI');
    
end
gui_UpdateRatiomImage(handles.axes_ratiom,handles);


% --- Executes on button press in pushbutton_save_ratiom.
function pushbutton_save_ratiom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_ratiom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

current_mv_path = getappdata(handles.figure_nanoxim, 'current_mv_path');
% Get Image Name
h=figure;
ha = gca;
gui_UpdateRatiomImage(ha, handles);
saveas(ha,[current_mv_path '.png']);
close(h);





function edit_blur_rad_Callback(hObject, eventdata, handles)
% hObject    handle to edit_blur_rad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_blur_rad as text
%        str2double(get(hObject,'String')) returns contents of edit_blur_rad as a double


% --- Executes during object creation, after setting all properties.
function edit_blur_rad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_blur_rad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_blue_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_blue_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_blue_threshold as text
%        str2double(get(hObject,'String')) returns contents of edit_blue_threshold as a double


% --- Executes during object creation, after setting all properties.
function edit_blue_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_blue_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_red_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_red_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_red_threshold as text
%        str2double(get(hObject,'String')) returns contents of edit_red_threshold as a double


% --- Executes during object creation, after setting all properties.
function edit_red_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_red_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
