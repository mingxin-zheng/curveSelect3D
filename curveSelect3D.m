function curveSelect3D()

% curveSelect3d is a tool that allows the user to graphically select  
% curve(s) from a 3-d plot by just clicking near a desired point.

% Please run curveSelect_demo.m for example.

% Inspired by and Ackwonledgement to John D'Errico's work of "Graphical
% data selection tool".

%% SelectData
params.Axes = gca;
params.Bold = [];
params.Pointer = 'cross';

rst.Pointer = '';

figHdl = get(params.Axes,'parent');
figure(figHdl) % focus on the figure
hc = get(params.Axes,'children');
hcAll = [1:length(hc)];
hcNorm = hcAll;

textAx = [];
printNotes('Press Any Key to Start Curve Selection, Hit T to Toggle Display');

% Override the current WindowKeyPressFcn
set(figHdl,'WindowKeyPressFcn',@selectCurve)

%% ------------Callback Functions------------
    function selectCurve(object,eventdata)
        
        delete(textAx)
        key = figHdl.CurrentCharacter;
        axisSize = axis;
        if ~strcmp(key,'t')
        % Point Selection
        xdata = get(hc,'xdata');
        ydata = get(hc,'ydata');
        zdata = get(hc,'zdata');
        
        if ~isempty(params.Pointer)
            rst.Pointer = get(figHdl,'Pointer');
            set(figHdl,'Pointer',params.Pointer)
        end    
            % waitforbuttonpress;
            %cc = get(gca,'CurrentPoint');
            
            dx = (axisSize(2) - axisSize(1));
            dy = (axisSize(4) - axisSize(3));
            dz = (axisSize(6) - axisSize(5));
            
            datacursormode on
            dcmObj = datacursormode(figHdl);
            set(dcmObj,'SnapToDataVertex','off','Enable','on')
            waitforbuttonpress;
            point1 = getCursorInfo(dcmObj);
            datacursormode off;
            xyz = [point1.Position(1),point1.Position(2),point1.Position(3)];
            
            cc = [xyz;xyz];
            [pointslist,xselect,yselect,zselect]  = closestpoint(cc,xdata,ydata,zdata,dx,dy,dz);
            
            lineSelect = find(~cellfun('isempty',pointslist)==1);

            if get(hc(lineSelect),'LineWidth') == 3
                set(hc(lineSelect),'LineWidth',0.2);
                hcNorm = union(hcNorm,lineSelect);
                axis(axisSize);
            else
                set(hc(lineSelect),'LineWidth',3);
                hcNorm = setdiff(hcNorm,lineSelect);
                axis(axisSize);
            end
            set(figHdl,'Pointer',rst.Pointer);
        else
            if strcmp(get(hc(hcNorm(1)),'Visible'),'on')
                set(hc(hcNorm),'Visible','off');
                axis(axisSize);
            else
                set(hc(hcNorm),'Visible','on');
                axis(axisSize);
            end
        end
        
        printNotes('Press Any Button to Start Curve Selection');  
        % Restoration
        
    end

    function printNotes(descrb)
        textAx = axes('Position',[.1 .9 .3 .05]);
        axes(textAx);
        text(.025,0.6,descrb);
        axis off;
        axes(params.Axes);        
    end
%% 
% find the single closest point to xy, in scaled units
end

%% 
function [pointslist,xselect,yselect,zselect]  = closestpoint(cc,xdata,ydata,zdata,dx,dy,dz)
    xyz1 = cc(1,:);
    xyz2 = cc(2,:);
    
    if ~iscell(xdata)
      % just one set of points to consider
        D1 = (((xdata - xyz1(1))/dx).^2 + ((ydata - xyz1(2))/dy).^2 + ((zdata - xyz1(3))/dz).^2);
        D2 = (((xdata - xyz2(1))/dx).^2 + ((ydata - xyz2(2))/dy).^2 + ((zdata - xyz2(3))/dz).^2);
        D = D1 + D2;
        [junk,pointslist] = min(D(:)); %#ok
        xselect = xdata(pointslist);
        yselect = ydata(pointslist);
        zselect = zdata(pointslist);
    else
      Dmin = inf;
      pointslist = cell(size(xdata));
      for i = 1:numel(xdata)
        D1 = (((xdata{i} - xyz1(1))/dx).^2 + ((ydata{i} - xyz1(2))/dy).^2 + ((zdata{i} - xyz1(3))/dz).^2);
        D2 = (((xdata{i} - xyz2(1))/dx).^2 + ((ydata{i} - xyz2(2))/dy).^2 + ((zdata{i} - xyz2(3))/dz).^2);
        D = D1+D2;
        [mind,ind] = min(D(:));

        if mind < Dmin
          % searching for the closest point
          Dmin = mind;

          pointslist = cell(size(xdata));

          pointslist{i} = ind;
          xselect = xdata{i}(ind);
          yselect = ydata{i}(ind);
          zselect = zdata{i}(ind);
        end
      end
    end

end