function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 05-Jul-2017 14:12:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @main_OpeningFcn, ...
    'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

set(handles.popupmenu1, 'String', {
    'Video Stabilization',...
    'Background removal',...
    'Matting'...
    'Object Tracking'});

handles = getParams(handles);

% handles = popupmenu2_Callback(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

set(handles.pushbutton2, 'Enable', 'off');
set(handles.popupmenu1, 'Enable', 'off');
set(handles.pushbutton1, 'Enable', 'off');
% Get selection on popupmenu
list = get(handles.popupmenu1, 'String');
index = get(handles.popupmenu1, 'Value');
selection = list(index);
codePath = pwd;
basePath = codePath(1:end-4);
inputVideosPath = strcat(basePath,'Input');
outputVideosPath = strcat(basePath,'Output');

try
    switch selection{1}
        case 'Video Stabilization'
            [filename, pathname] = uigetfile(strcat(inputVideosPath,'\*.avi'), 'Select the input video file');
            if ~isequal(filename,0)
                inputVideoPath = fullfile(pathname, filename);
                outStabilizationPath = fullfile(outputVideosPath,'stabilized.avi');
                set(handles.text2, 'String', 'Doing video stabilization');
                videoStabilization(inputVideoPath, outStabilizationPath, handles.params.Stabilization, handles.text3);
                set(handles.text2, 'String', 'DONE doing video stabilization');
                set(handles.text3, 'String', ' ');
                
            end
        case 'Background removal'
            [filename, pathname] = uigetfile(strcat(outputVideosPath,'\*.avi'), 'Select the stable video file');
            if ~isequal(filename,0)
                inputVideoPath = fullfile(pathname, filename);
                outExtractedPath = fullfile(pathname,'extracted.avi');
                outBinaryPath = fullfile(pathname,'binary.avi');
                set(handles.text2, 'String', 'Doing background substraction');
                videoBackgroundRemoval(inputVideoPath, outExtractedPath, outBinaryPath, handles.params.BackgroundRemoval,handles.text3);
                set(handles.text2, 'String', 'DONE doing background substraction');
                set(handles.text3, 'String', ' ');
            end
        case 'Matting'
            [filenameStable, pathnameStable] = uigetfile(strcat(outputVideosPath,'\*.avi'), 'Select the stable video file');
            [filenameBinary, pathnameBinary] = uigetfile(strcat(outputVideosPath,'\*.avi'), 'Select the binary video file');
            [filenameNewBG, pathnameNewBG] = uigetfile(strcat(inputVideosPath,'\*.jpg'), 'Select the new background image');
            if isequal(filenameStable,0) || isequal(filenameBinary,0) || isequal(filenameNewBG,0)
            else
                stabilizationPath = fullfile(pathnameStable, filenameStable);
                binaryPath = fullfile(pathnameBinary, filenameBinary);
                newBGPath = fullfile(pathnameNewBG, filenameNewBG);
                outNewBackgroundPath = fullfile(pathnameBinary, 'matting.avi');
                set(handles.text2, 'String', 'Doing new background matting');
                videoNewBackground(stabilizationPath,...
                    binaryPath,...
                    outNewBackgroundPath,...
                    newBGPath,...
                    handles.params.Matting,...
                    handles.text3);
                set(handles.text2, 'String', 'DONE doing Matting');
                set(handles.text3, 'String', ' ');
            end
        case 'Object Tracking'
            [filenameTrack, pathnameTrack] = uigetfile(strcat(outputVideosPath,'\*.avi'), 'Select matted video');
            InputVid = fullfile(pathnameTrack,filenameTrack);
            imageTry = readFrame(VideoReader(fullfile(pathnameTrack,filenameTrack)));
            imshow(imageTry, 'Parent', handles.axes1);
            h = msgbox('Please use mouse and draw a rectangle (imrect) to select the object to be tracked', 'modal');
            % Call user select tracker
            rect = getPosition(imrect(handles.axes1));
            rectO = floor([rect(1)+rect(3)/2 rect(2)+rect(4)/2 rect(3)/2 rect(4)/2]);
            userPoints = [rectO 0 0];
            % Call video tracker
            outTrackingVideo = fullfile(pathnameTrack,'OUTPUT.avi');
            set(handles.text2, 'String', 'Doing object tracking');
            videoTracker(InputVid, outTrackingVideo, handles.params.Tracking, userPoints',handles.text3);
            set(handles.text2, 'String', 'DONE doing object tracking');
            set(handles.text3, 'String', ' ');  
    end
catch err
    set(handles.pushbutton2, 'Enable', 'on');
    set(handles.popupmenu1, 'Enable', 'on');
    set(handles.pushbutton1, 'Enable', 'on');
    rethrow(err)
end
set(handles.pushbutton2, 'Enable', 'on');
set(handles.popupmenu1, 'Enable', 'on');
set(handles.pushbutton1, 'Enable', 'on');

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

codePath = pwd;
basePath = codePath(1:end-4);
inputVideosPath = strcat(basePath,'Input');
outputVideosPath = strcat(basePath,'Output');

[filename, pathname] = uigetfile(strcat(outputVideosPath,'\*.avi'), 'Select video to play');
if ~isequal(filename,0)
    set(handles.pushbutton1, 'Enable', 'off');
    set(handles.popupmenu1, 'Enable', 'off');
    set(handles.pushbutton2, 'Enable', 'off');
    videoToPlay = fullfile(pathname, filename);
    try
        obj = VideoReader(videoToPlay);
    catch
        warndlg( 'File named in edit box does not appear to be a usable movie file');
        set(handles.pushbutton1, 'Enable', 'on');
        set(handles.popupmenu1, 'Enable', 'on');
        set(handles.pushbutton2, 'Enable', 'on');
        return
    end
    ax = handles.axes1;
    % Play video on axis
    set(ax, 'Visible', 'off');
    while hasFrame(obj)
        vidFrame = readFrame(obj);
        image(vidFrame, 'Parent', ax);
        pause(1/obj.FrameRate);
    end
    set(handles.pushbutton1, 'Enable', 'on');
    set(handles.popupmenu1, 'Enable', 'on');
    set(handles.pushbutton2, 'Enable', 'on');
    clear obj
end

% --- Executes on selection change in popupmenu2.
function handles = popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

% Get selection on popupmenu

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
