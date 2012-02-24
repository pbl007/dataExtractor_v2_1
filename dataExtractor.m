function dataExtractor(varargin)
%
% Copyright 2012 P.Blinder - pablo.blinder@gmail.com
%
%
% This file is part of dataExtractor_v2.1
% 
%     dataExtractor_v2.1 is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     dataExtractor_v2.1 is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with dataExtractor_v2.1.  If not, see <http://www.gnu.org/licenses/>.

if nargin<1
    [fileName,pathName] = uigetfile('*.*','Pick up an image or existing figure');
end
[~,fname,ext] = fileparts(fileName);

switch ext
    case {'.fig'}
        open(fullfile(pathName,fileName));
        dataExtractor_rebuildHandles
    otherwise
        try
            im = imread(fullfile(pathName,fileName));
        catch
            error('Cannot read image file %s',fullfile(pathName,fileName));
        end
end

%check if another window is open
h2fig = findobj('tag','__dataExtractorFigure');
if isempty(h2fig)
    % initialize this should load image
    disp('creating dummy figure')
    h2fig  = figure('windowStyle','docked','tag','__dataExtractorFigure');
    h2im = imshow(im,'border','tight');
    colormap gray
    
    
    %define variables and store in figure data
    setappdata(h2fig,'trace',[]);
    setappdata(h2fig,'pairList',[]); %each row is v1,v2 indices and last digit is state active/hidden(deleted) 1/0
    setappdata(h2fig,'eventHistory',[]);
    setappdata(h2fig,'vtxStack',vertex.empty(0,0));
    setappdata(h2fig,'edgStack',edge.empty(0,0));
    setappdata(h2fig,'stateVars_traceMode',0);
    setappdata(h2fig,'selectedVertexId',[]);
    setappdata(h2fig,'selectedEdgeId',[]);
    setappdata(h2fig,'idCounter_vtx',1);
    setappdata(h2fig,'idCounter_edg',1);
    setappdata(h2fig,'rootDir',pathName);
    setappdata(h2fig,'baseFileName',fname);
    
    %add context menu to figure
    h2uicontextmenu = uicontextmenu;
    
    
    cmd = 'evalin(''base'',''G = dataExtractor_buildGraphFromTraces'' );';
    uimenu(h2uicontextmenu,'Label','Export graph','callback',cmd);
    set([h2im h2fig],'uicontextmenu',h2uicontextmenu);
    
end

set(h2fig,'keyPressFcn',@dataExtractor_keyPressFcn);


