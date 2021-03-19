function [ struct ] = ge_createanimationstruct_lookat(time, varargin )
% Creates an animation struct that can be used to perform the lookat camera
% movement in google earth.
%
% Required Inputs
% ?time time discretization for the camers in seconds
%
% Parameter Value Pairs
% ?Lat          latitude of the camera target in rad (same size as time)
% ?Lon          longitude of the camera target in rad (same size as time)
% ?h            altitude of the camera target in meters (same size as time)
% ?Psi          

% Input Parser ============================================================
p = inputParser();

% Location
addParameter(p,      'Lat',         [], @isnumeric);
addParameter(p,      'Lon',         [], @isnumeric);
addParameter(p,        'h',         [], @isnumeric);

% Orientation
addParameter(p,      'Psi',         [], @isnumeric);
addParameter(p,    'Theta',         [], @isnumeric);

% Other
addParameter(p, 'AltitudeMode', 'absolute', @ischar);
addParameter(p,    'FlyToMode',   'smooth', @ischar);
addParameter(p,        'Range',        100, @isnumeric);


parse(p, varargin{:});

Lat_rad         = p.Results.Lat;
Lon_rad         = p.Results.Lon;
h_m             = p.Results.h;

Psi_rad         = p.Results.Psi;
Theta_rad       = p.Results.Theta;

AltitudeMode    = p.Results.AltitudeMode;
FlyToMode       = p.Results.FlyToMode;
Range       = p.Results.Range;

% Process =================================================================
[time_unique, ind] = unique(time);

if numel(ind) ~= numel(time)
    warning('Data was not unique');
end

% Write Struct ============================================================
struct.type = 'LookAt';
struct.altitudemode   = AltitudeMode;
struct.flytomode = FlyToMode;
struct.time = time_unique;
struct.data = [];

if ~isempty(Lat_rad)
    struct.data.latitude = Lat_rad(ind)*180/pi;
end

if ~isempty(Lon_rad)
    struct.data.longitude = Lon_rad(ind)*180/pi;
end

if ~isempty(h_m)
    struct.data.altitude = h_m(ind);
end

if ~isempty(Psi_rad)
    struct.data.heading = Psi_rad(ind)*180/pi;
end

if ~isempty(Theta_rad)
    struct.data.tilt = Theta_rad(ind)*180/pi;
end

if ~isempty(Range)
    if numel(Range) == 1
        Range = repmat(Range, size(time));
    end
    struct.data.range = Range(ind);
end

end

