% edge object class definition
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

classdef edge < handle
    %Edge object for tracing
    
    properties
        id
        v1        %id of vertex 1
        v2        %id of vertex 2
        active
        selected
        nameTag  %identical to the name of the graphic object it represents - needed to reassign handle
        h2guiObj %this will hold the actual representation on the figure
    end
    
    methods(Static)
        function getEdgStack
            cmd = 'edgStack = getappdata(gcf,''edgStack'');';
            evalin('base',cmd)
        end %getedgStack
        
        function setEdgStack
            cmd = 'setappdata(gcf,''edgStack'',edgStack);';
            evalin('base',cmd)
        end %setedgStack
    end %methods (static)
    
    methods
        function edg = edge(id,v1,v2)
            edg.id = id;
            edg.v1 = v1;
            edg.v2 = v2;
            edg.active = 1;
            edg.selected = 0;
            edg.nameTag = sprintf('edge_%d',edg.id);
            edg.plotEdge;
        end%constructor
        
        %display
        function plotEdge(edg)
            
            %get v1,v2 coordinates
            vtxStack = getappdata(gcf,'vtxStack');
            v1xy = [vtxStack(edg.v1).x vtxStack(edg.v1).y];
            v2xy = [vtxStack(edg.v2).x vtxStack(edg.v2).y];
            
            h2edg = plot([v1xy(1);v2xy(1)],[v1xy(2) v2xy(2)],'r-','Tag',edg.nameTag);
            edg.h2guiObj = h2edg;
            h2uicontextmenu = uicontextmenu;
            
            %add submenues to context menu
            %             cmd = sprintf('edge.getEdgStack;edgStack(%d).toggleSelectState',vtx.id);
            %             uimenu(h2uicontextmenu,'Label','Select','callback',cmd);
            
            cmd = sprintf('edge.getEdgStack;edgStack(%d).hide',edg.id);
            uimenu(h2uicontextmenu,'Label','Delete','callback',cmd);
            set(h2edg,'uicontextmenu',h2uicontextmenu);
            uistack(h2edg,'bottom')
            uistack(h2edg,'up',1)
        end
        
        function hide(edg)
            
            fprintf('\n Deliting edge %d ',edg.id)
            edgStack = getappdata(gcf,'edgStack');
            set(edg.h2guiObj,'Visible','off');
            %deactivate
            edgStack([edg.id]).active = 0;
            setappdata(gcf,'edgStack',edgStack);
            
            pairList = getappdata(gcf,'pairList');
            pairs2deactivate = pairList(:,1)== edg.id | pairList(:,2) == edg.id;
            pairList(pairs2deactivate,3) = 0;
            
            setappdata(gcf,'pairList',pairList);
            
        end %hide
    end %methods
    
    
end% classdeff edge