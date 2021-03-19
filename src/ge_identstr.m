function [ kmlstr ] = ge_identstr( kmlstr, ident )
%Puts an ident in front of each line to make the kml file more readable.
%This function is only used interally.
% 
% Inputs
% ?kmlstr The kml string to be processed
% ?ident number of ident tabs (default 1)
%
% Outputs
% ?kmlstr Indented string

% Unless not otherwise specified the ident is 1
if nargin == 1
    ident = 1;
end

% Process the string
kmlstr = sprintf([repmat('\t',1,ident),'%s'], strrep(kmlstr, sprintf('\n'), sprintf('\n\t')));

end

