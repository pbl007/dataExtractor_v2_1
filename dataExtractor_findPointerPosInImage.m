function [x,y] = dataExtractor_findPointerPosInImage(~,~,axHandles)
%dataExtractor_findPointerPosInImage - returns pointer x,y position if inside image
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

axesCurPt = get(axHandles,{'CurrentPoint'});

if iscell(axesCurPt)
    pt = axesCurPt{1}(1,1:2);
end
x = pt(1,1);
y = pt(1,2);
xlim = get(axHandles,'Xlim');
ylim = get(axHandles,'Ylim');

if x >= xlim(1) && x <= xlim(2) && y >= ylim(1) && y <= ylim(2)
    % if event was generated over figure and marking mode is on, call function to add vertex
    currentMode = getappdata(gcf,'stateVars_traceMode');
    if currentMode
        dataExtractor_addVertex(x,y);
    end
     pause(0.05)%avoid double clicks   
else
    x=[];
    y=[];
end

% disp([x y])