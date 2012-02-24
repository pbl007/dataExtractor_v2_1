function varargout = dataExtractor_rebuildHandles(varargin)
%Update handles to vertices and edges after opening figure - only useful for dataExtractor
%This function will have only of figures with Tag property set to '__dataExtractorFigure'
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

if nargout==1;varargout{1}=[];end
if ~strcmp(get(gcf,'Tag'),'__dataExtractorFigure');return;end



fprintf('\nUpdating handles')
h2fig = gcf;
vtxStack = getappdata(h2fig,'vtxStack');
for iVTX = 1 : numel(vtxStack)
    h2guiObj = findobj(h2fig,'Tag',vtxStack(iVTX).nameTag);
    if isempty(h2guiObj);
        fprintf('\n%d vertex %d has orphan graphic object',iVTX,vtxStack(iVTX).id);
    else
        vtxStack(iVTX).h2guiObj = h2guiObj;
    end
end %rebuilding vtxStack handles

setappdata(h2fig,'vtxStack',vtxStack);

edgStack = getappdata(h2fig,'edgStack');
for iEDG = 1 : numel(edgStack)
     h2guiObj = findobj(h2fig,'Tag',edgStack(iEDG).nameTag);
    if isempty(h2guiObj);
        fprintf('\n%d vertex %d has orphan graphic object',iEDG,edgStack(iEDG).id);
    else
        edgStack(iEDG).h2guiObj = h2guiObj;
    end
end
setappdata(h2fig,'edgStack',edgStack)
fprintf('\tDone')