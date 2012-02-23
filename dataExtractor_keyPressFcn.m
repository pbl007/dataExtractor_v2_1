function dataExtractor_keyPressFcn(~,evnt)
%dataExtractor_keyPressFcn - handles all keyboard related events
%
% Ctrl+z - undo
% Ctrl+m - toggle marking mode
%

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

