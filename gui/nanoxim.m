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

% Last Modified by GUIDE v2.5 24-Sep-2017 10:52:18

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
[handles.rslider_bck_hcomp, handles.rslider_bck_hcont, handles.rslider_bck] = gui_RangeSlider([1 100],...
    [pos(1) pos(2)-45 pos(3) 40],'BCK');
[handles.rslider_bck_hcomp, handles.rslider_bck_hcont, handles.rslider_for] = gui_RangeSlider([1 100],...
    [pos(1) pos(2)-85 pos(3) 40],'FOR');

% num2str(handles.rslider_bck.getLowValue())
% keyboard
% Create a foreground slider

% Remove tiicks from axes
set(handles.axes_img,'xtick',[]);
set(handles.axes_img,'xticklabel',[]);
set(handles.axes_img,'ytick',[]);
set(handles.axes_img,'yticklabel',[]);

% Update handles structure
guidata(hObject, handles);

% set(handles.figure_nanoxim,'Visible','on')
% Add a hold down value change callback to slider.
% jScrollBar = findjobj('property',{'Name','slider_frame_ind'});
% jScrollBar.AdjustmentValueChangedCallback = {@slider_frame_ind_Callback, handles};

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
image(readFrame(v), 'Parent', handles.axes_img);

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
mv_list = dir([browse_path '/*.avi']);
set(handles.listbox_mv_names,'String',{mv_list(:).name});


% --- Executes on button press in pushbutton_calculate.
function pushbutton_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get background range
bck_frame_range = [handles.rslider_bck.getLowValue() handles.rslider_bck.HighValue()];
for_frame_range = [handles.rslider_for.getLowValue() handles.rslider_for.HighValue()];

% Load background video
vid_handle = getappdata(handles.figure_nanoxim,'vid_handle');


[ratio_img bw_pix_pass] = nanoxim_CalculateRatiomImage(vid_handle, ...
    bck_frame_range, for_frame_range);
setappdata(handles.figure_nanoxim,'ratio_img',ratio_img);
setappdata(handles.figure_nanoxim,'bw_pix_pass',bw_pix_pass);

% Update image controls (slider max/min)
ratio_img(~bw_pix_pass)=NaN;
h=imshow(ratio_img,'Parent',handles.axes_ratiom);
colormap(handles.axes_ratiom, jet);
set(h,'AlphaData',bw_pix_pass)
colorbar(handles.axes_ratiom);
 
% img = getframe(handles.axes_ratiom);

% img.cdata(cat(3,bw_pix_pass,bw_pix_pas s,bw_pix_pass))=1;
% hold on
% imshow(img.cdata)
% hold off
 
% figure;imshow(img.cdata)
keyboard
 
% keyboard

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
