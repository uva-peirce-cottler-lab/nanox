function varargout = sub_gui2(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sub_gui2_OpeningFcn, ...
                   'gui_OutputFcn',  @sub_gui2_OutputFcn, ...
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

function sub_gui2_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;

h = findobj('Tag','master_guide');

if ~isempty(h)
    g1data = guidata(h);
    handles.mdata = g1data.data;
    set(handles.title,'String',g1data.plottedfile);
end

handles.cdata = [];
handles.camera = 'Grasshopper3';

app = matlab.apputil.getInstalledAppInfo;
[path2app,~,~] = fileparts(app(1).location);

handles.file = [path2app,'\DualEmissionLuminescenceAnalysis\code\Camera2.xlsx'];

% [name, path] = uigetfile({'Camera*.xlsx';'Camera*.xls'},'Select the Camera Response Data File');
% handles.file = horzcat(path,name);

if ~handles.file
	handles.file = 'Camera';
end
	
handles.cdata = xlsread(handles.file);

[~,sheets] = xlsfinfo(handles.file);

if numel(sheets) ~= 29
	set(handles.cameralist,'Visible','off');
end

if isempty(handles.cdata)
    errordlg('No Camera Data Found','File Error');
	return
else
    handles.cdata(2:end,2:end) = handles.cdata(2:end,2:end) * (max(max(handles.mdata(2:end,2:end)))/max(max(handles.cdata(2:end,2:end))));
    handles.plot1 = plot(handles.axes2,handles.cdata(2:end,1),handles.cdata(2:end,2:end));
    hold(handles.axes2,'on');
    
    set(handles.plot1(1),'Color',[0 0 1]);
    set(handles.plot1(2),'Color',[0 1 0]);
    set(handles.plot1(3),'Color',[1 0 0]);
end

handles.cmin = handles.cdata(2,1);
handles.cmax = handles.cdata(end,1);

temp1 = handles.mdata(1,:);
temp2 = handles.mdata(  ( (handles.mdata(:,1) >= handles.cmin)   &   (handles.mdata(:,1) <= handles.cmax) )  ,:);

handles.data = cat(1,temp1,temp2);

countl = 2;

if handles.data(2,1) > handles.cmin
    value = handles.data(2,1) - handles.cmin;
    insert = zeros(value,length(handles.data(2,:)));
    insert(:,1) = (handles.cmin:(handles.cmin+value-1));
    temp3 = cat(1,temp1,insert);
    handles.data = cat(1,temp3,temp2);
end
if handles.data(end,1) < handles.cmax
    countl = 1;
    measure = handles.data(end,1);
    while handles.data(end,1) ~= handles.cmax
        handles.data((end+1),1) = measure + countl;
        countl = countl + 1;
    end
end    
    
handles.plot2 = plot(handles.axes2,handles.data(2:end,1),handles.data(2:end,2:end));
set(handles.plot2,'Color',[0 0 0]);

axis(handles.axes2,[handles.data(2,1),handles.data(end,1),-inf,inf])

hold(handles.axes2,'off');

handles.o2data = handles.data(1,2:end)';

handles.data(1,:) = [];
handles.light = handles.data(:,1);
handles.data(:,1) = [];
handles.cdata(1,:) = [];
handles.cdata(:,1) = [];

tempdata = handles.data';

sums = tempdata * handles.cdata;

% % % % b/r  b/g  g/r  g/b  r/b  r/g

hold(handles.axes1,'on');
handles.plot3(1) = plot(handles.axes1,handles.o2data, sums(:,1)./sums(:,3));
handles.plot3(2) = plot(handles.axes1,handles.o2data, sums(:,1)./sums(:,2));
handles.plot3(3) = plot(handles.axes1,handles.o2data, sums(:,2)./sums(:,3));
handles.plot3(4) = plot(handles.axes1,handles.o2data, sums(:,2)./sums(:,1));
handles.plot3(5) = plot(handles.axes1,handles.o2data, sums(:,3)./sums(:,1));
handles.plot3(6) = plot(handles.axes1,handles.o2data, sums(:,3)./sums(:,2));
hold(handles.axes1,'off');

set(handles.plot3,'Visible','off');

legend(handles.axes1, 'B/R', 'B/G', 'G/R', 'G/B', 'R/B', 'R/G', 'Location', 'northeastoutside');
axis(handles.axes1,[handles.o2data(1),handles.o2data(end),-inf,inf])
title(handles.axes1,'Response Values vs. [O2]')
title(handles.axes2,handles.camera)
set(handles.xupbound,'String',num2str(handles.o2data(end)));

x = [min(handles.light),min(handles.light)];
handles.y = [0, max(max(handles.data))];

hold(handles.axes2,'on');
handles.plot4(1) = plot(handles.axes2, x , handles.y,'k-');
handles.plot4(2) = plot(handles.axes2, x , handles.y,'k--');
handles.plot4(3) = plot(handles.axes2, x , handles.y,'k-');
handles.plot4(4) = plot(handles.axes2, x , handles.y,'k--');
handles.plot4(5) = plot(handles.axes2, x , handles.y,'k-');
handles.plot4(6) = plot(handles.axes2, x , handles.y,'k--');
handles.plot4(7) = plot(handles.axes2, x , handles.y,'k-');
handles.plot4(8) = plot(handles.axes2, x , handles.y,'k--');
hold(handles.axes2,'off');
set(handles.plot4,'Visible','off');

handles.numfilters = 0;
handles.currentfilter = 0;

set(handles.axes1,'YLimMode','auto');

steps = 1/length(handles.cdata(:,1));

set(handles.firstfilterslider,'Max',handles.cmax);
set(handles.firstfilterslider,'Value', handles.cmin);
set(handles.firstfilterslider,'Min',handles.cmin);
set(handles.firstfilterslider,'SliderStep',[steps,steps*10]);

set(handles.secondfilterslider,'Max',handles.cmax);
set(handles.secondfilterslider,'Value', handles.cmin);
set(handles.secondfilterslider,'Min',handles.cmin);
set(handles.secondfilterslider,'SliderStep',[steps,steps*10]);

set(handles.fmin,'String',num2str(handles.cmin));
set(handles.fmax,'String',num2str(handles.cmax));
set(handles.pmin,'String',num2str(handles.cmin));
set(handles.pmax,'String',num2str(handles.cmax));

set(handles.firstfilterval,'String',num2str(handles.cmin));
set(handles.secondfilterval,'String',num2str(handles.cmin));

positions = get(handles.axes1,'Position');
positions(3) = positions(4);
set(handles.axes1,'Position',positions);

guidata(hObject, handles);

function varargout = sub_gui2_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function update(~, handles)
data = handles.data;
cdata = handles.cdata;
o2data = handles.o2data;
light = handles.light;

topplots = zeros(1,6);
botplots = zeros(1,4);

topplots(1) = get(handles.br,'Value');
topplots(2) = get(handles.bg,'Value');
topplots(3) = get(handles.gr,'Value');
topplots(4) = get(handles.gb,'Value');
topplots(5) = get(handles.rb,'Value');
topplots(6) = get(handles.rg,'Value');

botplots(4) = get(handles.showdata,'Value');
botplots(1) = get(handles.bresponse,'Value');
botplots(2) = get(handles.gresponse,'Value');
botplots(3) = get(handles.rresponse,'Value');

bscalar = get(handles.bslider,'Value')/100;
gscalar = get(handles.gslider,'Value')/100;
rscalar = get(handles.rslider,'Value')/100;

filter = handles.numfilters;
% set(handles.plot4,'Visible','off');

for i=1:8
	set(handles.plot4(i),'Color',[0.7,0.7,0.7]);
end
	
if filter
    lambda(1) = floor(get(handles.firstfilterslider,'Value'));
    lambda(2) = floor(get(handles.secondfilterslider,'Value'));
	
    set(handles.plot4((2*handles.currentfilter)-1),'XData', [lambda(1),lambda(1)],'YData', handles.y);
    set(handles.plot4((2*handles.currentfilter)),'XData', [lambda(2),lambda(2)],'YData', handles.y);
    set(handles.plot4((2*handles.currentfilter)-1),'Color','k');
    set(handles.plot4((2*handles.currentfilter)),'Color','k');
    set(handles.plot4((2*handles.currentfilter)-1),'Visible','on');
	set(handles.plot4((2*handles.currentfilter)),'Visible','on');

	for i=1:(2*handles.numfilters)
		holder = get(handles.plot4(i),'XData');
		lambda(i) = holder(1);
	end
	
	for i=1:handles.numfilters
		if lambda((2*i)-1) <= lambda(2*i)
			data(  (light(:,1) >= lambda((2*i)-1) & light(:,1) <= lambda(2*i))  ,:) = 0;
		else
			data(  (light(:,1) >= lambda((2*i)-1) | light(:,1) <= lambda(2*i)) ,:) = 0;
		end
	end

end

hold(handles.axes2,'on')
for i=1:length(o2data)
    set(handles.plot2(i),'XData',light,'YData',data(:,i),'Color','k');
    set(handles.plot2(i),'Color','k');
end
hold(handles.axes2,'off');
    
cdata(:,1) = cdata(:,1) * bscalar;
cdata(:,2) = cdata(:,2) * gscalar;
cdata(:,3) = cdata(:,3) * rscalar;

tempdata = data';
sums = tempdata * cdata;

br = sums(:,1)./sums(:,3);
bg = sums(:,1)./sums(:,2);
gr = sums(:,2)./sums(:,3);
gb = sums(:,2)./sums(:,1);
rb = sums(:,3)./sums(:,1);
rg = sums(:,3)./sums(:,2);

toggle = get(handles.normplots,'Value');

if toggle
    br = br / br(1);
    bg = bg / bg(1);
    gr = gr / gr(1);
    gb = gb / gb(1);
    rb = rb / rb(1);
    rg = rg / rg(1);
end

% b/r  b/g  g/r  g/b  r/b  r/g

set(handles.plot3(1),'XData',o2data,'YData',br);
set(handles.plot3(2),'XData',o2data,'YData',bg);
set(handles.plot3(3),'XData',o2data,'YData',gr);
set(handles.plot3(4),'XData',o2data,'YData',gb);
set(handles.plot3(5),'XData',o2data,'YData',rb);
set(handles.plot3(6),'XData',o2data,'YData',rg);

[rows,~,cdata] = find(cdata);
cdata = reshape(cdata,numel(cdata)/3,3);
rows(end/3+1:end) = [];

set(handles.plot1(1),'XData',light(rows),'YData',cdata(:,1));
set(handles.plot1(2),'XData',light(rows),'YData',cdata(:,2));
set(handles.plot1(3),'XData',light(rows),'YData',cdata(:,3));

if botplots(4)
    set(handles.plot2,'Visible','on');
else
    set(handles.plot2,'Visible','off');
end

for i=1:3
    if botplots(i)
        set(handles.plot1(i),'Visible','on');
    else
        set(handles.plot1(i),'Visible','off');
    end
end

for i=1:6
    if topplots(i)
        set(handles.plot3(i),'Visible','on');
    else
        set(handles.plot3(i),'Visible','off');
    end
end

function br_Callback(~, eventdata, handles)
update(eventdata, handles);

function bg_Callback(~, eventdata, handles)
update(eventdata, handles);

function gr_Callback(~, eventdata, handles)
update(eventdata, handles);

function gb_Callback(~, eventdata, handles)
update(eventdata, handles);

function rb_Callback(~, eventdata, handles)
update(eventdata, handles);

function rg_Callback(~, eventdata, handles)
update(eventdata, handles);

function bslider_Callback(hObject, eventdata, handles)
set(handles.bval,'String',num2str(floor(get(hObject,'Value'))));
set(handles.bslider,'Value',floor(get(hObject,'Value')));
guidata(hObject,handles);
update(eventdata, handles);

function bval_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
if num > 100
    set(hObject,'String','100');
    set(handles.bslider,'Value',100);
elseif num < 0
    set(hObject,'String','0');
    set(handles.bslider,'Value',0);
elseif isnan(num)
    set(hObject,'String','100');
    set(handles.bslider,'Value',100);
else
    set(handles.bslider,'Value',str2double(get(hObject,'String')));
end
guidata(hObject,handles);
update(eventdata, handles);

function gslider_Callback(hObject, eventdata, handles)
set(handles.gval,'String',num2str(floor(get(hObject,'Value'))));
set(handles.gslider,'Value',floor(get(hObject,'Value')));
guidata(hObject,handles);
update(eventdata, handles);

function gval_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
if num > 100
    set(hObject,'String','100');
    set(handles.gslider,'Value',100);
elseif num < 0
    set(hObject,'String','0');
    set(handles.gslider,'Value',0);
elseif isnan(num)
    set(hObject,'String','100');
    set(handles.gslider,'Value',100);
else
    set(handles.gslider,'Value',str2double(get(hObject,'String')));
end
guidata(hObject,handles);
update(eventdata, handles);

function rslider_Callback(hObject, eventdata, handles)
set(handles.rval,'String',num2str(floor(get(hObject,'Value'))));
set(handles.rslider,'Value',floor(get(hObject,'Value')));
guidata(hObject,handles);
update(eventdata, handles);

function rval_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
if num > 100
    set(hObject,'String','100');
    set(handles.rslider,'Value',100);
elseif num < 0
    set(hObject,'String','0');
    set(handles.rslider,'Value',0);
elseif isnan(num)
    set(hObject,'String','100');
    set(handles.rslider,'Value',100);
else
    set(handles.rslider,'Value',str2double(get(hObject,'String')));
end
guidata(hObject,handles);
update(eventdata, handles);

function showdata_Callback(~, eventdata, handles)
update(eventdata, handles);

function bresponse_Callback(~, eventdata, handles)
update(eventdata, handles);

function gresponse_Callback(~, eventdata, handles)
update(eventdata, handles);

function rresponse_Callback(~, eventdata, handles)
update(eventdata, handles);

function firstfilterslider_Callback(hObject, eventdata, handles)
set(handles.firstfilterval,'String',num2str(floor(get(hObject,'Value'))));
guidata(hObject,handles);
update(eventdata, handles);

function firstfilterval_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
if num > handles.cmax
    set(hObject,'String',num2str(handles.cmax));
    set(handles.firstfilterslider,'Value',handles.cmax);
elseif num < handles.cmin
    set(hObject,'String',num2str(handles.cmin));
    set(handles.firstfilterslider,'Value',handles.cmin);
elseif isnan(num)
    set(hObject,'String',num2str(handles.cmin));
    set(handles.firstfilterslider,'Value',handles.cmin);
else
    set(handles.firstfilterslider,'Value',floor(str2double(get(hObject,'String'))));
end
guidata(hObject,handles);
update(eventdata,handles);

function secondfilterslider_Callback(hObject, eventdata, handles)
set(handles.secondfilterval,'String',num2str(floor(get(hObject,'Value'))));
guidata(hObject,handles);
update(eventdata, handles);

function secondfilterval_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
if num > handles.cmax
    set(hObject,'String',num2str(handles.cmax));
    set(handles.secondfilterslider,'Value',handles.cmax);
elseif num < handles.cmin
    set(hObject,'String',num2str(handles.cmin));
    set(handles.secondfilterslider,'Value',handles.cmin);
elseif isnan(num)
    set(hObject,'String',num2str(handles.cmin));
    set(handles.secondfilterslider,'Value',handles.cmin);
else
    set(handles.secondfilterslider,'Value',floor(str2double(get(hObject,'String'))));
end
guidata(hObject,handles);
update(eventdata,handles);

function holdaxes_Callback(hObject, ~, handles)
if get(hObject,'Value')
    set(handles.axes1,'YLimMode','manual');
else
    set(handles.axes1,'YLimMode','auto');
end
guidata(hObject,handles);

function showall_Callback(hObject, eventdata, handles)
% b/r  b/g  g/r  g/b  r/b  r/g
br = get(handles.br,'Value');
bg = get(handles.bg,'Value');
gr = get(handles.gr,'Value');
gb = get(handles.gb,'Value');
rb = get(handles.rb,'Value');
rg = get(handles.rg,'Value');

if br && bg && gr && gb && rb && rg
    set(handles.br,'Value',0);
    set(handles.bg,'Value',0);
    set(handles.gr,'Value',0);
    set(handles.gb,'Value',0);
    set(handles.rb,'Value',0);
    set(handles.rg,'Value',0);
else
    set(handles.br,'Value',1);
    set(handles.bg,'Value',1);
    set(handles.gr,'Value',1);
    set(handles.gb,'Value',1);
    set(handles.rb,'Value',1);
    set(handles.rg,'Value',1);
end

guidata(hObject,handles);
update(eventdata,handles);


function normplots_Callback(hObject, eventdata, handles)
update(eventdata,handles);

function xupbound_Callback(hObject, eventdata, handles)
xval = str2double(get(hObject,'String'));

if isnan(xval) || xval > handles.o2data(end) || xval <= handles.o2data(1)
    set(handles.axes1,'XLim',[handles.o2data(1),handles.o2data(end)]);
    set(hObject,'String',num2str(handles.o2data(end)));
else
    set(handles.axes1,'XLim',[handles.o2data(1),xval]);
end

function cameralist_Callback(hObject, eventdata, handles)
camera_names = get(hObject,'String');
val = get(hObject,'Value');

handles.camera = strtrim(camera_names{val});
handles.cdata = xlsread(handles.file,handles.camera);

handles.cdata(2:end,2:end) = handles.cdata(2:end,2:end) * (max(max(handles.mdata(2:end,2:end)))/max(max(handles.cdata(2:end,2:end))));

handles.cmin = handles.cdata(2,1);
handles.cmax = handles.cdata(end,1);

temp1 = handles.mdata(1,:);
temp2 = handles.mdata(  ( (handles.mdata(:,1) >= handles.cmin)   &   (handles.mdata(:,1) <= handles.cmax) )  ,:);

handles.data = cat(1,temp1,temp2);

countl = 2;

if handles.data(2,1) > handles.cmin
    value = handles.data(2,1) - handles.cmin;
    insert = zeros(value,length(handles.data(2,:)));
    insert(:,1) = (handles.cmin:(handles.cmin+value-1));
    temp3 = cat(1,temp1,insert);
    handles.data = cat(1,temp3,temp2);
end
if handles.data(end,1) < handles.cmax
    countl = 1;
    measure = handles.data(end,1);
    while handles.data(end,1) ~= handles.cmax
        handles.data((end+1),1) = measure + countl;
        countl = countl + 1;
    end
end    

axis(handles.axes2,[handles.data(2,1),handles.data(end,1),-inf,inf])

handles.data(1,:) = [];
handles.light = handles.data(:,1);
handles.data(:,1) = [];
handles.cdata(1,:) = [];
handles.cdata(:,1) = [];

title(handles.axes2,handles.camera)

steps = 1/length(handles.cdata(:,1));

set(handles.firstfilterslider,'Max',handles.cmax);
set(handles.firstfilterslider,'Value', handles.cmin);
set(handles.firstfilterslider,'Min',handles.cmin);
set(handles.firstfilterslider,'SliderStep',[steps,steps*10]);

set(handles.secondfilterslider,'Max',handles.cmax);
set(handles.secondfilterslider,'Value', handles.cmin);
set(handles.secondfilterslider,'Min',handles.cmin);
set(handles.secondfilterslider,'SliderStep',[steps,steps*10]);

set(handles.fmin,'String',num2str(handles.cmin));
set(handles.fmax,'String',num2str(handles.cmax));
set(handles.pmin,'String',num2str(handles.cmin));
set(handles.pmax,'String',num2str(handles.cmax));

set(handles.firstfilterval,'String',num2str(handles.cmin));
set(handles.secondfilterval,'String',num2str(handles.cmin));

while handles.numfilters
	set(handles.plot4( (handles.numfilters*2)-1),'Visible','off');
	set(handles.plot4( (handles.numfilters*2)  ),'Visible','off');
	set(handles.plot4( (handles.numfilters*2)-1),'XData', [handles.cmin,handles.cmin]);
	set(handles.plot4( (handles.numfilters*2)  ),'XData', [handles.cmin,handles.cmin]);

	handles.numfilters = handles.numfilters - 1;
end

set(handles.minusfilter,'Enable','off');
set(handles.currentfilterval,'String','0');
set(handles.previousfilter,'Enable','off');
set(handles.firstfilterslider,'Value',get(handles.firstfilterslider,'Min'));
set(handles.secondfilterslider,'Value',get(handles.secondfilterslider,'Min'));

set(handles.nextfilter,'Enable','off');
handles.currentfilter = handles.numfilters;

set(handles.plusfilter,'Enable','on');

guidata(hObject, handles);
update(eventdata, handles);


% handles.numfilters = 1;
% handles.currentfilter = 1;

function plusfilter_Callback(hObject, eventdata, handles)
handles.numfilters = handles.numfilters + 1;

set(handles.currentfilterval,'String',num2str(handles.numfilters));
handles.currentfilter = handles.numfilters;

x1 = get(handles.plot4( (2*handles.currentfilter) - 1), 'XData');
x2 = get(handles.plot4( (2*handles.currentfilter)    ), 'XData');
set(handles.firstfilterslider,'Value', x1(1));
set(handles.secondfilterslider,'Value', x2(1));
firstfilterslider_Callback(handles.firstfilterslider,eventdata,handles);
secondfilterslider_Callback(handles.secondfilterslider,eventdata,handles);

if handles.numfilters == 4
	set(handles.plusfilter,'Enable','off');
elseif handles.numfilters ~= 1
	set(handles.previousfilter,'Enable','on');
end

set(handles.minusfilter,'Enable','on');

set(handles.plot4( (handles.numfilters*2)-1),'Visible','on');
set(handles.plot4( (handles.numfilters*2)  ),'Visible','on');

guidata(hObject, handles);

update(eventdata, handles);

function minusfilter_Callback(hObject, eventdata, handles)
set(handles.plot4( (handles.numfilters*2)-1),'Visible','off');
set(handles.plot4( (handles.numfilters*2)  ),'Visible','off');
set(handles.plot4( (handles.numfilters*2)-1),'XData', [handles.cmin,handles.cmin]);
set(handles.plot4( (handles.numfilters*2)  ),'XData', [handles.cmin,handles.cmin]);

handles.numfilters = handles.numfilters - 1;

if handles.numfilters == 0
	set(handles.minusfilter,'Enable','off');
	set(handles.currentfilterval,'String','0');
	set(handles.previousfilter,'Enable','off');
	set(handles.firstfilterslider,'Value',get(handles.firstfilterslider,'Min'));
	set(handles.secondfilterslider,'Value',get(handles.secondfilterslider,'Min'));
end

if handles.numfilters <= handles.currentfilter
	set(handles.nextfilter,'Enable','off');
	handles.currentfilter = handles.numfilters;
	
	if handles.currentfilter
		x1 = get(handles.plot4( (2*handles.currentfilter) - 1), 'XData');
		x2 = get(handles.plot4( (2*handles.currentfilter)    ), 'XData');
		set(handles.firstfilterslider,'Value', x1(1));
		set(handles.secondfilterslider,'Value', x2(1));
		firstfilterslider_Callback(handles.firstfilterslider,eventdata,handles);
		secondfilterslider_Callback(handles.secondfilterslider,eventdata,handles);
	end
	if handles.numfilters == 1
		set(handles.previousfilter,'Enable','off');
	end
	
	set(handles.currentfilterval,'String',num2str(handles.numfilters));
end

set(handles.plusfilter,'Enable','on');

guidata(hObject, handles);

update(eventdata, handles);



function nextfilter_Callback(hObject, eventdata, handles)
handles.currentfilter = handles.currentfilter + 1;

x1 = get(handles.plot4( (2*handles.currentfilter) - 1), 'XData');
x2 = get(handles.plot4( (2*handles.currentfilter)    ), 'XData');

set(handles.firstfilterslider,'Value', x1(1));
set(handles.secondfilterslider,'Value', x2(1));

if handles.currentfilter == handles.numfilters
	set(handles.nextfilter,'Enable','off');
end

set(handles.previousfilter,'Enable','on');
set(handles.currentfilterval,'String',num2str(handles.currentfilter));

firstfilterslider_Callback(handles.firstfilterslider,eventdata,handles);
secondfilterslider_Callback(handles.secondfilterslider,eventdata,handles);

guidata(hObject, handles);

update(eventdata, handles);

function previousfilter_Callback(hObject, eventdata, handles)
handles.currentfilter = handles.currentfilter - 1;

x1 = get(handles.plot4( (2*handles.currentfilter) - 1), 'XData');
x2 = get(handles.plot4( (2*handles.currentfilter)    ), 'XData');

set(handles.firstfilterslider,'Value', x1(1));
set(handles.secondfilterslider,'Value', x2(1));

if handles.currentfilter == 1
	set(handles.previousfilter,'Enable','off');
end

set(handles.nextfilter,'Enable','on');
set(handles.currentfilterval,'String',num2str(handles.currentfilter));

firstfilterslider_Callback(handles.firstfilterslider,eventdata,handles);
secondfilterslider_Callback(handles.secondfilterslider,eventdata,handles);

guidata(hObject, handles);

update(eventdata, handles);
