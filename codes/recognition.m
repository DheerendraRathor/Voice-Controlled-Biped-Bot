function varargout = recognition(varargin)
% RECOGNITION MATLAB code for recognition.fig
%      RECOGNITION, by itself, creates a new RECOGNITION or raises the existing
%      singleton*.
%
%      H = RECOGNITION returns the handle to a new RECOGNITION or the handle to
%      the existing singleton*.
%
%      RECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECOGNITION.M with the given input arguments.
%
%      RECOGNITION('Property','Value',...) creates a new RECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recognition

% Last Modified by GUIDE v2.5 25-May-2013 19:15:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
global isstart;
global bot;
isstart=0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @recognition_OpeningFcn, ...
    'gui_OutputFcn',  @recognition_OutputFcn, ...
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


% --- Executes just before recognition is made visible.
function recognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recognition (see VARARGIN)

% Choose default command line output for recognition
handles.output = hObject;
set(handles.stop,'Visible','off');
set(handles.disconnect,'Visible','off');
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
bg = imread('recog.jpg'); imagesc(bg);
set(ah,'handlevisibility','off','visible','off');
uistack(ah, 'bottom');
global isconnect;
isconnect=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes recognition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = recognition_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
set(hObject,'Visible','off');
set(handles.stop,'Visible','on');
global isstart;
isstart=1;
global isconnect;
global bot;
global myarduino;
load(strcat(get(handles.uname,'String'),'.mat'),'HMM','states');
sys_recorder=audiorecorder;
dat=[];
word_encountered=0;
end_pointer=1;
word_begin=0;word_end=0;
record(sys_recorder);
pause(0.5);
begin_pointer=1;
index=1;
new_word=1;
while isstart==1
    bot_st=bot;
    new_word=0;
    pause(0.12);
    [end_pointer,~]=size(getaudiodata(sys_recorder));
    if end_pointer>begin_pointer+500
        for i=begin_pointer:500:(end_pointer-500)
            dat=getaudiodata(sys_recorder);
            temp_mean=mean(abs(dat(i:i+500)));
            if temp_mean > 0.02
                if word_encountered==0
                    word_begin=i;
                    word_encountered=1;
                end
            else
                if word_encountered==1
                    word_encountered=0;
                    word_end=i+500;
                    dat=getaudiodata(sys_recorder);
                    dat=dat(word_begin:word_end);
                    stop(sys_recorder);
                    
                    if word_end-word_begin > 1500
                        wavplay(dat);
                        Observation=trial_feature_analysis(dat);
                        p=trial_viterbi(states,HMM{1,1},HMM{1,2},HMM{1,3},Observation);
                        w=1;
                        %disp(p);
                        for j=2:4
                            temp_p=trial_viterbi(states,HMM{j,1},HMM{j,2},HMM{j,3},Observation);
                            if temp_p>p
                                p=temp_p;
                                w=j;
                            end
                            % disp(temp_p);
                        end
                        disp(p);
                        if p < 1e-25
                            set(handles.num,'String','No Match');
                        else
                            switch(w)
                                case 1 , set(handles.num,'String','forward');
                                    if isconnect==1
                                        disp('forward');
                                        if bot_st==0
                                            move('forward',myarduino);
                                        else
                                            walk('forward',myarduino);
                                        end;
                                    end
                                    
                                case 2 ,set(handles.num,'String','back');
                                    if isconnect==1 
                                    disp('back');
                                        if bot_st==0
                                            move('back',myarduino);
                                        else
                                            walk('back',myarduino);
                                        end;
                                    end
                                    
                                case 3 ,set(handles.num,'String','left');
                                    if isconnect==1 
                                    disp('left');
                                        if bot_st==0
                                            move('left',myarduino);
                                        else
                                            walk('left',myarduino);
                                        end;
                                    end
                                    
                                case 4 ,set(handles.num,'String','right');
                                    if isconnect==1 
                                    disp('right');
                                        if bot_st==0
                                            move('right',myarduino);
                                        else
                                            walk('right',myarduino);
                                        end;
                                    end
                                    
                            end;
                        end;
                    end
                    
                    new_word=1;
                    break
                end
            end
        end
    end
    if new_word == 0
        begin_pointer=end_pointer;
    else
        record(sys_recorder);
        pause(0.2);
        begin_pointer=1;
    end
end
stop(sys_recorder);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
set(hObject,'Visible','off');
set(handles.start,'Visible','on');
global isstart;
isstart=0;
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ardu.
function ardu_Callback(hObject, eventdata, handles)
dummy=warndlg('Please Ensure that you will enter correct PORT, ensure that Arduino is Perfectly Connected and you had uploaded pde library');
waitfor(dummy);
port=inputdlg('Enter Port To Connect Arduino','PORT',1,{'COM6'});
% hObject    handle to ardu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isconnect;
global myarduino;
global bot;
myarduino=0;
pause(1);
if size(port)==[0 0]
    myarduino=0;
else
    set(handles.num,'FontSize',50);
    set(handles.num,'String','Connecting....');
    myarduino=arduino(port{1,1});
    if myarduino~=0
        myarduino.pinMode(11,'output');
        myarduino.pinMode(10,'output');
        myarduino.pinMode(19,'output');
        myarduino.pinMode(3,'output');
        set(hObject,'Visible','off');
        set(handles.disconnect,'Visible','on');
        isconnect=1;
        set(handles.num,'FontSize',70);
        set(handles.num,'String','Result');
        answer= questdlg('Which bot you have connected?','Choose bot','Rf-bot','Biped','Rf-bot');
        bot=strcmp(answer,'Biped');
    else isconnect=0;
        set(handles.num,'FontSize',70);
        set(handles.num,'String','Result');
        warndlg('Arduino Connection Failed. Please check Port No. or Check USB cable is properly plugged in or check whether you had uploaded pde library in arduino');
    end
end;

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
stop_Callback(hObject, eventdata, handles)
delete(instrfind({'Port'},{'COM6'}))
final;
delete(get(hObject, 'parent'));
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
stop_Callback(hObject, eventdata, handles);
delete(instrfind({'Port'},{'COM6'}));
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
final;
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in menu.
function menu_Callback(hObject, eventdata, handles)
stop_Callback(hObject, eventdata, handles);
delete(instrfind({'Port'},{'COM6'}));
welcome;
delete(get(hObject, 'parent'));
% hObject    handle to menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in disconnect.
function disconnect_Callback(hObject, eventdata, handles)
stop_Callback(hObject, eventdata, handles);
delete(instrfind({'Port'},{'COM6'}));
set(hObject,'Visible','off');
set(handles.ardu,'Visible','on');
% hObject    handle to disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
