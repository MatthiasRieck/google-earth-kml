function [ struct ] = ge_createanimationstruct_screenoverlay( ScreenOverlayID, time, varargin )
%GE_CREATEANIMATIONSTRUCT_LOCATION Summary of this function goes here
%   Detailed explanation goes here
% TODO: Write documentation


%
p = inputParser();

addParameter(p, 'Rotation_deg', [], @isnumeric);
addParameter(p,      'ScreenX', [], @isnumeric);
addParameter(p,      'ScreenY', [], @isnumeric);
addParameter(p,      'OverlayX', [], @isnumeric);
addParameter(p,      'OverlayY', [], @isnumeric);

% TODO: Add other positions ScreenY Overlay, Size, RotationXY, 

parse(p, varargin{:});

Rotation_deg = p.Results.Rotation_deg;
ScreenX = p.Results.ScreenX;
ScreenY = p.Results.ScreenY;
OverlayX = p.Results.OverlayX;
OverlayY = p.Results.OverlayY;

% Process
[time_unique, ind] = unique(time);

if numel(ind) ~= numel(time)
    warning('Data was not unique');
end

%
struct.type = 'ScreenOverlay';
struct.id   = ScreenOverlayID;
struct.time = time_unique;
struct.data = [];
if ~isempty(Rotation_deg)
    struct.data.rotation = Rotation_deg(ind);
end

if ~isempty(ScreenX)
    struct.data.screenXY.x = ScreenX(ind);
end

if ~isempty(ScreenY)
    struct.data.screenXY.y = ScreenY(ind);
end

if ~isempty(OverlayX)
    struct.data.overlayXY.x = OverlayX(ind);
end

if ~isempty(OverlayY)
    struct.data.overlayXY.y = OverlayY(ind);
end

% if ~isempty(Theta_rad)
%     struct.data.tilt = -Theta_rad(ind)*180/pi;
% end
% 
% if ~isempty(Phi_rad)
%     struct.data.roll = -Phi_rad(ind)*180/pi;
% end

end

