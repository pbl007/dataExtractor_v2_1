function dataExtractor_keyPressFcn(~,evnt)
%dataExtractor_keyPressFcn - handles all keyboard related events
%
% Ctrl+z - undo (not supported yet)
% Ctrl+t - toggle trace mode
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


if evnt.Character == 'e'
    
elseif length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'control') & evnt.Key == 'z'
    fprintf('\n Undo request');
elseif length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'control') & evnt.Key == 't'
    fprintf('\n Toggle trace mode')
    toggleTraceMode
end


%%---------------------------- Private functions ----------------------------------------

function toggleTraceMode
%enable/disable mark mode

h2fig = gcf;
currentMode = getappdata(h2fig,'stateVars_traceMode');
currentMode = ~currentMode;
setappdata(h2fig,'stateVars_traceMode',currentMode);

%whenever toggle mode is activated
selectedVertexId = getappdata(gcf,'selectedVertexId');
if ~isempty(selectedVertexId);trace = selectedVertexId;else trace = [];end
setappdata(gcf,'trace',trace);

if currentMode
    set(h2fig,'Pointer','crosshair');
    set(h2fig,'windowButtonDownFcn',{@dataExtractor_findPointerPosInImage,gca})
else
    set(h2fig,'Pointer','arrow');
    set(h2fig,'windowButtonDownFcn','')

end

