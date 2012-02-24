function dataExtractor_addVertex(x,y)
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

h2fig = gcf;
hold on

%get next id, create and increase id
idCounter_vtx = getappdata(h2fig,'idCounter_vtx');
vtx = vertex(idCounter_vtx,1,x,y,1);
setappdata(h2fig,'idCounter_vtx',idCounter_vtx+1);

%add to vertices stack
vtxStack = getappdata(h2fig,'vtxStack');
vtxStack(idCounter_vtx) = vtx;
setappdata(h2fig,'vtxStack',vtxStack)

vtx.toggleSelectState;%make current active by default

traceMode = getappdata(gcf,'stateVars_traceMode');

if traceMode
    trace = getappdata(gcf,'trace');
    trace(end+1) = vtx.id;
    
    if numel(trace)>1 % connect to previous element in trace
        %add  new edge edge
        pairList = getappdata(h2fig,'pairList');
        pairList(end+1,:) = [trace(end-1) trace(end) 1]; %last digit is state active/hidden(deleted) 1/0
        setappdata(h2fig,'pairList',pairList);
        dataExtractor_addEdge(pairList(end,1),pairList(end,2));
    end %trace lenght > 1
    
    setappdata(gcf,'trace',trace);
end %trace mode active