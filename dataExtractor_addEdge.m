function dataExtractor_addEdge(v1,v2)
%adds an edge object between vertices v1 and v2

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
