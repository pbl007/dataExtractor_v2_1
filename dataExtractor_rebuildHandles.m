function varargout = dataExtractor_rebuildHandles(varargin)
%Update handles to vertices and edges after opening figure - only useful for dataExtractor
%This function will have only of figures with Tag property set to '__dataExtractorFigure'

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