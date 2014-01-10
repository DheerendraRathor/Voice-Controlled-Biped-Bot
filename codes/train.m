function varargout = train(varargin)
% TRAIN MATLAB code for train.fig
%      TRAIN, by itself, creates a new TRAIN or raises the existing
%      singleton*.
%
%      H = TRAIN returns the handle to a new TRAIN or the handle to
%      the existing singleton*.
%
%      TRAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAIN.M with the given input arguments.
%
%      TRAIN('Property','Value',...) creates a new TRAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before train_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to train_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help train

% Last Modified by GUIDE v2.5 25-May-2013 00:53:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @train_OpeningFcn, ...
                   'gui_OutputFcn',  @train_OutputFcn, ...
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


% --- Executes just before train is made visible.
function train_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to train (see VARARGIN)

% Choose default command line output for train
handles.output = hObject;
handles.recog=[];
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
bg = imread('training.jpg'); imagesc(bg);
set(ah,'handlevisibility','off','visible','off');
uistack(ah, 'bottom');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes train wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = train_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ins.
function ins_Callback(hObject, eventdata, handles)
S={'You have to tarin the systems for four words.' ;'The words will come in the following sequence : forward , back , left , right. You have to speak all the words 5 time each.';' You see the word only when you have to speak them. And you have to speak in 5 seconds only ';'After speaking your word gets recorded and you can listen it. Add it only when it is correct otherwise try speaking next time. ';' If you dont see any thing then please wait.. there are some internal processes which takes palce'};
helpdlg(S,'Instruction');
set(handles.begin,'Visible','On');
% hObject    handle to ins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in begin.
function begin_Callback(hObject, eventdata, handles)
% hObject    handle to begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
set(handles.begin,'Visible','Off');
HMM=cell(4,3);
states=6;
disp('try-- forward -- back -- left -- right');
for i=1:4
    disp('try a word training');
    name='';
    switch(i)
        case 1 , name='forward';
        case 2 , name='back';
        case 3 , name='left';
        case 4 , name='right';
    end;    
    [HMM{i,1},HMM{i,2},HMM{i,3}]=trial_train(handles,name);
end
save(strcat(get(handles.user,'String'),'.mat'),'HMM','states');
handles.recog=recognition;
recog_data=guidata(handles.recog);
set(recog_data.uname,'String',get(handles.user,'String'));
delete(get(hObject,'parent'));
% handles    structure with handles and user data (see GUIDATA)

function signal=trial_playwords(handles,name)

t=5;
re=audiorecorder;
%disp('start speaking now');
time=5;
set(handles.display,'String',name);     
record(re);
while time>0,
   set(handles.timer,'String',num2str(time)); 
   time=time-1;
   pause(1);
end;
stop(re);
set(handles.timer,'String',num2str(5));     
set(handles.display,'String','');    
dat=getaudiodata(re);
disp('recording over , calculating words');
A=giveallword(dat);
disp('words calculated , now listen them');
A=largerwords(A);
[l,~]=size(A);

signal=[];
%giving option to select which part to select
if l~=0
    
    for i=1:l    
        st=dat(A(i,1):A(i,2));
        listen=msgbox('Listen recorded word','Listen');
        waitfor(listen);
        wavplay(st);
        reply=questdlg('Do you want to include this?');
        if strcmp(reply,'Yes')
            signal=st;
            break
        end
    end
    
end

function [PI_ret,A_ret,B_ret]=trial_train(handles,name)
% training
R=5; % 5 times to be trained 
parameters=cell(R,4);

%initial arbid condition
N_states=6;
PI_matrix=[0.2 0.2 0.2 0.2 0.2 0.2];
B_matrix=cell(2,N_states);
A_matrix=[0.5 0.5 0 0 0 0;0 0.5 0.5 0 0 0;0 0 0.5 0.5 0 0;0 0 0 0.5 0.5 0;0 0 0 0 0.5 0.5;0 0 0 0 0 0.5];

Tr=zeros(R,1);%length of training sequence for each train
Obr=cell(R,1);
segments=cell(N_states,1);
%storing the values
for r=1:R
    
    disp('start next training for same word');
    while 1
        signal=trial_playwords(handles,name);
        [l,~]=size(signal);
        if l~=0
            feature_vector=trial_feature_analysis(signal);

            O=feature_vector;
            Obr{r,1}=O;
            [l,~]=size(feature_vector);
            Tr(r)=l;
            n=floor(l/6);

            for i=0:N_states-1
                segments{i+1,1}=[segments{i+1,1};feature_vector((i*n+1):((i+1)*n),:)];
            end
            break
        end
    end
    
end

for i=1:N_states
    B_matrix{1,i}=mean(segments{i,1});
    B_matrix{2,i}=cov(segments{i,1});
end

for r=1:R
    alpha_matrix=trial_alpha(N_states,PI_matrix,A_matrix,B_matrix,Obr{r,1});
    beta_matrix=trial_beta(N_states,PI_matrix,A_matrix,B_matrix,Obr{r,1});
    gamma_matrix=trial_gamma(N_states,PI_matrix,A_matrix,B_matrix,Obr{r,1});
    eta_matrix=trial_eta(N_states,PI_matrix,A_matrix,B_matrix,Obr{r,1});
    parameters{r,1}=alpha_matrix;
    parameters{r,2}=beta_matrix;
    parameters{r,3}=gamma_matrix;
    parameters{r,4}=eta_matrix;
end

session=1;% number of training sessions
for k=1:session
    temp_PI_matrix=[0.2 0.2 0.2 0.2 0.2 0.2];
    temp_B_matrix=cell(2,N_states);
    temp_A_matrix=[0.5 0.5 0 0 0 0;0 0.5 0.5 0 0 0;0 0 0.5 0.5 0 0;0 0 0 0.5 0.5 0;0 0 0 0 0.5 0.5;0 0 0 0 0 0.5];
    %estimation of PI
    for i=1:N_states
        num=0;den=0;
        for r=1:R
            num=num+parameters{r,1}(i,1)*parameters{r,2}(i,1);
            temp_den=0;
            for j=1:N_states
                temp_den=temp_den+parameters{r,1}(j,1)*parameters{r,2}(j,1);
            end
            den=den+temp_den;
        end
        temp_PI_matrix(i)=num/den;
    end
    
    %estimation of A matrix
    for i=1:N_states
        for j=1:N_states
            num=0;den=0;
            for r=1:R
                for t=1:Tr(r)-1
                    num=num+parameters{r,1}(i,t)*A_matrix(i,j)*b_ik(B_matrix,j,Obr{r,1}(t+1,:))*parameters{r,2}(j,t+1);
                    den=den+parameters{r,1}(i,t)*parameters{r,2}(i,t);
                end
            end
            temp_A_matrix(i,j)=num/den;
        end
    end
    
    %estimation for B_matrix
    for j=1:N_states
        num1=0;den1=0;
        num2=0;den2=0;
        for r=1:R
            for t=1:Tr(r)
                num1=num1+parameters{r,3}(j,t)*Obr{r,1}(t,:);
                den1=den1+parameters{r,3}(j,t);
                num2=num2+parameters{r,3}(j,t)*((Obr{r,1}(t,:)-B_matrix{1,j})'*(Obr{r,1}(t,:)-B_matrix{1,j}));
                den2=den1;
            end
        end
        temp_B_matrix{1,j}=num1/den1;
        temp_B_matrix{2,j}=num2/den2;
    end
    
    %reallocating the estimations made
    PI_matrix=temp_PI_matrix;
    A_matrix=temp_A_matrix;
    B_matrix=temp_B_matrix;
end
PI_ret=PI_matrix;
A_ret=A_matrix;
B_ret=B_matrix;


% --- Executes during object creation, after setting all properties.
function display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
