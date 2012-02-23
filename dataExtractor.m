function dataExtractor(varargin)
%
%

if nargin<1
    [fileName,pathName] = uigetfile('*.*','Pick up an image or existing figure');
end
[~,~,ext] = fileparts(fileName);

switch ext
    case {'.fig'}
        open(fullfile(pathName,fileName));
        dataExtractor_rebuildHandles
    otherwise
        try
            im = imread(fullfile(pathName,fileName));
        catch
            error('Cannot read image file %s',fullfile(pathName,fileName));
        end
end

%check if another window is open
h2fig = findobj('tag','__dataExtractorFigure');
if isempty(h2fig)
    % initialize this should load image
    disp('creating dummy figure')
    h2fig  = figure('windowStyle','docked','tag','__dataExtractorFigure');
    imshow(im,'border','tight');
    colormap gray
    
    
    %define variables and store in figure data
    setappdata(h2fig,'trace',[]);
    setappdata(h2fig,'pairList',[]); %each row is v1,v2 indices and last digit is state active/hidden(deleted) 1/0
    setappdata(h2fig,'eventHistory',[]);
    setappdata(h2fig,'vtxStack',vertex.empty(0,0));
    setappdata(h2fig,'edgStack',edge.empty(0,0));
    setappdata(h2fig,'stateVars_traceMode',0);
    setappdata(h2fig,'selectedVertexId',[]);
    setappdata(h2fig,'selectedEdgeId',[]);
    setappdata(h2fig,'idCounter_vtx',1);
    setappdata(h2fig,'idCounter_edg',1);
    
end

set(h2fig,'keyPressFcn',@dataExtractor_keyPressFcn);


