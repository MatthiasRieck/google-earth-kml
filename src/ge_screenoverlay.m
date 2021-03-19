function [ str ] = ge_screenoverlay( overlaysource, varargin )
% Generates a screen overlay

%
p = inputParser();

addParameter(p, 'Name', 'screenoverlay', @ischar);
addParameter(p, 'ID', [], @ischar);
addParameter(p, 'IconID', [], @ischar);

addParameter(p, 'OverlayX', 0.5, @isnumeric);
addParameter(p, 'OverlayY', 0.5, @isnumeric);
addParameter(p, 'OverlayUnitX', 'fraction', @ischar);
addParameter(p, 'OverlayUnitY', 'fraction', @ischar);

addParameter(p, 'ScreenX', 0.5, @isnumeric);
addParameter(p, 'ScreenY', 0.5, @isnumeric);
addParameter(p, 'ScreenUnitX', 'fraction', @ischar);
addParameter(p, 'ScreenUnitY', 'fraction', @ischar);

addParameter(p, 'RotationX', 0.5, @isnumeric);
addParameter(p, 'RotationY', 0.5, @isnumeric);
addParameter(p, 'RotationUnitX', 'fraction', @ischar);
addParameter(p, 'RotationUnitY', 'fraction', @ischar);

addParameter(p, 'SizeX', 0, @isnumeric);
addParameter(p, 'SizeY', 0, @isnumeric);
addParameter(p, 'SizeUnitX', 'pixels', @ischar);
addParameter(p, 'SizeUnitY', 'pixels', @ischar);

addParameter(p, 'Rotation', 0, @isnumeric);

parse(p, varargin{:});

Name = p.Results.Name;
ID = p.Results.ID;
IconID = p.Results.IconID;

OverlayX = p.Results.OverlayX;
OverlayY = p.Results.OverlayY;
OverlayUnitX = p.Results.OverlayUnitX;
OverlayUnitY = p.Results.OverlayUnitY;

ScreenX = p.Results.ScreenX;
ScreenY = p.Results.ScreenY;
ScreenUnitX = p.Results.ScreenUnitX;
ScreenUnitY = p.Results.ScreenUnitY;

RotationX = p.Results.RotationX;
RotationY = p.Results.RotationY;
RotationUnitX = p.Results.RotationUnitX;
RotationUnitY = p.Results.RotationUnitY;

SizeX = p.Results.SizeX;
SizeY = p.Results.SizeY;
SizeUnitX = p.Results.SizeUnitX;
SizeUnitY = p.Results.SizeUnitY;

Rotation = p.Results.Rotation;

%
str = [];
if isempty(ID)
    str = [str, sprintf('<ScreenOverlay>\n')];
else
    str = [str, sprintf('<ScreenOverlay id="%s">\n', ID)];
end
str = [str, sprintf('\t<name>%s</name>\n', Name)];
if isempty(IconID)
    str = [str, sprintf('\t<Icon>\n')];
else
    str = [str, sprintf('\t<Icon id="%s">\n', IconID)];
end
str = [str, sprintf('\t\t<href>%s</href>\n', overlaysource)];
str = [str, sprintf('\t</Icon>\n')];

str = [str, sprintf('\t<overlayXY x="%f" y="%f" xunits="%s" yunits="%s"/>\n', OverlayX, OverlayY, OverlayUnitX, OverlayUnitY)];
str = [str, sprintf('\t<screenXY x="%f" y="%f" xunits="%s" yunits="%s"/>\n', ScreenX, ScreenY, ScreenUnitX, ScreenUnitY)];
str = [str, sprintf('\t<rotationXY x="%f" y="%f" xunits="%s" yunits="%s"/>\n', RotationX, RotationY, RotationUnitX, RotationUnitY)];
str = [str, sprintf('\t<size x="%f" y="%f" xunits="%s" yunits="%s"/>\n', SizeX, SizeY, SizeUnitX, SizeUnitY)];
str = [str, sprintf('\t<rotation>%f</rotation>\n', Rotation)];

str = [str, sprintf('</ScreenOverlay>\n')];


end

