function SaveGeneratedFigures(FolderName,SaveStuff)
%SaveGeneratedFigures Saves open figures
%   Saves MATLAB figures currently open. The code requires that each figure
%   have a unique name [set when creating the figure via: 
%   figure(Name,Value)]. 
%   Created by Benjamin Durante, 2021

if SaveStuff == true
    % Acquires list of all open figures
    FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
    % Goes through and saves one by one
    for iFig = 1:length(FigList)
        % Setup height plotting options
        height.NumericalList = [4,3.6,3.5,3.25,3.25];
        height.WrittenList = {'','-Short','','-2column','-Short-Narrow'};
        % The final width entry is denoted above by "-Short-Narrow"
        width.NumericalList = [6.5,6.5,6,4.4,3.25];
        width.WrittenList = {'','','Presentation-','',''};
        % Determining the name of the current figure
        FigHandle = FigList(iFig);
        FigName   = get(FigHandle, 'Name');
        % Hide title, if there is one
        title('')
        for heightOptionsindex = 1:length(height.NumericalList)
            % Set the font values
            if strcmp(width.WrittenList(heightOptionsindex),'Presentation-')
                % Set the font values for presentations
                fontInfo.font = 'calibri';
                fontInfo.size = 12;
            else
                % Set the font values for documents
                fontInfo.font = 'times';
                fontInfo.size = 10; 
                % Font size AIAA = 10
                % Font size Thesis = 11
            end
            FormatPictures(height.NumericalList(heightOptionsindex),width.NumericalList(heightOptionsindex),fontInfo) % Formats each figure a certain height in inches
            FigNamePrinted = [width.WrittenList{heightOptionsindex} FigName(find(~isspace(FigName))) height.WrittenList{heightOptionsindex}];
            % Saves the figures as 3 formats png for viewing, svg for
            % presentations and eps colour for LaTeX
            saveas(FigHandle,fullfile(FolderName, FigNamePrinted),'png')
            saveas(FigHandle,fullfile(FolderName, FigNamePrinted),'epsc')
            saveas(FigHandle,fullfile(FolderName, FigNamePrinted),'svg')
            %savefig(FigHandle, fullfile(FolderName, FigName, '.fig'));
        end
        close(FigHandle)
    end
    close all
end
end

function [] = FormatPictures(Height,Width,fontInfo)
%FormatPictures Format Figures for printing into a thesis
%   Format figures for printing in a thesis



% Look for all axes in a figure
AllAxes = findobj( get(gcf,'Children'), '-depth', 1, 'type', 'axes');

% Maintains the y-axis (basically stops the y-axis from being recomputed
% automatically and screwing up the relationship plots
set(AllAxes,'ylimmode','manual')  

% Set font to times and size to Thesis format of 11
set(AllAxes,'fontname',fontInfo.font,'fontsize',fontInfo.size)  
% Replaced gca (ie. current axis) with something to look for all axes

% Set figure size to paper width
set(gcf, 'Units', 'Inches', 'Position', [0, 0, Width, Height], 'PaperUnits', 'Inches', 'PaperSize', [Width, Height])
end
