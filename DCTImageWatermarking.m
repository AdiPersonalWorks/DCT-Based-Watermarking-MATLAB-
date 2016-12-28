function varargout = DCTImageWatermarking(varargin)
% DCTIMAGEWATERMARKING M-file for DCTImageWatermarking.fig
%      DCTIMAGEWATERMARKING, by itself, creates a new DCTIMAGEWATERMARKING or raises the existing
%      singleton*.
%
%      H = DCTIMAGEWATERMARKING returns the handle to a new DCTIMAGEWATERMARKING or the handle to
%      the existing singleton*.
%
%      DCTIMAGEWATERMARKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DCTIMAGEWATERMARKING.M with the given input arguments.
%
%      DCTIMAGEWATERMARKING('Property','Value',...) creates a new DCTIMAGEWATERMARKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DCTImageWatermarking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DCTImageWatermarking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DCTImageWatermarking

% Last Modified by GUIDE v2.5 04-Mar-2015 00:56:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DCTImageWatermarking_OpeningFcn, ...
    'gui_OutputFcn',  @DCTImageWatermarking_OutputFcn, ...
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


% --- Executes just before DCTImageWatermarking is made visible.
function DCTImageWatermarking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DCTImageWatermarking (see VARARGIN)

% Choose default command line output for DCTImageWatermarking
handles.output = hObject;

axes(handles.axes1); axis off
axes(handles.axes5); axis off
axes(handles.axes6); axis off
axes(handles.axes7); axis off
set(handles.wmimg,'Enable','off')
set(handles.emwm,'Enable','off')
set(handles.exwm,'Enable','off')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DCTImageWatermarking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DCTImageWatermarking_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close DCTImageWatermarking

% --- Executes on button press in exwm.
function exwm_Callback(hObject, eventdata, handles)
% hObject    handle to exwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
embimg=handles.embimg;
val_i_j=handles.val_i_j;

tic;
wm=exwmark(embimg,val_i_j);
rettime = toc;

% Calculating the Retrieval Time
set(handles.rettime,'String',rettime);

axes(handles.axes7); imshow(wm); title('Extracted watermark image')
handles.wm=wm;
ori_wm = handles.msg;

% Getting the different parameters for the original watermark vs the
% extracted watermark
[wm_ps,wm_ber,wm_mse,wm_ssim_out] = imageparams(wm,ori_wm);
msgbox({['Extracted watermark vs Original Watermark'];['PSNR: ',num2str(wm_ps)];['BER: ',num2str(wm_ber)];['MSE: ',num2str(wm_mse)];['SSIM: ',num2str(wm_ssim_out)]},'Parameters');

guidata(hObject,handles)

% --- Executes on button press in emwm.
function emwm_Callback(hObject, eventdata, handles)
% hObject    handle to emwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.img; msg=handles.msg;
h=warndlg('Please wait for the watermark to be embedded in the image.','Watermark Embedding in Progress');
pause(2)
close(h)

tic;
[im,embimg,val_i_j]=wtmark(img,msg);
embtime = toc;

% Calculating the embedding time
set(handles.embtime,'String',embtime);
%--------------------------------------------------------------------------
% To calculate the different parameters of the embedded image
[ps,ber,mse,ssim_out]=imageparams(im,embimg);

handles.embimg=embimg;
handles.val_i_j = val_i_j;
axes(handles.axes6); imshow(embimg); title('Embedded Image')

set(handles.psnr,'String',ps)
set(handles.ber,'String',ber)
set(handles.mse,'String',mse)
set(handles.ssim,'String',ssim_out)

set(handles.exwm,'Enable','On')
guidata(hObject,handles)

% --- Executes on button press in ipimg.
function ipimg_Callback(hObject, eventdata, handles)
% hObject    handle to ipimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname path]=uigetfile({'*.jpg';'*.bmp';'*.tif';'*.png'},'Browse Image');
if fname~=0
    img=imread([path,fname]);
    try
        % For four channel tiff images
        img=img(:,:,1:3);
    catch lasterr
        % Do Nothing
    end
    if length(size(img))>2
        img=rgb2gray(img);
    end
    axes(handles.axes1); imshow(img);
    title('Original Image')
    handles.img=img;
    set(handles.wmimg,'Enable','on')
else
    warndlg('Please Select the necessary Image File');
end
guidata(hObject,handles);

% --- Executes on button press in wmimg.
function wmimg_Callback(hObject, eventdata, handles)
% hObject    handle to wmimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname path]=uigetfile({'*.jpg';'*.bmp';'*.tif';'*.png'},'Browse Image');
if fname~=0
    msg=imread([path,fname]);
    try
        msg = msg(:,:,1:3);
    catch lasterr
        % Do Nothing
    end
    if length(size(msg))>2
        msg=rgb2gray(msg);
    end
    axes(handles.axes5); imshow(msg);
    title('Watermark Image')
    handles.msg=msg;
    set(handles.emwm,'Enable','on')
else
    warndlg('Please Select the necessary watermark Image File');
end
guidata(hObject,handles);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1); cla(handles.axes1); title(''); axis off
axes(handles.axes5); cla(handles.axes5); title(''); axis off
axes(handles.axes6); cla(handles.axes6); title(''); axis off
axes(handles.axes7); cla(handles.axes7); title(''); axis off
set(handles.wmimg,'Enable','off')
set(handles.emwm,'Enable','off')
set(handles.exwm,'Enable','off')

% Reset all text boxes
set(handles.psnr,'String','0')
set(handles.ber,'String','0')
set(handles.mse,'String','0')
set(handles.ssim,'String','0')
set(handles.embtime,'String','0')
set(handles.rettime,'String','0')


% --- Executes on button press in noiseattack.
function noiseattack_Callback(hObject, eventdata, handles)
% hObject    handle to noiseattack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    embimg = handles.embimg;
catch error
    msgbox('Please embed the watermark in the image first.');
    return;
end

% Salt and Pepper Noise attack
saltpepimg1 = imnoise(embimg,'salt & pepper',0.05); % 5% noise attack
saltpepimg1_clean = adpmedian(saltpepimg1,3);
[psnr_1,error1] = psnrcalc(saltpepimg1,embimg);
[psnr_1_clean,error1_clean] = psnrcalc(saltpepimg1_clean,embimg);

saltpepimg2 = imnoise(embimg,'salt & pepper',0.1); % 10% noise attack
saltpepimg2_clean = adpmedian(saltpepimg2,3);
[psnr_2,error2] = psnrcalc(saltpepimg2,embimg);
[psnr_2_clean,error2_clean] = psnrcalc(saltpepimg2_clean,embimg);

saltpepimg3 = imnoise(embimg,'salt & pepper',0.15); % 15% noise attack
saltpepimg3_clean = adpmedian(saltpepimg3,3);
[psnr_3,error3] = psnrcalc(saltpepimg3,embimg);
[psnr_3_clean,error3_clean] = psnrcalc(saltpepimg3_clean,embimg);

saltpepimg4 = imnoise(embimg,'salt & pepper',0.2); % 20% noise attack
saltpepimg4_clean = adpmedian(saltpepimg4,3);
[psnr_4,error4] = psnrcalc(saltpepimg4,embimg);
[psnr_4_clean,error4_clean] = psnrcalc(saltpepimg4_clean,embimg);

% Extracted watermarks - Will get distorted when more noise gets added.
% Hence an efficient noise removal can get rid of the noise attacks.
saltpepimg1_wm = exwmark(saltpepimg1);
saltpepimg2_wm = exwmark(saltpepimg2);
saltpepimg3_wm = exwmark(saltpepimg3);
saltpepimg4_wm = exwmark(saltpepimg4);

% Extracted watermarks - From images after noise removal
saltpepimg1_clean_wm = exwmark(saltpepimg1_clean);
saltpepimg2_clean_wm = exwmark(saltpepimg2_clean);
saltpepimg3_clean_wm = exwmark(saltpepimg3_clean);
saltpepimg4_clean_wm = exwmark(saltpepimg4_clean);

% Showing the figure with all noise images and extracted watermarks
figure;
subplot(4,4,1); imshow(saltpepimg1); title(['5% Salt and Pepper Noise(PSNR=' num2str(psnr_1) ')']);
subplot(4,4,2); imshow(saltpepimg2); title(['10% Salt and Pepper Noise(PSNR=' num2str(psnr_2) ')']);
subplot(4,4,3); imshow(saltpepimg3); title(['15% Salt and Pepper Noise(PSNR=' num2str(psnr_3) ')']);
subplot(4,4,4); imshow(saltpepimg4); title(['20% Salt and Pepper Noise(PSNR=' num2str(psnr_4) ')']);
subplot(4,4,5); imshow(saltpepimg1_wm); title('Extracted watermark');
subplot(4,4,6); imshow(saltpepimg2_wm); title('Extracted watermark');
subplot(4,4,7); imshow(saltpepimg3_wm); title('Extracted watermark');
subplot(4,4,8); imshow(saltpepimg4_wm); title('Extracted watermark');

% Showing the figure with all noiseless images and extracted watermarks
subplot(4,4,9);  imshow(saltpepimg1_clean); title(['Noiseless Image(PSNR=' num2str(psnr_1_clean) ')']);
subplot(4,4,10); imshow(saltpepimg2_clean); title(['Noiseless Image(PSNR=' num2str(psnr_2_clean) ')']);
subplot(4,4,11); imshow(saltpepimg3_clean); title(['Noiseless Image(PSNR=' num2str(psnr_3_clean) ')']);
subplot(4,4,12); imshow(saltpepimg4_clean); title(['Noiseless Image(PSNR=' num2str(psnr_4_clean) ')']);
subplot(4,4,13); imshow(saltpepimg1_clean_wm); title('Extracted watermark');
subplot(4,4,14); imshow(saltpepimg2_clean_wm); title('Extracted watermark');
subplot(4,4,15); imshow(saltpepimg3_clean_wm); title('Extracted watermark');
subplot(4,4,16); imshow(saltpepimg4_clean_wm); title('Extracted watermark');

set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

all_error = [error1,error2,error3,error4];
all_psnr = [psnr_1,psnr_2,psnr_3,psnr_4];
figure;
plot([error1,error2,error3,error4],[psnr_1,psnr_2,psnr_3,psnr_4],'--rs','LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'MarkerSize',10);
strValues = strtrim(cellstr(num2str([all_error(:) all_psnr(:)],'(%d,%d)')));
text(all_error,all_psnr,strValues,'VerticalAlignment','bottom');
xlabel('Noise');
ylabel('PSNR');
title('PSNR vs Noise');

figure;
all_error = [error1_clean,error2_clean,error3_clean,error4_clean];
all_psnr = [psnr_1_clean,psnr_2_clean,psnr_3_clean,psnr_4_clean];
plot([error1_clean,error2_clean,error3_clean,error4_clean],[psnr_1_clean,psnr_2_clean,psnr_3_clean,psnr_4_clean],'--rs','LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'MarkerSize',10);
strValues = strtrim(cellstr(num2str([all_error(:) all_psnr(:)],'(%d,%d)')));
text(all_error,all_psnr,strValues,'VerticalAlignment','bottom');
xlabel('Noise');
ylabel('PSNR');
title('PSNR vs Noise (After Noise Removal)');

msgbox(sprintf('There are two observations from the graphs\n1. As the noise added increases, the error increases and hence the PSNR reduces\n2. Once the noise is removed from the images, the error reduces and the overall PSNR increases'));

% --- Executes on button press in cropattack.
function cropattack_Callback(hObject, eventdata, handles)
% hObject    handle to cropattack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
embimg = handles.embimg;

% Give the user the ability to crop an image
figure;
croppedimg = imcrop(embimg);
croppedimg = imresize(croppedimg,[512 512]);
close(gcf);

% Extracting the watermark from the cropped image
croppedimg_wm = exwmark(croppedimg);
figure;

subplot(2,1,1); imshow(croppedimg); title('Cropped Image');
subplot(2,1,2); imshow(croppedimg_wm); title('Watermark extracted from Cropped Image');

set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.


function [ps,mse] = psnrcalc(processed,original)
processed=im2double(processed);
original=im2double(original);
[m n]=size(original);

% mse is the Mean Square Error
error=processed - original; % calculation of error
se=error.*error; % squared error
sumse=sum(sum(se)); % sum of the squared error
mse=sumse/(m*n);%This is used to calculate the mean square error

ma=max(max(processed));
ps=10*log10(ma*ma/mse); % y contains the psnr value.

