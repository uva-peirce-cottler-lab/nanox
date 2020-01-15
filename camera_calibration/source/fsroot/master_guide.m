function varargout = master_guide(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @master_guide_OpeningFcn, ...
                   'gui_OutputFcn',  @master_guide_OutputFcn, ...
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

function master_guide_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;

plot([0,1],[0,1;1,0],'k');

handles.data = [];

guidata(hObject, handles);

function varargout = master_guide_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function listbox1_Callback(hObject, eventdata, handles)
selections = get(hObject,'Value');
if length(selections) > 1
    set(hObject,'Value',selections(1));
end
set(hObject, 'Min', 0, 'Max', 1);
index_selected = get(hObject,'Value');
list = get(hObject,'String');
file_selected = list{index_selected};
handles.file = strtrim(file_selected);
guidata(hObject,handles);

update(handles);


function listbox1_CreateFcn(hObject, eventdata, handles)
files = matlab.apputil.getInstalledAppInfo;
[path,~,~] = fileparts(files(1).location);

info = dir([path,'\DualEmissionLuminescenceAnalysis\code\*.xls*']);

x = length(info);

for i=1:x
    filenames(i,:) = blanks(100);
    for j=1:(length(info(i).name))
        filenames(i,j) = info(i).name(j);
    end
end

count = 1;

for i=1:x
    temp = strtrim(filenames(i,:));
	if ~strncmp(temp,'Cam',3)
		text{count} = temp;
		count = count + 1;
	end
	clear temp;
end

if x == 0
    text = [];
    set(hObject,'Enable','off');
end

set(hObject,'String',text);
set(hObject, 'Min', 0, 'Max', 2, 'Value', []);

guidata(hObject,handles);

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function update(handles)
hObject = findobj('Tag','master_guide');
handles.data = xlsread(handles.file);
handles.plottedfile = handles.file;
guidata(hObject,handles);
plot(handles.data(2:end,1),handles.data(2:end,2:end))
xlabel('Wavelength (nm)')
ylabel('Intensity (AU)')
set(handles.title,'String',handles.plottedfile);

ext = get(handles.title,'Extent');
str = get(handles.title,'String');

toolong = 0;

if ext(3) > 386
    toolong = 1;
end

while ext(3) > 386
    str(1) = [];
    set(handles.title,'String', str);
    ext = get(handles.title,'Extent');
    str = get(handles.title,'String');
end

if toolong
    str = strcat('...',str);
    set(handles.title,'String', str);
end
    
axis([handles.data(2,1),handles.data(end,1),-inf,inf])

function pushbutton3_Callback(hObject, eventdata, handles)
if isempty(handles.data)
    errordlg('Please Select a File','No Data Selected Error');
else
    sub_gui1
end

function pushbutton4_Callback(hObject, eventdata, handles)
close(master_guide);

function browse_Callback(hObject, eventdata, handles)
[baseName, folder] = uigetfile({'*.xlsx';'*.xls'},'Select the Data File');
handles.file = fullfile(folder, baseName);

guidata(hObject,handles);

update(handles);

function cameraresp_Callback(hObject, eventdata, handles)
if isempty(handles.data)
    errordlg('Please Select a File','No Data Selected Error');
else
    sub_gui2
end
