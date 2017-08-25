function varargout = SignalModel3D(varargin)
% SIGNALMODEL3D MATLAB code for SignalModel3D.fig
%      SIGNALMODEL3D, by itself, creates a new SIGNALMODEL3D or raises the existing
%      singleton*.
%
%      H = SIGNALMODEL3D returns the handle to a new SIGNALMODEL3D or the handle to
%      the existing singleton*.
%
%      SIGNALMODEL3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGNALMODEL3D.M with the given input arguments.
%
%      SIGNALMODEL3D('Property','Value',...) creates a new SIGNALMODEL3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SignalModel3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SignalModel3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SignalModel3D

% Last Modified by GUIDE v2.5 19-Jul-2017 14:10:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SignalModel3D_OpeningFcn, ...
                   'gui_OutputFcn',  @SignalModel3D_OutputFcn, ...
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

% --- Executes just before SignalModel3D is made visible.
function SignalModel3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SignalModel3D (see VARARGIN)

% Choose default command line output for SignalModel3D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using SignalModel3D.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes SignalModel3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);

