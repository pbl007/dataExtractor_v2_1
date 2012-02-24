function dataExtractor_addEdge(v1,v2)
%adds an edge object between vertices v1 and v2
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
idCounter_edg = getappdata(h2fig,'idCounter_edg');
edg = edge(idCounter_edg,v1,v2);
setappdata(h2fig,'idCounter_edg',idCounter_edg+1);

%add to vertices stack
edgStack = getappdata(h2fig,'edgStack');
edgStack(idCounter_edg) = edg;
setappdata(h2fig,'edgStack',edgStack)

%register edge id with vertices 
vtxStack = getappdata(gcf,'vtxStack');
vtxStack(v1).edges(end+1) = edg.id;
vtxStack(v2).edges(end+1) = edg.id;
setappdata(gcf,'vtxStack',vtxStack);
