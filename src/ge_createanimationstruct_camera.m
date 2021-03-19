function [ struct ] = ge_createanimationstruct_camera(time, varargin )
% Creates an animation struct for camera movement. The resulting struct has
% to be passed to ge_animate to create the actual animation tour.
%
% Required Inputs
% ?time time discretization in seconds for the camera
%
% Parameter Value Pairs
% ?Lat          latitude of the camera in rad (same size as time)
% ?Lon          longitude of the camera in rad (same size as time)
% ?h            altitude of the camera in meters (same size as time)
% ?Psi          heading of the camera in rad (same size as time)
% ?Theta        inclination angle of the camera in rad (same size as time)
% ?Phi          roll angle of the camera in rad (same size as time)
% ?AltitudeMode altitude mode of camera as string (absolute = default,
%               relative)
% ?FlyToMode    mode the camera starts and stops as a string (smooth = default)

% Input Parser ============================================================
p = inputParser();

% Location
addOptional(p,      'Lat',         [], @isnumeric);
addOptional(p,      'Lon',         [], @isnumeric);
addOptional(p,        'h',         [], @isnumeric);

% Orientation
addOptional(p,      'Psi',         [], @isnumeric);
addOptional(p,    'Theta',         [], @isnumeric);
addOptional(p,      'Phi',         [], @isnumeric);
addParameter(p,     'FOV', 60*pi/180, @isnumeric);

% Other
addParameter(p, 'AltitudeMode', 'absolute', @ischar);
addParameter(p,    'FlyToMode',   'smooth', @ischar);


parse(p, varargin{:});

Lat_rad         = p.Results.Lat;
Lon_rad         = p.Results.Lon;
h_m             = p.Results.h;

Psi_rad         = p.Results.Psi;
Theta_rad       = p.Results.Theta;
Phi_rad         = p.Results.Phi;

AltitudeMode    = p.Results.AltitudeMode;
FlyToMode       = p.Results.FlyToMode;
fov = p.Results.FOV;
if isscalar(fov)
    fov = repmat(fov, size(Lat_rad));
end
    

% Process =================================================================
[time_unique, ind] = unique(time);

if numel(ind) ~= numel(time)
    warning('Data was not unique');
end

% Write Struct ============================================================
struct.type = 'Camera';
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
    struct.data.tilt = Theta_rad(ind)*180/pi + 90;
end

if ~isempty(Phi_rad)
    struct.data.roll = -Phi_rad(ind)*180/pi;
end

struct.data.gx_horizFov = fov(ind)*180/pi;

end

