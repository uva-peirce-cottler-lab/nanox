function varargout = sub_gui1(varargin)
% SUB_GUI1 MATLAB code for sub_gui1.fig
%      SUB_GUI1, by itself, creates a new SUB_GUI1 or raises the existing
%      singleton*.
%
%      H = SUB_GUI1 returns the handle to a new SUB_GUI1 or the handle to
%      the existing singleton*.
%
%      SUB_GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUB_GUI1.M with the given input arguments.
%
%      SUB_GUI1('Property','Value',...) creates a new SUB_GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sub_gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sub_gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sub_gui1

% Last Modified by GUIDE v2.5 06-Jun-2016 11:57:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sub_gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @sub_gui1_OutputFcn, ...
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


% --- Executes just before sub_gui1 is made visible.
function sub_gui1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sub_gui1 (see VARARGIN)

% Choose default command line output for sub_gui1
handles.output = hObject;

h = findobj('Tag','master_guide');

if ~isempty(h)
    g1data = guidata(h);
    handles.data = g1data.data;
    set(handles.title,'String',g1data.plottedfile);

    ext = get(handles.title,'Extent');
    str = get(handles.title,'String');

    toolong = 0;

    if ext(3) > 536
        toolong = 1;
    end

    while ext(3) > 536
        str(1) = [];
        set(handles.title,'String', str);
        ext = get(handles.title,'Extent');
        str = get(handles.title,'String');
    end

    if toolong
        str = strcat('...',str);
        set(handles.title,'String', str);
    end
end

handles.plot1a = plot(handles.axes1,handles.data(2:end,1),handles.data(2:end,2:end));
xlabel(handles.axes1,'Wavelength (nm)')
ylabel(handles.axes1,'Intensity (AU)')
axis(handles.axes1,[handles.data(2,1),handles.data(end,1),-inf,inf])
hold(handles.axes1,'on');

handles.plot1b = plot(handles.axes1,handles.data(2:end,1),handles.data(2:end,2:end));
set(handles.plot1b,'Color',[0 0 0]);
set(handles.plot1b,'Visible','off');

app = matlab.apputil.getInstalledAppInfo;
[path2app,~,~] = fileparts(app(1).location);

wherecamera = [path2app,'\DualEmissionLuminescenceAnalysis\code\Camera2.xlsx'];

handles.cdata = [];
handles.cdata = xlsread(wherecamera);

if isempty(handles.cdata)
    cfilename = uigetfile({'*.xlsx';'*.xls'},'Select the Camera Response Data File');
    handles.cdata = xlsread(cfilename);
end

if isempty(handles.cdata)
    errordlg('No Camera Data Found','File Error');
    handles.cdatafound = 0;
else
    handles.cdatafound = 1;
    handles.cdata(2:end,2:end) = handles.cdata(2:end,2:end) * (max(max(handles.data(2:end,2:end)))/max(max(handles.cdata(2:end,2:end))));
    handles.plot2 = plot(handles.axes1,handles.cdata(2:end,1),handles.cdata(2:end,2:end));
    set(handles.plot2,'Visible','off');
    set(handles.plot2(1),'Color',[0 0 1]);
    set(handles.plot2(2),'Color',[0 1 0]);
    set(handles.plot2(3),'Color',[1 0 0]);
end

minL = handles.data(2,1);
maxL = handles.data(end,1);
handles.minL = minL;
handles.maxL = maxL;
len = length(handles.data(2:end,1));
steps = 1/len;

set(handles.fmin,'String',num2str(minL));
set(handles.fmax,'String',num2str(maxL));
set(handles.pmin,'String',num2str(minL));
set(handles.pmax,'String',num2str(maxL));

set(handles.fval,'String',num2str(minL));
set(handles.pval,'String',num2str(minL));

set(handles.fslider,'Max',maxL);
set(handles.fslider,'Value', minL);
set(handles.fslider,'Min',minL);
set(handles.fslider,'SliderStep',[steps,steps]);

set(handles.pslider,'Max',maxL);
set(handles.pslider,'Value', minL);
set(handles.pslider,'Min',minL);
set(handles.pslider,'SliderStep',[steps,steps]);

set(handles.modes,'Value',1);

handles.y = [0 max(max(handles.cdata(2:end,2:end)))];

xf = [minL minL];
xp = [minL minL];

handles.plot3a = plot(handles.axes1,xf,handles.y,'k');
handles.plot3b = plot(handles.axes1,xp,handles.y,'k');

set(handles.scalarval, 'String', num2str(get(handles.scalarslider,'Value')));

o2vals = length(handles.data(1,2:end));
xx=0;
yy=0;
handles.plot4 = plot(handles.axes2,xx,yy);

for i=1:o2vals
    set(gca,'NextPlot','add');
    handles.plot5(i) = plot(handles.axes2,xx,yy);
    set(gca,'NextPlot','add');
    handles.plot6(i) = plot(handles.axes2,xx,yy);
end

% set(handles.scalarslider,'Max',2);
% set(handles.scalarslider,'SliderStep',[0.005,0.005]);

axis(handles.axes2,[handles.data(2,1),handles.data(end,1),-inf,inf]);
set(handles.xupbound,'String',handles.data(end,1));

hold(handles.axes1,'off');

handles.called = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sub_gui1 wait for user response (see UIRESUME)
% uiwait(handles.sub_gui1);

% --- Outputs from this function are returned to the command line.
function varargout = sub_gui1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function fslider_Callback(hObject, eventdata, handles)
% hObject    handle to fslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
fval = int16(get(hObject,'Value'));
xvals = [fval fval];
set(handles.plot3a,'XData',xvals,'YData',handles.y);
set(handles.fval,'String',num2str(fval));

update_Callback(handles.update,eventdata,handles);



% --- Executes on slider movement.
function pslider_Callback(hObject, eventdata, handles)
% hObject    handle to pslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pval = int16(get(hObject,'Value'));
xvals = [pval pval];
set(handles.plot3b,'XData',xvals,'YData',handles.y);
set(handles.pval,'String',num2str(pval));

update_Callback(handles.update,eventdata,handles);



% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function fval_Callback(hObject, eventdata, handles)
% hObject    handle to fval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = int16(str2num(get(hObject,'String')));

if temp > handles.maxL
    set(handles.fslider,'Value',handles.maxL);
    set(hObject,'String',num2str(handles.maxL));
    temp = handles.maxL;
elseif temp < handles.minL
    set(handles.fslider,'Value',handles.minL);
    set(hObject,'String',num2str(handles.minL));
    temp = handles.minL;
else
    set(handles.fslider,'Value', str2num(get(hObject,'String')));
end
fval = temp;
xvals = [fval fval];
set(handles.plot3a,'XData',xvals,'YData',handles.y);
clear temp;

update_Callback(handles.update,eventdata,handles);


% Hints: get(hObject,'String') returns contents of fval as text
%        str2double(get(hObject,'String')) returns contents of fval as a double



function pval_Callback(hObject, eventdata, handles)
% hObject    handle to pval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = int16(str2num(get(hObject,'String')));

if temp > handles.maxL
    set(handles.pslider,'Value',handles.maxL);
    set(hObject,'String',num2str(handles.maxL));
    temp = handles.maxL;
elseif temp < handles.minL
    set(handles.pslider,'Value',handles.minL);
    set(hObject,'String',num2str(handles.minL));
    temp = handles.minL;
else
    set(handles.pslider,'Value', str2num(get(hObject,'String')));
end
pval = temp;
xvals = [pval pval];
set(handles.plot3b,'XData',xvals,'YData',handles.y);
clear temp;

update_Callback(handles.update,eventdata,handles);


% Hints: get(hObject,'String') returns contents of pval as text
%        str2double(get(hObject,'String')) returns contents of pval as a double


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.cdatafound && get(hObject,'Value')
    axis(handles.axes1,[handles.cdata(2,1),handles.cdata(end,1),-inf,inf]);
    set(handles.plot2,'Visible','on');
    set(handles.plot1a,'Visible','off');
    set(handles.plot1b,'Visible','on');
elseif ~handles.cdatafound
    errordlg('No Camera Data Found','File Error');
elseif handles.cdatafound && ~get(hObject,'Value')
    set(handles.plot2,'Visible','off');
    axis(handles.axes1,[handles.data(2,1),handles.data(end,1),-inf,inf]);
    set(handles.plot1b,'Visible','off');
    set(handles.plot1a,'Visible','on');
end


% Hint: get(hObject,'Value') returns toggle state of checkbox1

% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
if ~handles.called
    handles.called = 1;
end

mode = get(handles.modes,'Value');

lambda(1) = int16(get(handles.fslider,'Value'));
lambda(2) = int16(get(handles.pslider,'Value'));

light = handles.data(2:end,1);
lightvals = length(light);
data = handles.data;
idata = handles.data(2:end,2:end);
o2data = handles.data(1,2:end);
o2vals = length(o2data);
pdata = idata;
mcdata = handles.cdata;
cdata = mcdata(2:end,2:end);

scalar = get(handles.scalarslider,'Value');
handles.scalar = scalar;

count = 1;

handles.lambda(1) = lambda(1);
handles.lambda(2) = lambda(2);

while lambda(1) > light(count)
    count = count + 1;
end
lambda(1) = count;
count = 1;

while lambda(2) > light(count)
    count = count + 1;
end
lambda(2) = count;

handles.indeces = lambda;

offset = 0;
endset = 0;

if lambda(2)-19 < 1
    offset = -1 * (lambda(2)-20);
elseif lambda(2) + 21 > lightvals
    endset = lightvals - (lambda(2)+21);
end

fshift = idata(:,end);
puref = fshift;

for i = 1:lightvals
    for j = 1:(o2vals-1)
        if fshift(i) > idata(i,j)
            fshift = fshift .* (idata(i,j)/fshift(i));
        end
    end
end

for i = 1:o2vals
    idata(:,i) = idata(:,i) - fshift;
end

handles.mpuref = puref;
handles.idata = idata;

puref = puref - (idata(:,1)*scalar);


set(handles.plot4,'Visible','off');
set(handles.plot5,'Visible','off');
set(handles.plot6,'Visible','off');
axis(handles.axes2,[light(1),light(end),-inf,inf]);

if mode == 1 || mode == 3
    set(handles.plot4,'XData',light,'YData',puref,'Color','b');
    set(handles.plot4,'Visible','on');
    xlabel(handles.axes2,'Wavelength (nm)');
    ylabel(handles.axes2,'Intensity (AU)');
end

handles.firstpdata = pdata;

for i=1:o2vals
    pdata(:,i) = pdata(:,i) * (puref(lambda(1))/pdata(lambda(1),i));
end

for i=1:o2vals
    pdata(:,i) = pdata(:,i) - puref;
end

handles.light = light;
handles.o2 = o2data;
handles.fdata = puref;
handles.pdata = pdata;

values = ones(40,2);
measure = 1;
colors = [0 0 1;0 1 0;1 0 0];

for i=(offset+1):(41+endset)
    stvr = pdata(lambda(2)-20+i,1)./pdata(lambda(2)-20+i,:);
    
    if (i == (offset+1) || i == 21 || i == (41+endset)) && ((mode == 5) || (mode == 6))
        xupbound = floor(str2double(get(handles.xupbound,'String')));
        
        if isnan(xupbound) || xupbound > o2data(end) || xupbound <= o2data(1)
            axis(handles.axes2,[o2data(1),o2data(end),-inf,inf]);
        else
            axis(handles.axes2,[o2data(1),xupbound,-inf,inf]);
        end
        
        set(gca,'NextPlot','add')
        set(handles.plot5(measure),'XData',o2data,'YData',stvr,'Color',colors(measure,:));
        set(handles.plot5(measure),'Visible','on');
        measure = measure + 1;
        xlabel(handles.axes2,'Oxygen Concentration');
        ylabel(handles.axes2,'I0/I');
    end
    
    P = polyfit(o2data,stvr,1);
    values(i,2) = P(1);
    
end


if mode == 6
    figure
    histogram(values(:,2),10)
    xlabel('Value')
    ylabel('Frequency')
    title('Distribution of Quenching Constants (P +/- 20nm)')
end

if mode == 2 || mode == 3
    for i=1:o2vals
        set(gca,'NextPlot','add')
        set(handles.plot5(i),'XData',light,'YData',pdata(:,i),'Color','r');
        set(handles.plot5(i),'Visible','on');
    end
    xlabel(handles.axes2,'Wavelength (nm)');
    ylabel(handles.axes2,'Intensity (AU)');
end

if mode == 4
    xlabel(handles.axes2,'Wavelength (nm)');
    ylabel(handles.axes2,'Intensity (AU)');
    
    set(handles.plot4,'XData',light,'YData',puref,'Color','k');
    set(handles.plot4,'Visible','on');
    
    for i=1:o2vals
        set(gca,'NextPlot','add')
        set(handles.plot5(i),'XData',light,'YData',pdata(:,i),'Color','k');
        set(handles.plot5(i),'Visible','on');
    end
    
    mcdata(2:end,2:end) = mcdata(2:end,2:end) * (max(max(pdata))/max(max(mcdata(2:end,2:end))));

    
    axis(handles.axes2,[mcdata(2,1),mcdata(end,1),-inf,inf]);
    set(gca,'NextPlot','add')
    set(handles.plot6(1),'XData',mcdata(2:end,1),'YData',mcdata(2:end,2),'Color','b');
    set(gca,'NextPlot','add')
    set(handles.plot6(2),'XData',mcdata(2:end,1),'YData',mcdata(2:end,3),'Color','g');
    set(gca,'NextPlot','add')
    set(handles.plot6(3),'XData',mcdata(2:end,1),'YData',mcdata(2:end,4),'Color','r');
    set(handles.plot6,'Visible','on');
end

xlims = get(handles.axes2,'XLim');
set(handles.xupbound,'String',num2str(xlims(2)));

guidata(hObject, handles);



% --- Executes on slider movement.
function scalarslider_Callback(hObject, eventdata, handles)
% hObject    handle to scalarslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.scalarval,'String',get(hObject,'Value'));

update_Callback(handles.update,eventdata,handles);




function scalarval_Callback(hObject, eventdata, handles)
% hObject    handle to scalarval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scalarval as text
%        str2double(get(hObject,'String')) returns contents of scalarval as a double
number = str2double(get(hObject,'String'));

if number > 2
    set(handles.scalarslider,'Value',2);
    set(hObject,'String','2');
elseif number < 0
    set(handles.scalarslider,'Value',0);
    set(hObject,'String','0');
else
    set(handles.scalarslider,'Value',number);
end

update_Callback(handles.update,eventdata,handles);


function pushbutton3_Callback(hObject, eventdata, handles)
maxdata = handles.data(2:end,2);
mindata = handles.data(2:end,end);


light = handles.data(2:end,1);
lightvals = length(light);
idata = handles.data(2:end,2:end);
o2data = handles.data(1,2:end);
o2vals = length(o2data);

scalar = get(handles.scalarslider,'Value');

fshift = idata(:,end);
puref = fshift;

for i = 1:lightvals
    for j = 1:(o2vals-1)
        if fshift(i) > idata(i,j)
            fshift = fshift .* (idata(i,j)/fshift(i));
        end
    end
end

for i = 1:o2vals
    idata(:,i) = idata(:,i) - fshift;
end

puref = puref - (idata(:,1)*scalar);

puref = smooth(puref);

[~,locs] = findpeaks(puref);

mark = 1;

if length(locs) == 2
    if locs(1) < locs(2)
        mark = 1;
    else
        mark = 2;
    end
end

[~,index1] = max(maxdata);
index2 = locs(mark);

lambdap = handles.data(index1,1);
lambdaf = handles.data(index2,1);


set(handles.pval,'String',num2str(lambdap));
set(handles.pslider,'Value',lambdap);

xvals = [lambdap lambdap];
set(handles.plot3b,'XData',xvals,'YData',handles.y);

set(handles.fval,'String',num2str(lambdaf));
set(handles.fslider,'Value',lambdaf);

xvals = [lambdaf lambdaf];
set(handles.plot3a,'XData',xvals,'YData',handles.y);

update_Callback(handles.update,eventdata,handles);


function pushbutton4_Callback(hObject, eventdata, handles)
temp = get(handles.title,'String');

if length(temp) > 31
    name = temp(1:31);
else
    name = temp;
end
    
light = handles.light;
pdata = handles.pdata;
fdata = handles.fdata;
lambda = handles.lambda;
o2data = handles.o2;
scalar = handles.scalar;

columns = 5 + length(o2data);
rows = 2 + length(light);

FP = {horzcat('F/P: ',num2str(lambda(1)),'/',num2str(lambda(2)))};
sc = {horzcat('Scalar: ',num2str(scalar))};

xlswrite('Dual-Emitting Luminescence Analysis Data.xlsx',FP,name,'A1');
xlswrite('Dual-Emitting Luminescence Analysis Data.xlsx',sc,name,'A2');
xlswrite('Dual-Emitting Luminescence Analysis Data.xlsx',{'Pure Fluorescence'},name,'C1');
xlswrite('Dual-Emitting Luminescence Analysis Data.xlsx',{'Pure Phosphorescences'},name,'F1');
xlswrite('Dual-Emitting Luminescence Analysis Data.xlsx',{'[O2]'},name,'E2');
xlswrite('Dual-Emitting Luminescence Analysis Data.xlsx',o2data,name,'F2');
xlswrite('Dual-Emitting Luminescence Analysis Data.xlsx',light,name,'A3');
xlswrite('Dual-Emitting Luminescence Analysis Data.xlsx',fdata,name,'C3');
xlswrite('Dual-Emitting Luminescence Analysis Data.xlsx',pdata,name,'F3');


% --- Executes on button press in autosetscalar.
function autosetscalar_Callback(hObject, eventdata, handles)
if ~handles.called
    errordlg('Set Wavelengths First','Error');
    return;
end

light = handles.light;
fdata = handles.fdata;
lambda = handles.indeces;
mpdata = handles.firstpdata;
o2data = handles.o2;
o2vals = length(o2data);
mpuref = handles.mpuref;
midata = handles.idata;

bestrsqd = 0;
bestval = 0;

if lambda(1) == 1 && lambda(2) == 1
    errordlg('Set Wavelengths First','Error');
    return;
end

for j=0:100
    puref = mpuref;
    idata = midata;
    pdata = mpdata;

    puref = puref - (idata(:,1)*(j/100));

    for i=1:o2vals
        pdata(:,i) = pdata(:,i) * (puref(lambda(1))/pdata(lambda(1),i));
    end

    for i=1:o2vals
        pdata(:,i) = pdata(:,i) - puref;
    end

    stvr = pdata(lambda(2),1)./pdata(lambda(2),:);

    mdl = fitlm(o2data,stvr);
    
    if mdl.Rsquared.Ordinary > bestrsqd
        bestrsqd = mdl.Rsquared.Ordinary;
        bestval = j/100;
    end
end

for i=1:21
    q = bestval - (i-11)/1000;
    
    if q > 0
        puref = mpuref;
        idata = midata;
        pdata = mpdata;

        puref = puref - (idata(:,1)*(q));

        for i=1:o2vals
            pdata(:,i) = pdata(:,i) * (puref(lambda(1))/pdata(lambda(1),i));
        end

        for i=1:o2vals
            pdata(:,i) = pdata(:,i) - puref;
        end

        stvr = pdata(lambda(2),1)./pdata(lambda(2),:);

        mdl = fitlm(o2data,stvr);

        if mdl.Rsquared.Ordinary > bestrsqd
            bestrsqd = mdl.Rsquared.Ordinary;
            bestval = q;
        end
    end
end

guidata(hObject, handles);

set(handles.scalarslider,'Value',bestval);

scalarslider_Callback(handles.scalarslider, eventdata, handles);

update_Callback(handles.update,eventdata,handles);

function modes_Callback(hObject, eventdata, handles)
update_Callback(handles.update,eventdata,handles);

function xupbound_Callback(hObject, eventdata, handles)
update_Callback(handles.update,eventdata,handles);

