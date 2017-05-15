function G = dataExtractor_buildGraphFromTraces
%Build a graph structure G based on the active graphic objects
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

h2fig = findobj('Tag','__dataExtractorFigure');

vtxStack = getappdata(h2fig,'vtxStack');
edgStack = getappdata(h2fig,'edgStack');
pairList = getappdata(h2fig,'pairList');

%keep only active pairs
pairList = pairList(pairList(:,3)>0,1:2);
ne = size(pairList,1);
if ne == 1;pairList=[pairList;pairList([2,1])];end % ensure indexing works for a graph with just one edge


%now validate each pair (both vertices have to be active)

activePairs = [vtxStack(pairList(:,1)).active]' & [vtxStack(pairList(:,2)).active]';
pairList = pairList(activePairs,:);


%build lookup table for vertex indices
[ids] = unique(pairList(:));

%find non-connected active vertices
activeVtx = find([vtxStack.active]);
kv0ids = setdiff(activeVtx,ids);
ids = union(ids,activeVtx);
nv = numel(ids);
idsLUT = zeros(max(ids),1);
idsLUT(ids) = 1 : nv;

%extract x,y and type
G.nv = nv;
G.ne = ne;
G.x = [vtxStack(ids).x];
G.y = [vtxStack(ids).y];
G.type = [vtxStack(ids).type];


%update pairList with consecutive ids
pairList = idsLUT(pairList);

%create adjacency matrix
G.Adj = sparse(pairList(:,1),pairList(:,2),ones(size(pairList,1),1),nv,nv);


figure;gplot(G.Adj,[G.x' G.y'],'r.-');set(gca,'ydir','reverse');
%add non connected vertices as gplot plots only connected ones
hold on
plot(G.x(idsLUT(kv0ids)),G.y(idsLUT(kv0ids)),'r.')
set(gca,'ydir','reverse');


%auto save
rootDir = getappdata(h2fig,'rootDir');
if ~isdir(rootDir);rootDir=pwd;warning ('Saved export graph to  mat file in current directory as rootDir does not exists!');end
baseName = getappdata(h2fig,'baseFileName');
fname = fullfile(rootDir,sprintf('%s_%s.mat',baseName,datestr(now,'YYYYmmdd_HHMMSS')));
save(fname,'G')
fprintf('\nGraph saved to %s',fname)

