function varargout = final_project(varargin)
% FINAL_PROJECT MATLAB code for final_project.fig
%      FINAL_PROJECT, by itself, creates a new FINAL_PROJECT or raises the existing
%      singleton*.
%
%      H = FINAL_PROJECT returns the handle to a new FINAL_PROJECT or the handle to
%      the existing singleton*.
%
%      FINAL_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL_PROJECT.M with the given input arguments.
%
%      FINAL_PROJECT('Property','Value',...) creates a new FINAL_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final_project

% Last Modified by GUIDE v2.5 01-Dec-2022 14:52:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_project_OpeningFcn, ...
                   'gui_OutputFcn',  @final_project_OutputFcn, ...
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


% --- Executes just before final_project is made visible.
function final_project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final_project (see VARARGIN)

% Choose default command line output for final_project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final_project wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global output_img
global changeFlag
changeFlag=0;
global x
global y
global topRightCrop
global topLeftCrop
global leftTopCrop
global leftBottomCrop
global cropMask
global k
k=0;
global enhance_cnt
enhance_cnt=0;

% --- Outputs from this function are returned to the command line.
function varargout = final_project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function imgName_Callback(hObject, eventdata, handles)
% hObject    handle to imgName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imgName as text
%        str2double(get(hObject,'String')) returns contents of imgName as a double
global output_img
original_img=get(handles.imgName,'String');
output_img=imread(get(handles.imgName,'String'));
axes(handles.originalimg);  
imshow(original_img);
axes(handles.outputimg);  
imshow(output_img);


[M,N,color]=size(output_img);
%color tint
set(handles.tintR, 'Max',200, 'Value', 0, 'Min',-200);
set(handles.tintG, 'Max',200, 'Value', 0, 'Min',-200);
set(handles.tintB, 'Max',200, 'Value', 0, 'Min',-200);
    
%brightness
set(handles.brightness, 'Max',0.5, 'Value', 0, 'Min',-0.5);

%cropping
global cropMask
cropMask=uint8(ones(M,N));

global topRightCrop
topRightCrop=N;
set(handles.topRight, 'Max', N, 'Value', topRightCrop, 'Min', ceil(N/2));

global topLeftCrop
topLeftCrop=1;
set(handles.topLeft, 'Max', floor(N/2), 'Value', topLeftCrop, 'Min', 1);

global leftTopCrop
leftTopCrop=floor(M/2);
set(handles.leftTop, 'Max', floor(M/2), 'Value', leftTopCrop, 'Min', 1);

global leftBottomCrop
leftBottomCrop=ceil(M/2);
set(handles.leftBottom, 'Max', M, 'Value', leftBottomCrop, 'Min', ceil(M/2));


% --- Executes during object creation, after setting all properties.
function imgName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global output_img
global topRightCrop
global topLeftCrop
global leftTopCrop
global leftBottomCrop

[M,N,color]=size(output_img);
temp=floor(M/2)-leftTopCrop;
if(temp==0)%to prevent the index becoming 0
    temp=1;
end
if(color>1)
    red=output_img(:,:,1);
    red=red(temp:M-(leftBottomCrop-ceil(M/2)),topLeftCrop:topRightCrop);
    green=output_img(:,:,2);
    green=green(temp:M-(leftBottomCrop-ceil(M/2)),topLeftCrop:topRightCrop);
    blue=output_img(:,:,3);
    blue=blue(temp:M-(leftBottomCrop-ceil(M/2)),topLeftCrop:topRightCrop);
    output_img=cat(3,red,green,blue);
else
    output_img=output_img(temp:M-(leftBottomCrop-ceil(M/2)),topLeftCrop:topRightCrop);
end

global k
output_img=sharphening(output_img,k);
g=watermarking(output_img);
imwrite(g, 'result.jpg');
axes(handles.outputimg);  
imshow(g);


% --- Executes on slider movement.
function tintR_Callback(hObject, eventdata, handles)
% hObject    handle to tintR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global output_img
global cropMask
global k
tintRvalue = handles.tintR.Value;

[a,b,color]=size(output_img);
if(color>1)
    if(tintRvalue>=0)
        output_img(:,:,1)=rescale(output_img(:,:,1),tintRvalue,255);
    elseif(tintRvalue<0)
        output_img(:,:,1)=rescale(output_img(:,:,1),0,255+tintRvalue);
    end
else
    if(tintRvalue>=0)
        output_img=rescale(output_img,tintRvalue,255);
    elseif(tintRvalue<0)
        output_img=rescale(output_img,0,255+tintRvalue);
    end
    set(handles.tintG, 'Value', tintRvalue);
    set(handles.tintB, 'Value', tintRvalue);
    output_img=uint8(output_img);
end

axes(handles.outputimg); 
imshow(sharphening(output_img,k).*cropMask);


% --- Executes during object creation, after setting all properties.
function tintR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tintR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function tintG_Callback(hObject, eventdata, handles)
% hObject    handle to tintG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global output_img
global cropMask
global k
tintGvalue = handles.tintG.Value;

[a,b,color]=size(output_img);
if(color>1)
    if(tintGvalue>=0)
        output_img(:,:,2)=rescale(output_img(:,:,2),tintGvalue,255);
    elseif(tintGvalue<0)
        output_img(:,:,2)=rescale(output_img(:,:,2),0,255+tintGvalue);
    end
else
    if(tintGvalue>=0)
        output_img=rescale(output_img,tintGvalue,255);
    elseif(tintGvalue<0)
        output_img=rescale(output_img,0,255+tintGvalue);
    end
    set(handles.tintR, 'Value', tintGvalue);
    set(handles.tintB, 'Value', tintGvalue);
    output_img=uint8(output_img);
end
axes(handles.outputimg);  
imshow(sharphening(output_img,k).*cropMask);



% --- Executes during object creation, after setting all properties.
function tintG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tintG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function tintB_Callback(hObject, eventdata, handles)
% hObject    handle to tintB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global output_img
global cropMask
global k

tintBvalue = handles.tintB.Value;
[a,b,color]=size(output_img);
if(color>1)
    if(tintBvalue>=0)
        output_img(:,:,3)=rescale(output_img(:,:,3),tintBvalue,255);
    elseif(tintBvalue<0)
        output_img(:,:,3)=rescale(output_img(:,:,3),0,255+tintBvalue);
    end
else
    if(tintBvalue>=0)
        output_img=rescale(output_img,tintBvalue,255);
    elseif(tintBvalue<0)
        output_img=rescale(output_img,0,255+tintBvalue);
    end
    set(handles.tintG, 'Value', tintBvalue);
    set(handles.tintR, 'Value', tintBvalue);
    output_img=uint8(output_img);
end
axes(handles.outputimg);  
imshow(sharphening(output_img,k).*cropMask);

% --- Executes during object creation, after setting all properties.
function tintB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tintB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function shearV_Callback(hObject, eventdata, handles)
% hObject    handle to shearV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shearV as text
%        str2double(get(hObject,'String')) returns contents of shearV as a double
global output_img
global cropMask
global k
sv=str2double(get(hObject,'String'));
[m,n,color]=size(output_img);
if(color>1)
    output_img(:,:,1)=imageShear4e(output_img(:,:,1),sv,0);
    output_img(:,:,2)=imageShear4e(output_img(:,:,2),sv,0);
    output_img(:,:,3)=imageShear4e(output_img(:,:,3),sv,0);
else
    output_img=imageShear4e(output_img,sv,0);
end
axes(handles.outputimg);  
imshow(sharphening(output_img,k).*cropMask);


% --- Executes during object creation, after setting all properties.
function shearV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shearV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function shearH_Callback(hObject, eventdata, handles)
% hObject    handle to shearH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shearH as text
%        str2double(get(hObject,'String')) returns contents of shearH as a double
global output_img
global cropMask
global k
sh=str2double(get(hObject,'String'));
[m,n,color]=size(output_img);
if(color>1)
    output_img(:,:,1)=imageShear4e(output_img(:,:,1),0,sh);
    output_img(:,:,2)=imageShear4e(output_img(:,:,2),0,sh);
    output_img(:,:,3)=imageShear4e(output_img(:,:,3),0,sh);
else
    output_img=imageShear4e(output_img,0,sh);
end
axes(handles.outputimg);  
imshow(sharphening(output_img,k).*cropMask);

% --- Executes during object creation, after setting all properties.
function shearH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shearH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scaleX_Callback(hObject, eventdata, handles)
% hObject    handle to scaleX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scaleX as text
%        str2double(get(hObject,'String')) returns contents of scaleX as a double
global output_img
cx=str2double(get(hObject,'String'));

[M,N,color]=size(output_img);
if(color>1)
    output_img=cat(3,imresize(output_img(:,:,1),[M,N*cx]),imresize(output_img(:,:,2),[M,N*cx]),imresize(output_img(:,:,3),[M,N*cx]));
else
    output_img=imresize(output_img,[M,N*cx]);
end

%size of ouput_img is changed->change global variables related to size
[M,N,color]=size(output_img);
global k
k=0;
global cropMask
cropMask=uint8(ones(M,N));
global topRightCrop
topRightCrop=N;
set(handles.topRight, 'Max', N, 'Value', topRightCrop, 'Min', ceil(N/2));

global topLeftCrop
topLeftCrop=1;
set(handles.topLeft, 'Max', floor(N/2), 'Value', topLeftCrop, 'Min', 1);

global leftTopCrop
leftTopCrop=floor(M/2);
set(handles.leftTop, 'Max', floor(M/2), 'Value', leftTopCrop, 'Min', 1);

global leftBottomCrop
leftBottomCrop=ceil(M/2);
set(handles.leftBottom, 'Max', M, 'Value', leftBottomCrop, 'Min', ceil(M/2));

axes(handles.outputimg);  
imshow(output_img);

% --- Executes during object creation, after setting all properties.
function scaleX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaleX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scaleY_Callback(hObject, eventdata, handles)
% hObject    handle to scaleY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scaleY as text
%        str2double(get(hObject,'String')) returns contents of scaleY as a double
global output_img
cy=str2double(get(hObject,'String'));

[M,N,color]=size(output_img);
if(color>1)
    output_img=cat(3,imresize(output_img(:,:,1),[M*cy,N]),imresize(output_img(:,:,2),[M*cy,N]),imresize(output_img(:,:,3),[M*cy,N]));
else
    output_img=imresize(output_img,[M*cy,N]);
end

%size of ouput_img is changed->change global variables related to size
[M,N,color]=size(output_img);
global k
k=0;
global cropMask
cropMask=uint8(ones(M,N));
global topRightCrop
topRightCrop=N;
set(handles.topRight, 'Max', N, 'Value', topRightCrop, 'Min', ceil(N/2));

global topLeftCrop
topLeftCrop=1;
set(handles.topLeft, 'Max', floor(N/2), 'Value', topLeftCrop, 'Min', 1);

global leftTopCrop
leftTopCrop=floor(M/2);
set(handles.leftTop, 'Max', floor(M/2), 'Value', leftTopCrop, 'Min', 1);

global leftBottomCrop
leftBottomCrop=ceil(M/2);
set(handles.leftBottom, 'Max', M, 'Value', leftBottomCrop, 'Min', ceil(M/2));

axes(handles.outputimg);  
imshow(output_img);

% --- Executes during object creation, after setting all properties.
function scaleY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaleY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotateDegree_Callback(hObject, eventdata, handles)
% hObject    handle to rotateDegree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotateDegree as text
%        str2double(get(hObject,'String')) returns contents of rotateDegree as a double
global output_img
global cropMask
global k
degree=str2double(get(hObject,'String'));
[m,n,color]=size(output_img);
if(color>1)
    output_img=cat(3,imrotate(output_img(:,:,1),degree),imrotate(output_img(:,:,2),degree),imrotate(output_img(:,:,3),degree));
else
    output_img=imrotate(output_img,degree);
end

%size of ouput_img is changed->change global variables related to size
[M,N,color]=size(output_img);
global k
k=0;
global cropMask
cropMask=uint8(ones(M,N));
global topRightCrop
topRightCrop=N;
set(handles.topRight, 'Max', N, 'Value', topRightCrop, 'Min', ceil(N/2));

global topLeftCrop
topLeftCrop=1;
set(handles.topLeft, 'Max', floor(N/2), 'Value', topLeftCrop, 'Min', 1);

global leftTopCrop
leftTopCrop=floor(M/2);
set(handles.leftTop, 'Max', floor(M/2), 'Value', leftTopCrop, 'Min', 1);

global leftBottomCrop
leftBottomCrop=ceil(M/2);
set(handles.leftBottom, 'Max', M, 'Value', leftBottomCrop, 'Min', ceil(M/2));

axes(handles.outputimg);  
imshow(sharphening(output_img,k).*cropMask);

% --- Executes during object creation, after setting all properties.
function rotateDegree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotateDegree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sharpeningK_Callback(hObject, eventdata, handles)
% hObject    handle to sharpeningK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global output_img
global cropMask
global k
k=get(hObject,'Value');
%For undo, don't overwrite the output_img and just update k
%When other functions are called, show after sharphened with current k
%When save button is pushed, overwrite to output_img

axes(handles.outputimg);
imshow(sharphening(output_img,k).*cropMask);

% --- Executes during object creation, after setting all properties.
function sharpeningK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sharpeningK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in enhancement.
function enhancement_Callback(hObject, eventdata, handles)
% hObject    handle to enhancement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enhancement

global output_img
global cropMask
global k
global enhance_cnt
%Image enhancement is limited to performed once.
%In case of grayscale, we can't convert to hsv so doesn't perform
if(enhance_cnt==0)
    [r,c,color]=size(output_img);
    if(color>1)
        output_img(:,:,1)=hist_eq(output_img(:,:,1));
        output_img(:,:,2)=hist_eq(output_img(:,:,2));
        output_img(:,:,3)=hist_eq(output_img(:,:,3));
    else
        output_img=hist_eq(output_img);
    end
    enhance_cnt=enhance_cnt+1;
else
    return
end
axes(handles.outputimg);  
imshow(sharphening(output_img,k).*cropMask);

% --- Executes on button press in colorChange.
function colorChange_Callback(hObject, eventdata, handles)
% hObject    handle to colorChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of colorChange
global changeFlag
changeFlag=get(hObject,'Value');
global output_img
[M,N]=size(output_img);
global changeArea
global x
global y
[m,n,color]=size(output_img);
if(changeFlag==1)%if color change button is selected
    while 1
        [x,y]=ginput(1);
        x=uint32(x);
        y=uint32(y);
        if(x>=1 && x<=M && y>=1 && y<=N)%check if the user is clicking inside the image       
            if(color>1)
                %select the area which will change by color segmentation
                m=[output_img(y,x,1),output_img(y,x,2),output_img(y,x,3)];
                changeArea=colorSeg4e(output_img,m,20);

                red=output_img(:,:,1);
                green=output_img(:,:,2);
                blue=output_img(:,:,3);

                %change R,G,B silder max, min
                set(handles.changeR, 'Max', 255-(max(red(changeArea))), 'Value', 0, 'Min', -double(min(red(changeArea))));
                set(handles.changeG, 'Max', 255-(max(green(changeArea))), 'Value', 0, 'Min', -double(min(green(changeArea))));
                set(handles.changeB, 'Max', 255-(max(blue(changeArea))), 'Value', 0, 'Min', -double(min(blue(changeArea))));
            else
                m=[output_img(y,x)];
                changeArea=colorSeg4e(output_img,m,20);
                set(handles.changeR, 'Max', 255-(max(output_img(changeArea))), 'Value', 0, 'Min', -double(min(output_img(changeArea))));
                set(handles.changeG, 'Max', 255-(max(output_img(changeArea))), 'Value', 0, 'Min', -double(min(output_img(changeArea))));
                set(handles.changeB, 'Max', 255-(max(output_img(changeArea))), 'Value', 0, 'Min', -double(min(output_img(changeArea))));
            end
            break
        end
    end
end

% --- Executes on slider movement.
function changeR_Callback(hObject, eventdata, handles)
% hObject    handle to changeR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global changeFlag
global output_img
global cropMask
global change_prev_r
global changeArea
global k
[m,n,color]=size(output_img);
if(changeFlag==1)
    changeRValue=handles.changeR.Value;
    if(color>1)
        red=output_img(:,:,1);
        red(changeArea)=red(changeArea)+(changeRValue-change_prev_r);%add the amount of change
        output_img(:,:,1)=red;
    else
        output_img(changeArea)=output_img(changeArea)+(changeRValue-change_prev_r);
        set(handles.changeG, 'Value', changeRValue);
        set(handles.changeB, 'Value', changeRValue);
    end
    change_prev_r=changeRValue;
    imshow(sharphening(output_img,k).*cropMask);
end

% --- Executes during object creation, after setting all properties.
function changeR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function changeG_Callback(hObject, eventdata, handles)
% hObject    handle to changeG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global changeFlag
global output_img
global cropMask
global change_prev_g
global changeArea
global k
[m,n,color]=size(output_img);
if(changeFlag==1)
    changeGValue=handles.changeG.Value;
    if(color>1)
        green=output_img(:,:,2);
        green(changeArea)=green(changeArea)+(changeGValue-change_prev_g);
        output_img(:,:,2)=green;
    else
        output_img(changeArea)=output_img(changeArea)+(changeGValue-change_prev_g);
        set(handles.changeR, 'Value', changeGValue);
        set(handles.changeB, 'Value', changeGValue);
    end
    change_prev_g=changeGValue;
    imshow(sharphening(output_img,k).*cropMask);
end

% --- Executes during object creation, after setting all properties.
function changeG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function changeB_Callback(hObject, eventdata, handles)
% hObject    handle to changeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global changeFlag
global output_img
global cropMask
global change_prev_b
global changeArea
global k
[m,n,color]=size(output_img);
if(changeFlag==1)
    changeBValue=handles.changeB.Value;
    if(color>1)
        blue=output_img(:,:,3);
        blue(changeArea)=blue(changeArea)+(changeBValue-change_prev_b);
        output_img(:,:,3)=blue;
    else
        output_img(changeArea)=output_img(changeArea)+(changeBValue-change_prev_b);
        set(handles.changeG, 'Value', changeBValue);
        set(handles.changeR, 'Value', changeBValue);
    end
    change_prev_b=changeBValue;
    imshow(sharphening(output_img,k).*cropMask);
end

% --- Executes during object creation, after setting all properties.
function changeB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function topRight_Callback(hObject, eventdata, handles)
% hObject    handle to topRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global output_img
global topRightCrop
global topLeftCrop
global leftTopCrop
global leftBottomCrop
global cropMask
global k
[M,N,color]=size(output_img);
set(handles.topRight, 'Max', N, 'Min', ceil(N/2));
topRightCrop=handles.topRight.Value;

%make new cropMask
cropMask=uint8(ones(M,N));

if(topRightCrop~=N)
    cropMask(:,topRightCrop:N)=0;
end
if(topLeftCrop~=1)
    cropMask(:,1:topLeftCrop)=0;
end
if(leftTopCrop~=floor(M/2))
    cropMask(1:floor(M/2)-leftTopCrop,:)=0;
end
if(leftBottomCrop~=ceil(M/2))
    cropMask(M-(leftBottomCrop-ceil(M/2)):M,:)=0;
end

axes(handles.outputimg);
if(color>1)
    temp=cat(3, output_img(:,:,1).*cropMask, output_img(:,:,2).*cropMask, output_img(:,:,3).*cropMask); 
    imshow(sharphening(temp,k));
else
    imshow(sharphening(output_img,k).*cropMask);
end


% --- Executes during object creation, after setting all properties.
function topRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to topRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function topLeft_Callback(hObject, eventdata, handles)
% hObject    handle to topLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global output_img
global topRightCrop
global topLeftCrop
global leftTopCrop
global leftBottomCrop
global cropMask
global k
[M,N,color]=size(output_img);
set(handles.topLeft, 'Max', floor(N/2), 'Min', 1);
topLeftCrop=handles.topLeft.Value;

%make new cropMask
cropMask=uint8(ones(M,N));
if(topRightCrop~=N)
    cropMask(:,topRightCrop:N)=0;
end
if(topLeftCrop~=1)
    cropMask(:,1:topLeftCrop)=0;
end
if(leftTopCrop~=floor(M/2))
    cropMask(1:floor(M/2)-leftTopCrop,:)=0;
end
if(leftBottomCrop~=ceil(M/2))
    cropMask(M-(leftBottomCrop-ceil(M/2)):M,:)=0;
end

axes(handles.outputimg);
if(color>1)
    temp=cat(3, output_img(:,:,1).*cropMask, output_img(:,:,2).*cropMask, output_img(:,:,3).*cropMask); 
    imshow(sharphening(temp,k));
else
    imshow(sharphening(output_img,k).*cropMask);
end


% --- Executes during object creation, after setting all properties.
function topLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to topLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function leftTop_Callback(hObject, eventdata, handles)
% hObject    handle to leftTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global output_img
global topRightCrop
global topLeftCrop
global leftTopCrop
global leftBottomCrop
global cropMask
global k
[M,N,color]=size(output_img);
set(handles.leftTop, 'Max', floor(M/2), 'Min', 1);
leftTopCrop=handles.leftTop.Value;

%make new cropMask
cropMask=uint8(ones(M,N));
if(topRightCrop~=N)
    cropMask(:,topRightCrop:N)=0;
end
if(topLeftCrop~=1)
    cropMask(:,1:topLeftCrop)=0;
end
if(leftTopCrop~=floor(M/2))
    cropMask(1:floor(M/2)-leftTopCrop,:)=0;
end
if(leftBottomCrop~=ceil(M/2))
    cropMask(M-(leftBottomCrop-ceil(M/2)):M,:)=0;
end

axes(handles.outputimg);
if(color>1)
    temp=cat(3, output_img(:,:,1).*cropMask, output_img(:,:,2).*cropMask, output_img(:,:,3).*cropMask); 
    imshow(sharphening(temp,k));
else
    imshow(sharphening(output_img,k).*cropMask);
end

% --- Executes during object creation, after setting all properties.
function leftTop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function leftBottom_Callback(hObject, eventdata, handles)
% hObject    handle to leftTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global output_img
global topRightCrop
global topLeftCrop
global leftTopCrop
global leftBottomCrop
global cropMask
global k
[M,N,color]=size(output_img);
set(handles.leftBottom, 'Max', M, 'Min', ceil(M/2));
leftBottomCrop=handles.leftBottom.Value;

%make new cropMask
cropMask=uint8(ones(M,N));
if(topRightCrop~=N)
    cropMask(:,topRightCrop:N)=0;
end
if(topLeftCrop~=1)
    cropMask(:,1:topLeftCrop)=0;
end
if(leftTopCrop~=floor(M/2))
    cropMask(1:floor(M/2)-leftTopCrop,:)=0;
end
if(leftBottomCrop~=ceil(M/2))
    cropMask(M-(leftBottomCrop-ceil(M/2)):M,:)=0;
end

axes(handles.outputimg);
if(color>1)
    temp=cat(3, output_img(:,:,1).*cropMask, output_img(:,:,2).*cropMask, output_img(:,:,3).*cropMask); 
    imshow(sharphening(temp,k));
else
    imshow(sharphening(output_img,k).*cropMask);
end


% --- Executes during object creation, after setting all properties.
function leftBottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function brightness_Callback(hObject, eventdata, handles)
% hObject    handle to brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global output_img
global cropMask
global k
brightnessV=get(hObject,'Value');

[m,n,color]=size(output_img);
if(color>1)
    hsi_img=rgb2hsv(output_img);
    i=hsi_img(:,:,3);
    if(brightnessV>=0)
        hsi_img(:,:,3)=rescale(i,brightnessV,1);
    else
        hsi_img(:,:,3)=rescale(i,0,1+brightnessV);
    end
    output_img=uint8(hsv2rgb(hsi_img)*255);
else
    return %in case of grayscale, the user can adjust brightness by color tint sliders
end
imshow(sharphening(output_img,k).*cropMask);

% --- Executes during object creation, after setting all properties.
function brightness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end