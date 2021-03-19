function [ struct ] = ge_createanimationstruct_location( LocationId, time, varargin )
% Creates an animation struct for position animation. The animation struct
% can be passed to ge_animate.
%
% Required Inputs
% ?LocationId id for the placemark to be animated. The placemark needs to
%             have the same id.
% ?time       discretized time for the animation
%
% Parameter Value Pairs
% ?Lat  latitude position array in rad (same size as time)
% ?Lon  longitude position array in rad (same size as time)
% ?h    altitude position array in meters (same size as time)

%% Input Parser ===========================================================
p = inputParser();

addParameter(p, 'Lat', [], @isnumeric);
addParameter(p, 'Lon', [], @isnumeric);
addParameter(p,   'h', [], @isnumeric);

parse(p, varargin{:});

Lat_rad = p.Results.Lat;
Lon_rad = p.Results.Lon;
h_m = p.Results.h;

%% Process Inputs =========================================================
[time_unique, ind] = unique(time);

if numel(ind) ~= numel(time)
    warning('Data was not unique');
end

%% Write Animation Struct =================================================
struct.type = 'Location';
struct.id   = LocationId;
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

end

