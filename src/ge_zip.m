function ge_zip( filename, sourcekml, varargin )
% Loads a kml file and stores it in a zip container with the file extension
% kmz.
% 
% Required Inputs
% ?filename     Filename of the kmz to be created
% ?sourcekml    Filename of the source kml file to be transformed into an
%               kmz
%
% Parameters
% ?RootFolder   Specifies the root folder of the data to be zipped (see zip
%               documentation for more info (Default is current folder).
% ?SupportFiles Attach additional files that are required for viewing in
%               google earth (e.g. images, 3d models, ...). Please make
%               that the pathes are correct. 


% Intput Parser ===========================================================
p = inputParser();

addParameter(p, 'RootFolder', '.', @ischar);
addParameter(p, 'SupportFiles', {}, @(x)ischar(x)||iscell(x));

parse(p, varargin{:});
RootFolder = p.Results.RootFolder;
SupportFiles = p.Results.SupportFiles;

if ischar(SupportFiles)
    SupportFiles = {SupportFiles};
end

% Zip the Data ============================================================
[pathstr,name,extzip] = fileparts(filename);

if isempty(extzip) || ~strcmpi(extzip, '.zip')
    extzip = '.zip';
end

filename_zip = fullfile(pathstr, [name, extzip]);
filename_kmz = fullfile(pathstr, [name, '.kmz']);

zip(filename_zip, [{sourcekml}, SupportFiles], RootFolder);

% Change Filename =========================================================
movefile(filename_zip, filename_kmz);


end

