function WHIRL2
close all
% Description: Adaption of whirl.m written by Dr. Matthew Kay to a 
% graphical user interface for designating silhouettes of panoramic imaging 
% geometry. Make sure the camera calibration files Par.dat and Rc.dat are
% located in the home directory prior to initiating GUI.
%
% This code is available under open source license BSD
% TODO copy some text about bsd
%
% Efimov lab: efimov@gwu.edu
% Author: Christopher Gloschat
% Date: June 20, 2016
% Editted by Shubham Gupta email: sgupta2020@gwu.edu
% Editted by Roman Pryamonosov 
% Date: November 14, 2017
% * filepaths are formed by fullfile that works on all OS


%% Create GUI structure
handles.scrnSize = get(0,'ScreenSize');
pR = figure('Name','WHIRL 2.0','Visible','off',...
    'Position',[1 1 740 800],'NumberTitle','Off');
% Screens for anlayzing data
axesSize = 500;
silhView = axes('Parent',pR,'Units','Pixels','YTick',[],'XTick',[],...
    'Position',[20 280 axesSize+200 axesSize]);

% % % % Selection of home directory
% % % hDirButton = uicontrol('Parent',pR,'Style','pushbutton','String','Geometry Directory',...
% % %     'FontSize',11,'Position',[20 250 105 20],'Callback',{@hDirButton_callback});
% % % hDirTxt = uicontrol('Parent',pR,'Style','edit','String','','FontSize',12,...
% % %     'Enable','off','HorizontalAlignment','Left','Position',[130 250 590 20]);
% Selection of image directory
iDirButton = uicontrol('Parent',pR,'Style','pushbutton','String','Image Directory',...
    'FontSize',11,'Position',[20 250 105 20],'Callback',{@iDirButton_callback});
iDirTxt = uicontrol('Parent',pR,'Style','edit','String','','FontSize',12,...
    'Enable','off','HorizontalAlignment','Left','Position',[130 250 590 20]);

% Rotation and images settings for analysis
degreeTxt = uicontrol('Parent',pR,'Style','text','String','Degrees Per Step:',...
    'HorizontalAlignment','Right','FontSize',12,'Position',[20 220 105 20]);
degreeEdit = uicontrol('Parent',pR,'Style','edit','String','',...
    'FontSize',12,'Position',[130 220 40 20],'Callback',{@degreeEdit_callback});
imagesTxt = uicontrol('Parent',pR,'Style','text','String','Images Acquired:',...
    'HorizontalAlignment','Right','FontSize',12,'Position',[20 190 105 20]);
imagesEdit = uicontrol('Parent',pR,'Style','edit','String','',...
    'FontSize',12,'Position',[130 190 40 20],'Callback',{@imagesEdit_callback});

% Above or below threshold designation
abThreshPop = uicontrol('Parent',pR,'Style','popupmenu','String',...
    {'Above','Below'},'FontSize',12,'Position',[175 220 142 20],'Callback',...
    {@abThreshPop_callback});

% Load background images
loadBkgdButton = uicontrol('Parent',pR,'Style','pushbutton','String',...
    'Load Backgrounds','FontSize',12,'Position',[180 190 130 20],...
    'Callback',{@loadBkgdButton_callback});

% Load background images
thresholdAllImages = uicontrol('Parent',pR,'Style','pushbutton','String',...
    'Threshold all images','FontSize',12,'Position',[180 150 130 20],...
    'Callback',{@thresholdAllImages_callback});

% Switch between images
imSelectTxt = uicontrol('Parent',pR,'Style','text','String','Image Select:',...
    'FontSize',12,'HorizontalAlignment','Right','Position',[470 219 105 20]);
imNumEdit = uicontrol('Parent',pR,'Style','edit','FontSize',12,...
    'String','1','Position',[630 220 40 20],'Callback',{@imNumEdit_callback});
imNumInc = uicontrol('Parent',pR,'Style','pushbutton','FontSize',12,...
    'String',char(8594),'Position',[680 220 40 20],'Callback',{@imNumInc_callback});
imNumDec = uicontrol('Parent',pR,'Style','pushbutton','FontSize',12,...
    'String',char(8592),'Position',[580 220 40 20],'Callback',{@imNumDec_callback});
                                                                                                            
% Threshold value
threshTxt = uicontrol('Parent',pR,'Style','text','String','Threshold:',...
    'FontSize',12,'HorizontalAlignment','Right','Position',[470 189 105 20]);
threshEditTop = uicontrol('Parent',pR,'Style','edit','String','0.750',...
    'FontSize',12,'Position',[580 190 40 20],'Callback',{@threshEditTop_callback});
threshEditBot = uicontrol('Parent',pR,'Style','edit','String','0.100',...
    'FontSize',12,'Position',[580 160 40 20],'Callback',{@threshEditBot_callback});
% threshApply = uicontrol('Parent',pR,'Style','pushbutton','String','Apply',...
%     'FontSize',12,'Position',[630 190 40 20],'Callback',{@threshApply_callback});
% threshAdd = uicontrol('Parent',pR,'Style','pushbutton','String','Add',...
%     'FontSize',12,'Position',[630 160 40 20],'Callback',{@threshAdd_callback});
% threshMinus = uicontrol('Parent',pR,'Style','pushbutton','String',...
%     'Minus','FontSize',12,'Position',[680 160 40 20],'Callback',{@threshMinus_callback});
%silhSave = uicontrol('Parent',pR,'Style','pushbutton','String','Save',...
%    'FontSize',12,'Position',[680 190 40 20],'Callback',{@silhSave_callback});
threshApply = uicontrol('Parent',pR,'Style','pushbutton','String','Apply',...
    'FontSize',12,'Position',[630 160 90 20],'Callback',{@threshApply_callback});
threshAdd = uicontrol('Parent',pR,'Style','pushbutton','String','Add',...
    'FontSize',12,'Position',[630 190 40 20],'Callback',{@threshAdd_callback});
threshMinus = uicontrol('Parent',pR,'Style','pushbutton','String',...
    'Subtract','FontSize',12,'Position',[680 190 40 20],'Callback',{@threshMinus_callback});

silhSave = uicontrol('Parent',pR,'Style','pushbutton','String','Save Sulhouettes',...
    'FontSize',12,'Position',[180 120 130 20],'Callback',{@silhSave_callback});
octTxt = uicontrol('Parent',pR,'Style','text','String','Octree Parameters:',...
    'HorizontalAlignment','Left','FontSize',12,'Position',[508 101 80 40]);
startTxt = uicontrol('Parent',pR,'Style','text','String','Start Level',...
    'Position',[580 115 40 40]);
startEdit = uicontrol('Parent',pR,'Style','edit','String','1','Position',...
    [580 110 40 20],'Callback',{@startEdit_callback});
maxTxt = uicontrol('Parent',pR,'Style','text','String','Max Level',...
    'Position',[630 115 40 40]);
maxEdit = uicontrol('Parent',pR,'Style','edit','String','8','Position',...
    [630 110 40 20],'Callback',{@maxEdit_callback});
silhProcess = uicontrol('Parent',pR,'Style','pushbutton','String','Finish',...
    'FontSize',12,'Position',[680 110 40 20],'Callback',{@silhProcess_callback});

% Message center text box
msgCenterLabel = uicontrol('Parent',pR,'Style','Text','String',...
    'Message Center:','FontSize',12,'Position',[320 220 170 20],...
    'BackgroundColor',[0.85 0.85 0.85],'HorizontalAlignment','Left');
msgCenter = uicontrol('Parent',pR,'Style','text','String','','FontSize',...
    12,'BackgroundColor',[0.85 0.85 0.85],'Position',[320 110 170 110]);

% Allow all GUI structures to be scaled when window is dragged
set([pR,silhView,degreeTxt,degreeEdit,imagesTxt,thresholdAllImages,imagesEdit,...
    threshTxt,threshEditTop,threshEditBot,loadBkgdButton,abThreshPop,iDirButton,...
    iDirTxt,imNumEdit,imNumInc,imNumDec,threshApply,threshAdd,threshMinus,...
    silhSave,silhProcess,msgCenterLabel,msgCenter,imSelectTxt,octTxt,startTxt,...
    startEdit,maxTxt,maxEdit],'Units','normalized')

% Disable buttons
set([degreeEdit,imagesEdit,imNumEdit,imNumInc,imNumDec,threshEditTop,threshEditBot...
    threshApply,threshAdd,threshMinus,silhSave,silhProcess,loadBkgdButton,...
    startEdit,maxEdit,abThreshPop, thresholdAllImages],'Enable','off')

% Center GUI on screen
movegui(pR,'center')
set(pR,'MenuBar','none','Visible','on')

%% Create handles
handles.hdir = [];
handles.bdir = [];
try
    editor_service = com.mathworks.mlservices.MLEditorServices;
    editor_app = editor_service.getEditorApplication;
    active_editor = editor_app.getActiveEditor;
    storage_location = active_editor.getStorageLocation;
    file = char(storage_location.getFile);
    handles.projectDir = fileparts(file);
    cd (handles.projectDir)
catch
    handles.projectDir = uigetdir('Select Project Directory');
end
    
handles.dtheta = [];
handles.n_images = [];
handles.oldDir = pwd;
handles.fileList = [];
handles.sfilename = [];
handles.ndigits = [];
handles.def_threshTop = str2double(get(threshEditTop,'String'));
handles.def_threshBot = str2double(get(threshEditBot,'String'));
handles.aabb = str2double(get(threshEditTop,'String'));
handles.thresharrTop = [];
handles.thresharrBot = [];
handles.loadClicked = 0;
handles.currentImage = 1;
handles.silhs = [];
handles.octStart = [];
handles.octMax = [];


%% Select the directory with the heart background images
% % %     function hDirButton_callback(~,~)
% % %          % select experimental directory
% % %         tmp = uigetdir;
% % %         % populate text field
% % %         if tmp ~= 0
% % %             % assign directory value
% % %             handles.hdir = tmp;
% % %             set(hDirTxt,'String',handles.hdir)
% % %             % change directory
% % %             cd(handles.hdir)
% % %         end
% % %     end

%% Select image directory
    function iDirButton_callback(~,~)
        % select experimental directory
        tmp = uigetdir;
        if tmp ~= 0
            % Image directory
            handles.bdir = tmp;
            cd(handles.bdir)
            % Geometry directory
            cd ..
            handles.hdir = pwd;
            % populate text field
            set(iDirTxt,'String',handles.bdir)
            % change directory
            cd(handles.bdir)
            % list of files in the directory
            fileList = dir;
            % grab files that are tiffs
            checkFiles = zeros(size(fileList,1),1);
            for n = 1:length(checkFiles)
                if length(fileList(n).name) > 4
                    checkFiles(n) = strcmp(fileList(n).name(end-3:end),'tiff');
                else
                    checkFiles(n) = 0;
                end
            end
            % grab indices of the files that are tiffs
            checkFiles = checkFiles.*(1:length(checkFiles))';
            checkFiles = unique(checkFiles);
            checkFiles = checkFiles(2:end);
            % remove directories from file list
            fileList = fileList(checkFiles);
            
            % identify period that separates the name and file type
            charCheck = zeros(length(fileList(1).name),1);
            for n = 1:length(charCheck)
% %             for n = 3:length(charCheck)
                % char(46) is a period
                charCheck(n) = fileList(1).name(n) == char(46);
                if charCheck(n) == 1
                    middleInd = n;
                    break
                end
            end
            % assign the file type
            handles.sfilename = fileList(1).name(middleInd+1:end);
            
            % identify numeric portion of filenames
            nameInd = 1:middleInd-1;
            numCheck = 48:57;
            nameInd = repmat(nameInd,[length(numCheck) 1]);
            numCheck = repmat(numCheck',[1 size(nameInd,2)]);
            numCheck = fileList(1).name(nameInd) == char(numCheck);
            numCheck = sum(numCheck).*(1:size(nameInd,2));
            numCheck = unique(numCheck);
            if length(numCheck) > 1
                numCheck = numCheck(2:end);
            end
            % number of digits in filenames
            handles.ndigits = length(numCheck);
            
            % assign filename
            handles.bfilename = fileList(1).name(1:numCheck(1)-1);
            
            % assign start number for the silhouettes files
            handles.sdigit = fileList(1).name(numCheck(end));
            
            % save out filenames
            handles.fileList = fileList;
            
            % set number of images and degrees per step
            set(imagesEdit,'String',num2str(size(fileList,1)))
            handles.n_images = str2double(get(imagesEdit,'String'));
            set(degreeEdit,'String',num2str(360/size(fileList,1)))
            handles.dtheta = str2double(get(degreeEdit,'String'));
            handles.thresharrTop = zeros(1,handles.n_images);
            handles.thresharrBot = zeros(1,handles.n_images);
            
            % enable load background button
            set(loadBkgdButton,'Enable','on')
        end
    end

%% Set the number of degrees per step
    function degreeEdit_callback(source,~)
        if isnan(str2double(source.String))
            errordlg('Value must be positive and numeric','Invalid Input')
            set(degreeEdit,'String','')
        elseif str2double(source.String) <= 0
            errordlg('Value must be positive and numeric','Invalid Input')
            set(degreeEdit,'String','')
        else
            handles.dtheta = str2double(source.String);
        end
    end

%% Set the number of background images acquired
    function imagesEdit_callback(source,~)
        if isnan(str2double(source.String))
            errordlg('Value must be positive and numeric','Invalid Input')
            set(imagesEdit,'String','')
        elseif str2double(source.String) <= 0
            errordlg('Value must be positive and numeric','Invalid Input')
            set(imagesEdit,'String','')
        else
            handles.n_images = str2double(source.String);
        end
    end

%% Set the threshold for identifying the silhouettes
    function threshEditTop_callback(source,~)
        if isnan(str2double(source.String))
            errordlg('Value must be positive and numeric','Invalid Input')
            set(threshEditTop,'String','')
        elseif str2double(source.String) <= 0
            errordlg('Value must be positive and numeric','Invalid Input')
            set(threshEditTop,'String','')
        else
            handles.def_threshTop = str2double(source.String);
            handles.thresharrTop = handles.thresharrTop + handles.def_threshTop;
        end
    end

%% Set the threshold for identifying the silhouettes
    function threshEditBot_callback(source,~)
        if isnan(str2double(source.String))
            errordlg('Value must be positive and numeric','Invalid Input')
            set(threshEditBot,'String','')
        elseif str2double(source.String) <= 0
            errordlg('Value must be positive and numeric','Invalid Input')
            set(threshEditBot,'String','')
        else
            handles.def_threshBot = str2double(source.String);
            handles.thresharrBot = handles.thresharrBot + handles.def_threshBot;
        end
    end

%% Apply threshold to images
    function threshApply_callback(~,~)
        % Clear axes
        cla(silhView)
        % Plot image to axes
        fname = handles.fileList(handles.currentImage).name;
        a = imread(fullfile(handles.bdir,fname));
        
        a = rgb2gray(a);
        a = double(a);
        handles.a = a/max(max(a(:,:,1)));
        axes(silhView)
        imagesc(handles.a)
        colormap('gray')
        set(silhView,'XTick',[],'YTick',[])
        % Calculate the outline based on the specified threshold settings
        [bw] = calcSilhWindow(handles.a,handles.def_threshTop,handles.def_threshBot);
        handles.silhs(:,:,handles.currentImage) = bw;
        % Find outline and superimpose on image
        outline = bwperim(bw,8);
        [or,oc]=find(outline);
        axes(silhView)
        hold on
        plot(oc,or,'y.');
        hold off
        
        stats = regionprops(bw,'all');
        % Image area
        handles.area(handles.currentImage) = stats.Area;
        % Limits of image in x and y coordinates
        lims = stats.BoundingBox;
        % limits
        handles.lims(handles.currentImage,:) = [ceil(lims(1)) ceil(lims(1))+lims(3) ceil(lims(2)) ceil(lims(2))+lims(4)];
        
    end

%% Add to the silhouette
    function threshAdd_callback(~,~)
        % Define region to add to silhouette
        CI = handles.currentImage;
        axes(silhView)
        add = roipoly;
        if ~isempty(add)
            handles.silhs(:,:,CI) = handles.silhs(:,:,CI) + add;
            handles.silhs(:,:,CI) = handles.silhs(:,:,CI) > 0;
            
            % Replot image
            cla(silhView)
            axes(silhView)
            imagesc(handles.a)
            colormap('gray')
            set(silhView,'XTick',[],'YTick',[])
            
            % Calculate and  plot new outline
            outline = bwperim(handles.silhs(:,:,CI),8);
            [or,oc]=find(outline);
            axes(silhView)
            hold on
            plot(oc,or,'y.');
            hold off
            
            stats = regionprops(handles.silhs(:,:,CI),'all');
            % Image area
            handles.area(handles.currentImage) = stats.Area;
            % Limits of image in x and y coordinates
            lims = stats.BoundingBox;
            % limits
            handles.lims(handles.currentImage,:) = [ceil(lims(1)) ceil(lims(1))+lims(3) ceil(lims(2)) ceil(lims(2))+lims(4)];
            
        end
    end

%% Subtract from the silhouette
    function threshMinus_callback(~,~)
        % Define region to add to silhouette
        CI = handles.currentImage;
        axes(silhView)
        minus = roipoly;
        if ~isempty(minus)
            handles.silhs(:,:,CI) = handles.silhs(:,:,CI) - minus;
            handles.silhs(:,:,CI) = handles.silhs(:,:,CI) > 0;
            
            % Replot image
            cla(silhView)
            axes(silhView)
            imagesc(handles.a)
            colormap('gray')
            set(silhView,'XTick',[],'YTick',[])
            
            % Calculate and  plot new outline
            outline = bwperim(handles.silhs(:,:,CI),8);
            [or,oc]=find(outline);
            axes(silhView)
            hold on
            plot(oc,or,'y.');
            hold off
            
            stats = regionprops(handles.silhs(:,:,CI),'all');
            % Image area
            handles.area(handles.currentImage) = stats.Area;
            % Limits of image in x and y coordinates
            lims = stats.BoundingBox;
            handles.lims(handles.currentImage,:) = [ceil(lims(1)) ceil(lims(1))+lims(3) ceil(lims(2)) ceil(lims(2))+lims(4)];
        end
    end

%% Above or below threshold
    function abThreshPop_callback(source,~)
        if source.Value == 1
            handles.aabb = 1;
        else
            handles.aabb = 0;
        end
    end

%% Threshold all background images
    function thresholdAllImages_callback(~,~)
        % precompute silhouettes for all images
        i=0;
        maxCount = size(handles.fileList);
        h = waitbar(i/(maxCount(1)+1),sprintf('Thresholding image 0...'));
        for i=1:size(handles.fileList)
            waitbar(i/(maxCount(1)+1),h,sprintf('Thresholding image %d...',i));
            fname = handles.fileList(i).name;
            image = imread(fullfile(handles.bdir, fname));
            
            image = rgb2gray(image);
            image = double(image);
            image1 = image/max(max(image(:,:,1)));

            % Calculate the outline based on the specified threshold settings
            if sum(sum(handles.silhs(:,:,i))) == 0
                [bw] = calcSilhWindow(image1,handles.def_threshTop,handles.def_threshBot);
                handles.silhs(:,:,i) = bw;
                %disp(handles.silhs(50:100,50:100,i))
            else
                bw = handles.silhs(:,:,i);
            end

            stats = regionprops(bw,'all');
            handles.area(handles.currentImage) = stats.Area;
            stats = regionprops(bw,'all');
            lims = stats.BoundingBox;
            handles.lims(i,:) = [ceil(lims(1)) ceil(lims(1))+lims(3)-1 ceil(lims(2)) ceil(lims(2))+lims(4)-1];
        end
        close(h)
    end
%% Load background images
    function loadBkgdButton_callback(~,~)
        % Check for already established silhouettes
        cd(handles.hdir)
        fid=fopen('silhs1.mat');
        if fid~=-1
            set(msgCenter,'String','Found silhouettes!');
            fclose(fid);
            issilh=1;
        else
            set(msgCenter,'String','Could not find silhouettes!');
            issilh=0;
        end
        
        % Change current directory to heart geometry directory
        cd(handles.bdir)
        
        % Load thresholds or set a default threshold
        if issilh
            pickSilh = questdlg('FOUND SILHS1.MAT! USE OLD SILHOUETTES OR ESTABLISH NEW ONES?',...
                'Old vs. New','OLD','NEW','OLD');
            % Handle response
            switch pickSilh
                case 'OLD'
                    loadsilh = 1;
                case 'NEW'
                    loadsilh = 0;
            end
        end
        

        % Prep image variable
        fname = handles.fileList(handles.currentImage).name;
        a = imread(fullfile(handles.bdir,fname));
        a = rgb2gray(a);
        a = double(a);
        handles.a = a/max(max(a(:,:,1)));
        
        % Determine thresholds for silhouettes
        if issilh == 1 && loadsilh == 1
            % Load established silhouettes
            cd(handles.hdir)
%             silhs = [];
%             lims = [];
%             area = [];
            load('silhs1.mat','lims','area','silhs');
            handles.lims = lims;
            handles.area = area;
            handles.silhs = silhs;
            disp (size(lims))
            disp (size(handles.lims))
            % Setup first threshold
            bw = handles.silhs(:,:,handles.currentImage);
            cd(handles.bdir)
            % Establish thresholds
        else
            % Preallocate space for silhouettes
            handles.silhs = zeros(size(handles.a,1),size(handles.a,2),...
                size(handles.thresharrTop,2));
            % Calculate the outline based on the specified threshold settings
            [bw] = calcSilhWindow(handles.a,handles.def_threshTop,handles.def_threshBot);
            handles.silhs(:,:,handles.currentImage) = bw;
        end

        % Plot image to plot
        axes(silhView)
        imagesc(handles.a)
        colormap('gray')
        set(silhView,'XTick',[],'YTick',[])
        
        % Grabe image width and height values
        imageWidth = size(a,2);
        imageHeight = size(a,1);
        
        % Grab figure position information
        figPos = get(gcf,'Position');
        % Grab axes position information
        axesPos = get(silhView,'Position');
        % Grab the width and height of the axes and convert to pixels
        axesWidth = handles.scrnSize(3)*figPos(3)*axesPos(3);
        axesHeight = handles.scrnSize(4)*figPos(4)*axesPos(4);
        % Grab top left x and y coordinates
        axesX = axesPos(1);
        axesY = axesPos(2);
        
        if imageHeight > imageWidth
            % Find the new width in pixels based on the image proportions
            newWidth =  axesHeight*(imageWidth/imageHeight);
            % Convert back to a percentage
            newWidth = newWidth/(handles.scrnSize(3)*figPos(3));
            % Find the difference in values
            widthDiff = (axesPos(3)-newWidth)/2;
            % Change axes size and shift with these values
            set(blockView,'Position',[axesX+widthDiff axesY newWidth axesPos(4)])
        else
            % Find new height in pixels based on image proportions
            newHeight = (imageHeight/imageWidth)*axesWidth;
            % Convert new value back to a percentage
            newHeight = newHeight/(handles.scrnSize(4)*figPos(4));
            % Find the vertical shift to keep axes centered
            heightDiff = (axesPos(4)-newHeight)/2;
            % Change axes size and shift with these values
            set(silhView,'Position',[axesX axesY+heightDiff axesPos(3) newHeight])
        end
        
        % Find outline and superimpose on image
        outline = bwperim(bw,8);
        [or,oc]=find(outline);
        axes(silhView)
        hold on
        plot(oc,or,'y.');
        hold off
        
        stats = regionprops(bw,'all');
        % Image area
        handles.area(handles.currentImage) = stats.Area;
        % Limits of image in x and y coordinates
        lims = stats.BoundingBox;
        handles.lims(handles.currentImage,:) = [ceil(lims(1)) ceil(lims(1))+lims(3)-1 ceil(lims(2)) ceil(lims(2))+lims(4)-1];
        % Disable button
        set(loadBkgdButton,'Enable','off')
        handles.loadClicked = 1;
        
        % Disable buttons
        set([imNumEdit,imNumInc,imNumDec,threshEditTop,threshEditBot,threshApply,...
            threshAdd,threshMinus,silhSave,silhProcess,startEdit,...
            maxEdit,abThreshPop,thresholdAllImages],'Enable','on')
        
    end

%% Callback for saving silhouettes
    function silhSave_callback(~,~)
        currentdir = pwd;
        cd(handles.hdir)
        silhs = handles.silhs;
        lims = handles.lims;
        area = handles.area;
        save('silhs1.mat','silhs','lims','area')
        cd(currentdir)
    end

%% Callback for processing silhouettes
    function silhProcess_callback(~,~)
        % Determine front back positions
        r=0:handles.dtheta:(handles.n_images*handles.dtheta-1);
        if rem(360,handles.dtheta)==0
            % Determine front/back positions
            frontback=1;
            rr=zeros(length(r),5).*NaN;
            r1=find(r-180<0);
            r2=find(r-180>=0);
            rr(1:length(r1),1)=r(r1)';
            rr(1:length(r2),2)=r(r2)';
            rr(1:length(r1),3)=r1';
            rr(1:length(r2),4)=r2';
            rnot=find(isnan(rr(:,1)) & isnan(rr(:,2)));
            rr(rnot,:)=[];
% % %             sprintf('Front/Back positions:')
% % %             disp('Front : Back : Front Index : Back Index : ?')
% % %             disp(rr)
            clear r1 r2 rnot
        else
            
            % No front/back images
            frontback=0;
            rr=zeros(size(r,2),5).*NaN;
            rr(:,1)=r';
            disp(rr(:,1))
            sprintf('No Front/Back positions!')
        end
        
        % Ask user if they wish to reduce redundancy
%         if frontback
%             go=1;
%             while go
%                 collapseSilhs = questdlg(['USE LARGEST SILHOUETTES TO COLLAPSE'...
%                     ' REDUNDANT INFORMATION IN FRONT/BACK SNAPSHOTS? [N]:'],...
%                     'Collapse Redudant Silhouettes?','Yes','No','No');
%                 switch collapseSilhs
%                     case 'Yes'
%                         go = 0;
%                         dofrontback = 1;
%                     case 'No'
%                         go = 0;
%                         dofrontback = 0;
%                 end
%             end
%         end
%         if dofrontback
%             for i=1:size(rr,1)
%                 ars=[handles.area(rr(i,3)) handles.area(rr(i,4))];
%                 maxarsi=find(ars==max(ars));
%                 if maxarsi==1, rr(i,5)=rr(i,3); end;
%                 if maxarsi==2, rr(i,5)=rr(i,4); end;
%             end
%             [rsort,isort]=sort(r(rr(:,5)));
%             inumsort=rr(isort,5);
%             irsort=[inumsort rsort'];
%         else
% 
             rsort=r;
             inumsort=1:length(r);
             irsort=[inumsort' rsort'];
%         end
        silh = handles.silhs;
        lims = handles.lims;
        
        handles.octStart = str2double(get(startEdit,'String'));
        handles.octMax =  str2double(get(maxEdit,'String'));
        % move to Calibration directory
        cd(handles.hdir)
        % Perform occluding contours cube carving
        
        [status,fnametag] = cubeCarvingMod(handles.hdir,handles.projectDir,handles.silhs,handles.lims,...
            handles.dtheta,handles.n_images,r,rr,irsort,...
            rsort,inumsort,handles.octStart,handles.octMax,msgCenter);

        %[Faces,Vertices] = MarchingCubes(x,y,z,c,5.0,colors);
        % advise user that function was cancelled
        if status == 0
            set(msgCenter,'String','Processing cancelled.')
        else
%             set(msgCenter,'String','Occluding contours algorithm completed.')
%             % run surface code from WHIRL2
%             cd(handles.surfaceDir)
%             fnametag = fnametag{1};
%             %tmp = sprintf('s = system(''./Surface %s/ xyzv%s'');',handles.hdir,fnametag);
%             s = [];
%             
%             tmp = sprintf('s = system(''G:\soft\VTK\bin\Surface.exe %s\\xyzv%s'');',handles.hdir,fnametag);
%             % ��� ���������� ����� �������� Surface.exe handles.hdir\xyzv_fnametag:
%             % s = system(''Surface.exe %s\\ xyzv%s'')
%             eval(tmp)
%               %s = system('Surface /Users/Chris/Data/PanoramicImaging/ExperimentsGWU/Rabbit_2016_0804/Geometry/ xyzv_povcyl_1mm_trial');
%             if s == 0
%                 set(msgCenter,'String','Surface generated')
%             else
%                 set(msgCenter,'String','Error encountered. Check Command Window for error details.')
%             end
            set(msgCenter,'String','Processing finished.')
            cd(handles.bdir)
        end    
    end


%% Callback for manually changing image number %%
    function imNumEdit_callback(source,~)
        % Grab edit box value
        val = str2double(get(source,'String'));
        if ~isnumeric(val) || isnan(val)
            set(imNumEdit,'String',num2str(handles.currentImage))
            msgbox('Must enter a positive numeric value.','Error','error')
        elseif val < 0
            set(imNumEdit,'String',num2str(handles.currentImage))
            msgbox('Must enter a positive numeric value.','Error','error')
        elseif val > handles.n_images
            set(imNumEdit,'String',num2str(handles.currentImage))
            msgbox('Must enter a value equal to or less than total number of images.',...
                'Error','error')
        else
            % Update current image value
            handles.currentImage = val;
            % Update silhouette window
            if handles.loadClicked
                % Clear axes
                cla(silhView)
                
                % Plot image to axes
                fname = handles.fileList(handles.currentImage).name;
                a = imread(fullfile(handles.bdir,fname));
                
                a = rgb2gray(a);
                a = double(a);
                handles.a = a/max(max(a(:,:,1)));
                axes(silhView)
                imagesc(handles.a)
                colormap('gray')
                set(silhView,'XTick',[],'YTick',[])
                
                % Calculate the outline based on the specified threshold settings
                if sum(sum(handles.silhs(:,:,handles.currentImage))) == 0
                    [bw] = calcSilhWindow(handles.a,handles.def_threshTop,handles.def_threshBot);
                    handles.silhs(:,:,handles.currentImage) = bw;
                else
                    bw = handles.silhs(:,:,handles.currentImage);
                end
                
                % Find outline and superimpose on image
                outline = bwperim(bw,8);
                [or,oc]=find(outline);
                axes(silhView)
                hold on
                plot(oc,or,'y.');
                hold off
                
                stats = regionprops(bw,'all');
                % Image area
                handles.area(handles.currentImage) = stats.Area;
                % Limits of image in x and y coordinates
                lims = stats.BoundingBox;
                % limits
                handles.lims(handles.currentImage,:) = [ceil(lims(1)) ceil(lims(1))+lims(3)-1 ceil(lims(2)) ceil(lims(2))+lims(4)-1];
                
            end
        end
    end

%% Callback for incrementing image number
    function imNumInc_callback(~,~)
        % Update current image tracker
        val = handles.currentImage;
        if val+1 > handles.n_images
            handles.currentImage = 1;
            set(imNumEdit,'String',num2str(handles.currentImage))
        else
            handles.currentImage = val+1;
            set(imNumEdit,'String',num2str(handles.currentImage))
        end
        % Update silhouette window
        if handles.loadClicked
            % Clear axes
            cla(silhView)
            % Plot image to axes
            fname = handles.fileList(handles.currentImage).name;
            a = imread(fullfile(handles.bdir,fname));
            
            a = rgb2gray(a);
            a = double(a);
            handles.a = a/max(max(a(:,:,1)));
            axes(silhView)
            imagesc(handles.a)
            colormap('gray')
            set(silhView,'XTick',[],'YTick',[]);
            % Calculate the outline based on the specified threshold settings
            if sum(sum(handles.silhs(:,:,handles.currentImage))) == 0
                [bw] = calcSilhWindow(handles.a,handles.def_threshTop,handles.def_threshBot);
                handles.silhs(:,:,handles.currentImage) = bw;
            else
                bw = handles.silhs(:,:,handles.currentImage);
            end
            % Find outline and superimpose on image
            outline = bwperim(bw,8);
            [or,oc]=find(outline);
            axes(silhView)
            hold on
            plot(oc,or,'y.');
            hold off
            
            stats = regionprops(bw,'all');
            % Image area
            handles.area(handles.currentImage) = stats.Area;
            % Limits of image in x and y coordinates
            lims = stats.BoundingBox;
            % limits
            handles.lims(handles.currentImage,:) = [ceil(lims(1)) ceil(lims(1))+lims(3)-1 ceil(lims(2)) ceil(lims(2))+lims(4)-1];
        end
    end

%% Callback for decrementing image number
    function imNumDec_callback(~,~)
        % Update current image tracker
        val = handles.currentImage;
        if val-1 == 0
            handles.currentImage = handles.n_images;
            set(imNumEdit,'String',num2str(handles.currentImage))
        else
            handles.currentImage = val-1;
            set(imNumEdit,'String',num2str(handles.currentImage))
        end
        % Update silhouette window
        if handles.loadClicked
            % Clear axes
            cla(silhView)
            % Plot image to axes
            fname = handles.fileList(handles.currentImage).name;
            a = imread(fullfile(handles.bdir,fname));
            
            a = rgb2gray(a);
            a = double(a);
            handles.a = a/max(max(a(:,:,1)));
            axes(silhView)
            imagesc(handles.a)
            colormap('gray')
            set(silhView,'XTick',[],'YTick',[]);
            % Calculate the outline based on the specified threshold settings
            if sum(sum(handles.silhs(:,:,handles.currentImage))) == 0
                [bw] = calcSilhWindow(handles.a,handles.def_threshTop,handles.def_threshBot);
                handles.silhs(:,:,handles.currentImage) = bw;
            else
                bw = handles.silhs(:,:,handles.currentImage);
            end
            % Find outline and superimpose on image
            outline = bwperim(bw,8);
            [or,oc]=find(outline);
            axes(silhView)
            hold on
            plot(oc,or,'y.');
            hold off
            
            stats = regionprops(bw,'all');
            % Image area
            handles.area(handles.currentImage) = stats.Area;
            % Limits of image in x and y coordinates
            lims = stats.BoundingBox;
            % limits
            handles.lims(handles.currentImage,:) = [ceil(lims(1)) ceil(lims(1))+lims(3)-1 ceil(lims(2)) ceil(lims(2))+lims(4)-1];
        end
    end


%% Octree Start Level Callback %%
    function startEdit_callback(source,~)
        % grab string
        level = str2double(get(source,'String'));
        if isnan(level)
            set(source,'String',num2str(1))
            set(msgCenter,'String','Start level must be an integer value between 1 and 10.')
        elseif level < 0
            set(source,'String',num2str(1))
            set(msgCenter,'String','Start level must be an integer value between 1 and 10.')
        elseif level > 10
            set(source,'String',num2str(1))
            set(msgCenter,'String','Start level must be an integer value between 1 and 10.')
        elseif level >= str2double(get(maxEdit,'String'))
            set(msgCenter,'String','Start level must be lower than max level')
        else
            handles.octStart = level;
        end
        
    end


%% Octree Max Level Callback %%
    function maxEdit_callback(source,~)
         % grab string
        level = str2double(get(source,'String'));
        if isnan(level)
            set(source,'String',num2str(10))
            set(msgCenter,'String','Max level must be an integer value between 1 and 10.')
        elseif level < 0
            set(source,'String',num2str(10))
            set(msgCenter,'String','Max level must be an integer value between 1 and 10.')
        elseif level > 10
            set(source,'String',num2str(10))
            set(msgCenter,'String','Max level must be an integer value between 1 and 10.')
        elseif level <= str2double(get(startEdit,'String'))
            set(msgCenter,'String','Max level must be higher than start level')
        else
            handles.octMax = level;
        end
    end


end