function dataExtractor_addVertex(x,y)

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