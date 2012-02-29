% vertex object class definition
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
classdef vertex < handle
    
    properties
        id
        type
        x
        y
        z
        edges
        active
        selected
        nameTag
        h2guiObj %this will hold the actual representation on the figure
    end% properties
    
    methods(Static)
        
        function getVtxStack
            cmd = 'vtxStack = getappdata(gcf,''vtxStack'');';
            evalin('base',cmd)
        end %getVtxStack
        
        function setVtxStack
            cmd = 'setappdata(gcf,''vtxStack'',vtxStack);';
            evalin('base',cmd)
        end %setVtxStack
        
    end %static methods
    
    methods
        %constructure
        function vtx = vertex(id,type,x,y,z)
            vtx.id = id;
            vtx.type = type;
            vtx.x = x;
            vtx.y = y;
            vtx.z = z;
            vtx.edges = [];
            vtx.active = 1;
            vtx.selected = 0;
            vtx.nameTag = sprintf('vertex_%d',vtx.id);
            vtx.plotVertex;
        end %function vertex
        
        %display
        function plotVertex(vtx)
            h2vtx = plot(vtx.x,vtx.y,'rs','Color','r','markerSize',12,'Tag',vtx.nameTag);
            vtx.h2guiObj = h2vtx;
            h2uicontextmenu = uicontextmenu;
            
            %add submenues to context menu
            cmd = sprintf('vertex.getVtxStack;vtxStack(%d).toggleSelectState',vtx.id);
            uimenu(h2uicontextmenu,'Label','Select','callback',cmd);
            
            cmd = sprintf('vertex.getVtxStack;vtxStack(%d).connectToSelected',vtx.id);
            uimenu(h2uicontextmenu,'Label','Connect to selected vertex','callback',cmd);
            
            cmd = sprintf('vertex.getVtxStack;vtxStack(%d).hide',vtx.id);
            uimenu(h2uicontextmenu,'Label','Delete','callback',cmd);
            
            %vertex type submenu
            cmd1 = sprintf('vertex.getVtxStack;vtxStack(%d).changeVertexTypeTo(1)',vtx.id);
            cmd2 = sprintf('vertex.getVtxStack;vtxStack(%d).changeVertexTypeTo(2)',vtx.id);
            cmd3 = sprintf('vertex.getVtxStack;vtxStack(%d).changeVertexTypeTo(3)',vtx.id);
            cmd4 = sprintf('vertex.getVtxStack;vtxStack(%d).changeVertexTypeTo(4)',vtx.id);
            f = uimenu('Label','Change vertex type','Separator','on','Parent',h2uicontextmenu);
            uimenu(f,'Label','Type 1','Callback',cmd1);
            uimenu(f,'Label','Type 2','Callback',cmd2);
            uimenu(f,'Label','Type 3','Callback',cmd3);
            uimenu(f,'Label','Type 4','Callback',cmd4);
            
            set(h2vtx,'uicontextmenu',h2uicontextmenu);
        end
        
        function changeVertexTypeTo(vtx,vtxType)
            fprintf('\n Change vertex %d to type %d',vtx.id,vtxType)
            vtxStack = getappdata(gcf,'vtxStack');
            vtxStack(vtx.id).type = vtxType;
            
            switch vtxType
                case 1
                    marker = 's'; %default
                case 2
                    marker = 'o';
                case 3
                    marker = '^';
                case 4
                    marker = '*';
            end
            
            set(vtxStack(vtx.id).h2guiObj,'Marker',marker)
            setappdata(gcf,'vtxStack',vtxStack);
        end %changeVertexTypeTo%
        %link
        function connectToSelected(vtx)
            
            %add to 'global' list pair
            h2fig = gcf;
            pairList = getappdata(h2fig,'pairList');
            v1 = vtx.id;
            v2 = getappdata(h2fig,'selectedVertexId');
            pairList(end+1,:) = [v1 v2 1]; %last digit is state active/hidden(deleted) 1/0
            setappdata(h2fig,'pairList',pairList);
            dataExtractor_addEdge(pairList(end,1),pairList(end,2));
            
            %create edge
            
        end %function linkTo
        
        %select
        
        
        %toggle select mode
        function toggleSelectState(vtx)
            fprintf('\n toggle select mode for vertex %d',vtx.id)
            vtxStack = getappdata(gcf,'vtxStack');
            %determine action based on the state of the event trigger vertex
            thisState = vtx.selected;
            
            if thisState
                %vertex is selected so simply unselect it an return
                set(vtx.h2guiObj,'LineWidth',0.5)
                vtxStack(vtx.id).selected = 0;
                h2Select = findobj(get(vtx.h2guiObj,'uicontextmenu'),'Label','Unselect');
                set(h2Select,'Label','Select')
                setappdata(gcf,'selectedVertexId',[]);%no vertex selected
            else
                %vertex is unselected, select and unselect all others
                
                %all, unselect state and change menu label
                for iVTX = 1 : numel(vtxStack)
                    if vtxStack(iVTX).active
                        if ishandle(vtxStack(iVTX).h2guiObj)
                            set(vtxStack(iVTX).h2guiObj,'LineWidth',0.5)
                            vtxStack(iVTX).selected = 0;
                            h2Select = findobj(get(vtxStack(iVTX).h2guiObj,'uicontextmenu'),'Label','Unselect');
                            set(h2Select,'Label','Select')
                        end
                    end
                end
                
                %trigger vertex
                vtxStack(vtx.id).selected = 1;
                set(vtx.h2guiObj,'LineWidth',2)
                h2Select = findobj(get(vtx.h2guiObj,'uicontextmenu'),'Label','Select');
                set(h2Select,'Label','Unselect')
                setappdata(gcf,'selectedVertexId',vtx.id);%no vertex selected
                
            end %thisState
            
            setappdata(gcf,'vtxStack',vtxStack);
        end
        
        %delete
        function hide(vtx)
            fprintf('\n Deliting vertex %d ',vtx.id)
            vtxStack = getappdata(gcf,'vtxStack');
            set(vtx.h2guiObj,'Visible','off');
            %deactivate
            vtxStack(vtx.id).active = 0;
            setappdata(gcf,'vtxStack',vtxStack);
            %remove edges
            if ~isempty(vtx.edges)
                edgStack = getappdata(gcf,'edgStack');
                for iEDG = 1 : numel(vtx.edges)
                    edgStack(vtx.edges(iEDG)).hide;
                end
            end
        end
        
    end%methods
    
end%classdef