function [filename] = ge_document( filename, kmlstr, varargin )
%GE_DOCUMENT Summary of this function goes here
%   Detailed explanation goes here

p = inputParser();

addParameter(p, 'Open',               false, @islogical);
addParameter(p, 'Name', fileparts(filename),    @ischar);

parse(p, varargin{:});


document_open = p.Results.Open;
document_name = p.Results.Name;

fid = fopen(filename, 'w');

% Write Entry
fprintf(fid, '%s\n', '<?xml version="1.0" encoding="UTF-8"?>');
fprintf(fid, '%s\n', '<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">');
fprintf(fid, '%s\n', '<Document>');

fprintf(fid, '\t<name>%f</name>\n', document_name);
if document_open
    fprintf(fid, '\t<open>%i</open>\n', uint8(document_open));
end

kmlstr = sprintf('\t%s', strrep(kmlstr, sprintf('\n'), sprintf('\n\t')));

% kmlstr = kmlstr(1:end-1);
fprintf(fid, '%s\n', kmlstr);

fprintf(fid, '%s\n', '</Document>');
fprintf(fid, '%s\n', '</kml>');

fclose(fid);

end

