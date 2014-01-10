function varargout = welcome(varargin)
% WELCOME MATLAB code for welcome.fig
%      WELCOME, by itself, creates a new WELCOME or raises the existing
%      singleton*.
%
%      H = WELCOME returns the handle to a new WELCOME or the handle to
%      the existing singleton*.
%
%      WELCOME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WELCOME.M with the given input arguments.
%
%      WELCOME('Property','Value',...) creates a new WELCOME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before welcome_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to welcome_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help welcome

% Last Modified by GUIDE v2.5 25-May-2013 02:47:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @welcome_OpeningFcn, ...
    'gui_OutputFcn',  @welcome_OutputFcn, ...
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


% --- Executes just before welcome is made visible.
function welcome_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to welcome (see VARARGIN)

% Choose default command line output for welcome
handles.output = hObject;
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
bg = imread('welcome.jpg'); imagesc(bg);
set(ah,'handlevisibility','off','visible','off');
uistack(ah, 'bottom');
handles.recog=[];
handles.train=[];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes welcome wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = welcome_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ok_Callback(hObject, eventdata, handles);
% Hints: get(hObject,'String') returns contents of input as text
%        str2double(get(hObject,'String')) returns contents of input as a double


% --- Executes during object creation, after setting all properties.
function input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name=get(handles.input,'String');
%set(handles.text2,'String',name);
load('names.mat','Allnames');
[~,len]=size(Allnames);
isfound=0;
dummy=cell(1,len-1);
for i=1:len
    if strcmp(name,Allnames{1,i}) == 1 ,
        isfound=1;
    elseif isfound==0 ,
        dummy{1,i}=Allnames{1,i};
    else dummy{1,i-1}=Allnames{1,i};
    end;
end;
if isfound==0,
    if length(strcat(name))~=0
        responce = questdlg('Oops ! You are not in our database ! Do you want to add yourself to our database ?  Note : This will reqire a complete Voice training which is a  bit boring.  Press yes to proceed.', 'Warning','Yes','No', 'No');
        if strcmp(responce,'Yes') == 1   ,
            Allnames=[Allnames , cell(1,1)];
            Allnames{1,len+1}=name;
            handles.train=train;
            train_data=guidata(handles.train);
            set(train_data.user,'String',name);
            delete(get(hObject, 'parent'));
        else
            set(handles.input,'String','');
        end;
    else
        h= warndlg('Please Enter your name','Warning');
        uiwait(h);
    end;
else
    answer= questdlg('Your name already exists, please choose one option','Name found','Re-train','delete','recognition','recognition');
    if strcmp(answer,'delete') ,
        Allnames=dummy;
    elseif strcmp(answer,'Re-train') ,
        Allnames=dummy;
        Allnames=[Allnames , cell(1,1)];
        Allnames{1,len+1}=name;
        handles.train=train;
        train_data=guidata(handles.train);
        set(train_data.user,'String',name);
        delete(get(hObject, 'parent'));
    else
        handles.recog=recognition;
        recog_data=guidata(handles.recog);
        set(recog_data.uname,'String',name);
        set(handles.text2,'String','name found');
        delete(get(hObject, 'parent'));
    end;
end;
save('names.mat','Allnames');


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
