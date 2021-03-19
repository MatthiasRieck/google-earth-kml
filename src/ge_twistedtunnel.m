function [ kmlstr ] = ge_twistedtunnel( lat, lon, h, Psi, Theta, Phi, varargin )
% Uses position and orientation information to create a band trajectory.
% This can be used for instance to display the bank trajectory of an
% aircraft.
% 
% Required Inputs:
% ?lat,lon,h WGS84 position on earth in rad
% ?Psi,Theta,Phi object orientation in rad
% 
% Input Parser
% %#TABLE[l c c l]{c c c n}
% ------------------------------------------------------------------------------------------
% Name             | Type           | Default Value    | Description
% ------------------------------------------------------------------------------------------
% BankLeftLength   | numeric        | 100              | Left offset of the bank trajectory
% BankRightLength  | numeric        | 100              | Right offset of the bank trajectory 
% LineWidth        | numeric        | 1                | Width of the Polygon Line
% LineColor        | numeric        | [1,1,1]          | [r,g,b] color of line
% LineAlpha        | numeric        | 0                | Alpha value of line color
% FaceColor        | numeric        | [1,1,1]          | Face Color of polygons
% FaceAlpha        | numeric        | 1                | Alpha value of poly color
% Name             | char           | []               | if the name is set the trajectory 
%                  |                |                  | will automatically be hidden in a
%                  |                |                  | folder with this name  
% ------------------------------------------------------------------------------------------

% Input Parser ============================================================
p = inputParser();

% add parameters
addParameter(p, 'BankLeftLength', 10, @isnumeric);
addParameter(p, 'BankRightLength', 10, @isnumeric);
addParameter(p, 'BankTopLength', 10, @isnumeric);
addParameter(p, 'BankBottomLength', 10, @isnumeric);

addParameter(p, 'LineWidth', 1, @isnumeric);
addParameter(p, 'LineColor', [1,1,1], @isnumeric);
addParameter(p, 'LineAlpha', 0, @isnumeric);

addParameter(p, 'FaceColor', [1,1,1], @isnumeric);
addParameter(p, 'FaceAlpha', 1, @isnumeric);

addParameter(p, 'ColorValue', [], @isnumeric);
addParameter(p, 'ColorMap', colormap('parula'), @isnumeric);

addParameter(p, 'Name', [], @ischar);

% parse inputs
parse(p, varargin{:});
BankLeftLength  = p.Results.BankLeftLength;
BankRightLength = p.Results.BankRightLength;
BankTopLength  = p.Results.BankTopLength;
BankBottomLength = p.Results.BankBottomLength;
LineWidth       = p.Results.LineWidth;
LineColor       = p.Results.LineColor;
LineAlpha       = p.Results.LineAlpha;
FaceColor       = p.Results.FaceColor;
FaceAlpha       = p.Results.FaceAlpha;
ColorValue      = p.Results.ColorValue;
ColorMap        = p.Results.ColorMap;
Name            = p.Results.Name;

% Process Input ===========================================================
TrajectoryColor = [];
% Calculate ColorValue
if ~isempty(ColorValue)
    % Calculate Normalized Color
    minValue = min(ColorValue);
    maxValue = max(ColorValue);
    
    ColorValueNorm = (ColorValue - minValue) / (maxValue - minValue);
    
    % Interpolate Color
    tau = linspace(0,1, size(ColorMap,1));
    
    TrajectoryColor = zeros(numel(lon),3);
    TrajectoryColor(:,1) = interp1(tau', ColorMap(:,1), ColorValueNorm);
    TrajectoryColor(:,2) = interp1(tau', ColorMap(:,2), ColorValueNorm);
    TrajectoryColor(:,3) = interp1(tau', ColorMap(:,3), ColorValueNorm);
end

% Create Bank Trajectory ==================================================
initsize    = size(lon);
zerodummies = zeros(initsize);

% Get Positions
[topleft, topright, bottomleft, bottomright] =...
    CreateBankTrajectoryVertices( zerodummies,zerodummies,zerodummies,...
    Psi,Theta,Phi, BankLeftLength, BankRightLength, BankTopLength, BankBottomLength);

topleft = topleft';
topright = topright';
bottomleft = bottomleft';
bottomright = bottomright';

% Transform into WGS84
[lat_topleft, lon_topleft, h_topleft] = ned2geodetic(...
    topleft(:,1), topleft(:,2), topleft(:,3),...
    lat, lon, h, referenceEllipsoid('WGS84'), 'rad');

[lat_topright, lon_topright, h_topright] = ned2geodetic(...
    topright(:,1), topright(:,2), topright(:,3),...
    lat, lon, h, referenceEllipsoid('WGS84'), 'rad');

[lat_bottomleft, lon_bottomleft, h_bottomleft] = ned2geodetic(...
    bottomleft(:,1), bottomleft(:,2), bottomleft(:,3),...
    lat, lon, h, referenceEllipsoid('WGS84'), 'rad');

[lat_bottomright, lon_bottomright, h_bottomright] = ned2geodetic(...
    bottomright(:,1), bottomright(:,2), bottomright(:,3),...
    lat, lon, h, referenceEllipsoid('WGS84'), 'rad');

% Create kml string
kmlstr = [ge_plot3(lat_topleft, lon_topleft, h_topleft),...
          ge_plot3(lat_topright, lon_topright, h_topright),...
          ge_plot3(lat_bottomleft, lon_bottomleft, h_bottomleft),...
          ge_plot3(lat_bottomright, lon_bottomright, h_bottomright)];

for i = 1:numel(lon)-1
    % Get Color
    color = FaceColor;
    if ~isempty(TrajectoryColor)
        color = TrajectoryColor(i,:);
    end
    
    % Plot Polygon top
    kmlstr = [kmlstr,...
        ge_poly3(...
        [lat_topleft(i), lat_topright(i), lat_topright(i+1), lat_topleft(i+1)],...
        [lon_topleft(i), lon_topright(i), lon_topright(i+1), lon_topleft(i+1)],...
        [h_topleft(i), h_topright(i), h_topright(i+1), h_topleft(i+1)],...
        'FaceColor',     color,...
        'FaceAlpha', FaceAlpha,...
        'LineColor', LineColor,...
        'LineAlpha', LineAlpha,...
        'LineWidth', LineWidth)]; %#ok<AGROW>
    
    % Plot Polygon right
    kmlstr = [kmlstr,...
        ge_poly3(...
        [lat_bottomright(i), lat_topright(i), lat_topright(i+1), lat_bottomright(i+1)],...
        [lon_bottomright(i), lon_topright(i), lon_topright(i+1), lon_bottomright(i+1)],...
        [h_bottomright(i), h_topright(i), h_topright(i+1), h_bottomright(i+1)],...
        'FaceColor',     color,...
        'FaceAlpha', FaceAlpha,...
        'LineColor', LineColor,...
        'LineAlpha', LineAlpha,...
        'LineWidth', LineWidth)]; %#ok<AGROW>
    
    % Plot Polygon left
    kmlstr = [kmlstr,...
        ge_poly3(...
        [lat_bottomleft(i), lat_topleft(i), lat_topleft(i+1), lat_bottomleft(i+1)],...
        [lon_bottomleft(i), lon_topleft(i), lon_topleft(i+1), lon_bottomleft(i+1)],...
        [h_bottomleft(i), h_topleft(i), h_topleft(i+1), h_bottomleft(i+1)],...
        'FaceColor',     color,...
        'FaceAlpha', FaceAlpha,...
        'LineColor', LineColor,...
        'LineAlpha', LineAlpha,...
        'LineWidth', LineWidth)]; %#ok<AGROW>
    
    % Plot Polygon bottom
    kmlstr = [kmlstr,...
        ge_poly3(...
        [lat_bottomleft(i), lat_bottomright(i), lat_bottomright(i+1), lat_bottomleft(i+1)],...
        [lon_bottomleft(i), lon_bottomright(i), lon_bottomright(i+1), lon_bottomleft(i+1)],...
        [h_bottomleft(i), h_bottomright(i), h_bottomright(i+1), h_bottomleft(i+1)],...
        'FaceColor',     color,...
        'FaceAlpha', FaceAlpha,...
        'LineColor', LineColor,...
        'LineAlpha', LineAlpha,...
        'LineWidth', LineWidth)]; %#ok<AGROW>
end

% Create folder with hidden entries if desired
if ~isempty(Name)
    % Create Folder
    kmlstr = ge_folder(Name, kmlstr, 'type', 'hide');
end

end

function [topleft, topright, bottomleft, bottomright] = CreateBankTrajectoryVertices( X,Y,Z,Chi,Gamma,Mu, BankLeftLength, BankRightLength, BankTopLength, BankBottomLength )
% Calculates the trajectory outer points in a local ned frame

% Extract Data
X       = reshape(X, 1,[]);
Y       = reshape(Y, 1,[]);
Z       = reshape(Z, 1,[]);
Chi     = reshape(Chi, 1,[]);
Gamma   = reshape(Gamma, 1,[]);
Mu      = reshape(Mu, 1,[]);

% Calculate Vector
vec2 = [cos(Chi).*sin(Gamma).*sin(Mu) - sin(Chi).*cos(Mu);...
       sin(Chi).*sin(Gamma).*sin(Mu) + cos(Chi).*cos(Mu);...
       cos(Gamma).*sin(Mu)];
   
vec3 = [cos(Chi) .* sin(Gamma) .* cos(Mu) + sin(Chi) .* sin(Mu);...
        sin(Chi) .* sin(Gamma) .* cos(Mu) - cos(Chi) .* sin(Mu);...
        cos(Gamma) .* cos(Mu)];



pos = [X;Y;Z];

% Calculate Left and Right points of bank trajectory
topleft = pos - vec2 * BankLeftLength - vec3 * BankTopLength;
topright = pos + vec2 * BankRightLength - vec3 * BankTopLength;
bottomleft = pos - vec2 * BankLeftLength + vec3 * BankBottomLength;
bottomright = pos + vec2 * BankRightLength + vec3 * BankBottomLength;

end