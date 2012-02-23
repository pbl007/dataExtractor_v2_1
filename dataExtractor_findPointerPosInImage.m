function [x,y] = dataExtractor_findPointerPosInImage(~,~,axHandles)
%dataExtractor_findPointerPosInImage - returns pointer x,y position if inside image


axesCurPt = get(axHandles,{'CurrentPoint'});

if iscell(axesCurPt)
    pt = axesCurPt{1}(1,1:2);
end
x = pt(1,1);
y = pt(1,2);
xlim = get(axHandles,'Xlim');
ylim = get(axHandles,'Ylim');

if x >= xlim(1) && x <= xlim(2) && y >= ylim(1) && y <= ylim(2)
    % if event was generated over figure and marking mode is on, call function to add vertex
    currentMode = getappdata(gcf,'stateVars_traceMode');
    if currentMode
        dataExtractor_addVertex(x,y);
    end
     pause(0.05)%avoid double clicks   
else
    x=[];
    y=[];
end

% disp([x y])