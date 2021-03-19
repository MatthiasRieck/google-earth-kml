function [ kmlstr ] = ge_banktrajectory( lat, lon, h, Psi, Theta, Phi, varargin )
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
% ColorValue       | numeric        | []               | Color dependent on value array
%                  |                |                  | (overrides face color setting) 
% ColorMap         | numeric        | parula           | Color map for ColorValue setting
% Name             | char           | []               | if the name is set the trajectory 
%                  |                |                  | will automatically be hidden in a
%                  |                |                  | folder with this name  
% ------------------------------------------------------------------------------------------

% Input Parser ============================================================
p = inputParser();

% add parameters
addParameter(p, 'BankLeftLength', 100, @isnumeric);
addParameter(p, 'BankRightLength', 100, @isnumeric);

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
[leftHandlePos, rightHandlePos ] =...
    CreateBankTrajectoryVertices( zerodummies,zerodummies,zerodummies,...
    Psi,Theta,Phi, BankLeftLength, BankRightLength);

leftHandlePos   = leftHandlePos';
rightHandlePos  = rightHandlePos';

% Transform into WGS84
[lat_left, lon_left, h_left] = ned2geodetic(...
    leftHandlePos(:,1), leftHandlePos(:,2), leftHandlePos(:,3),...
    lat, lon, h, referenceEllipsoid('WGS84'), 'rad');

[lat_right, lon_right, h_right] = ned2geodetic(...
    rightHandlePos(:,1), rightHandlePos(:,2), rightHandlePos(:,3),...
    lat, lon, h, referenceEllipsoid('WGS84'), 'rad');

% Create kml string
kmlstr = [];

for i = 1:numel(lon)-1
    % Get Color
    color = FaceColor;
    if ~isempty(TrajectoryColor)
        color = TrajectoryColor(i,:);
    end
    
    % Plot Polygon
    kmlstr = [kmlstr,...
        ge_poly3(...
        [lat_left(i), lat_right(i), lat_right(i+1), lat_left(i+1)],...
        [lon_left(i), lon_right(i), lon_right(i+1), lon_left(i+1)],...
        [h_left(i), h_right(i), h_right(i+1), h_left(i+1)],...
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

function [leftHandlePos, rightHandlePos ] = CreateBankTrajectoryVertices( X,Y,Z,Chi,Gamma,Mu, BankLeftLength, BankRightLength )
% Calculates the trajectory outer points in a local ned frame

% Extract Data
X       = reshape(X, 1,[]);
Y       = reshape(Y, 1,[]);
Z       = reshape(Z, 1,[]);
Chi     = reshape(Chi, 1,[]);
Gamma   = reshape(Gamma, 1,[]);
Mu      = reshape(Mu, 1,[]);

% Calculate Vector
vec = [cos(Chi).*sin(Gamma).*sin(Mu) - sin(Chi).*cos(Mu);...
       sin(Chi).*sin(Gamma).*sin(Mu) + cos(Chi).*cos(Mu);...
       cos(Gamma).*sin(Mu)];

pos = [X;Y;Z];

% Calculate Left and Right points of bank trajectory
rightHandlePos  = (pos + vec * BankRightLength)';
leftHandlePos   = (pos - vec * BankLeftLength)';

rightHandlePos  = rightHandlePos';
leftHandlePos   = leftHandlePos';

end