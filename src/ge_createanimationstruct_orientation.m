function [ struct ] = ge_createanimationstruct_orientation( OrientationID, time, varargin )
%GE_CREATEANIMATIONSTRUCT_LOCATION Summary of this function goes here
%   Detailed explanation goes here

%
p = inputParser();

addParameter(p, 'Psi', [], @isnumeric);
addParameter(p, 'Theta', [], @isnumeric);
addParameter(p,     'Phi', [], @isnumeric);

parse(p, varargin{:});

Psi_rad = p.Results.Psi;
Theta_rad = p.Results.Theta;
Phi_rad = p.Results.Phi;

% Process
[time_unique, ind] = unique(time);

if numel(ind) ~= numel(time)
    warning('Data was not unique');
end

%
struct.type = 'Orientation';
struct.id   = OrientationID;
struct.time = time_unique;
struct.data = [];
if ~isempty(Psi_rad)
    struct.data.heading = Psi_rad(ind)*180/pi;
end

if ~isempty(Theta_rad)
    struct.data.tilt = -Theta_rad(ind)*180/pi;
end

if ~isempty(Phi_rad)
    struct.data.roll = -Phi_rad(ind)*180/pi;
end

end

