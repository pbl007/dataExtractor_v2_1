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


z = 1; %HARDCODED
minDistToMakeConnection = 2; %HARDCODED
axesCurPt = get(axHandles,{'CurrentPoint'});

if iscell(axesCurPt)
    pt = axesCurPt{1}(1,1:2);
end
x = pt(1,1);
y = pt(1,2);

xlim = get(axHandles,'Xlim');
ylim = get(axHandles,'Ylim');


if x >= xlim(1) && x <= xlim(2) && y >= ylim(1) && y <= ylim(2)
    % event generated within image
    
    %if tracing mode is on, addvertex or if within distance from vertex, connect
    
    h2fig = gcf;
    currentMode = getappdata(h2fig,'stateVars_traceMode');
    if currentMode
        
        %find distance to active vertices
        vtxStack = getappdata(h2fig,'vtxStack');
        activeVtxIds = [vtxStack.id]';
        activeVtxIds = activeVtxIds([vtxStack.active]==1);
        X = [vtxStack.x]';
        Y = [vtxStack.y]';
        Z = [vtxStack.z]';
        delta = sqrt(sum([(X-x).^2 (Y-y).^2 (Z-z).^2],2));
        vtxInRange = delta<=minDistToMakeConnection;
        
        if ~any(vtxInRange(activeVtxIds))
            dataExtractor_addVertex(x,y);
        else
            %make connection
            trace = getappdata(h2fig,'trace');
            v1 = trace(end);
            %set target vertex as selected
            v2 = find(vtxInRange); %Note: most likely there will be only one vertex to connect to but not checking now
            
            if v2~=v1
            vtxStack(v2).toggleSelectState;
            vtxStack(v1).connectToSelected;
            vtxStack(v2).toggleSelectState;
            
            %add target vtx to trace so one can continue
            trace(end+1) = v2;
            setappdata(h2fig,'trace',trace);
            end
%             setappdata(h2fig,
        end
    end
    pause(0.01)%avoid double clicks
else
    x=[];
    y=[];
end

% disp([x y])