function [ kmlstr ] = ge_append( varargin )
% Appends multiple kml strings together
% 
% %#CODELINE
% kmlstr = ge_append(kmlstr_1, kmlstr_2, ...)


% Initialize Empty
kmlstr = [];

% Loop over all input arguments
for i = 1:numel(varargin)
    % If the input entry is not emppty
    if ~isempty(varargin{i})
        % Attach
        kmlstr = [kmlstr, varargin{i}]; %#ok<AGROW>
    
        % Add new line if not the last element
        if i < numel(varargin)
            kmlstr = [kmlstr, sprintf('\n')]; %#ok<AGROW>
        end
    end
end

end

