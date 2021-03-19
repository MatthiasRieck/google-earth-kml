function [ kmlstr ] = ge_point3( lat, lon, h, varargin )
%GE_POINT3 Summary of this function goes here
%   Detailed explanation goes here

% Input Parser ============================================================
p = inputParser();

addParameter(p, 'Name', 'point3', @ischar);
addParameter(p, 'ID', [], @ischar);
addParameter(p, 'IconColor', [1,1,1], @isnumeric);
addParameter(p, 'IconAlpha', 1, @isnumeric);
addParameter(p, 'IconScale', 1, @isnumeric);
addParameter(p, 'IconType', 'point', @ischar);
addParameter(p, 'LabelColor', [1,1,1], @isnumeric);
addParameter(p, 'LabelAlpha', 1, @isnumeric);
addParameter(p, 'LabelScale', 1, @isnumeric);
addParameter(p, 'AltitudeMode', 'absolute');

parse(p, varargin{:});

point_name = p.Results.Name;
point_ID = p.Results.Name;
point_IconColor = p.Results.IconColor;
point_IconAlpha = p.Results.IconAlpha;
point_IconScale = p.Results.IconScale;
point_IconType  = p.Results.IconType;
point_LabelColor = p.Results.LabelColor;
point_LabelAlpha = p.Results.LabelAlpha;
point_LabelScale = p.Results.LabelScale;
point_altitudemode = p.Results.AltitudeMode;

% Process Input ===========================================================
point_IconStr = 'http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png';
if strcmpi(point_IconType, 'point')
    point_IconStr = 'http://maps.google.com/mapfiles/kml/shapes/road_shield3.png';
elseif strcmpi(point_IconType, 'pin')
    point_IconStr = 'http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png';
end

% Write File ==============================================================
kmlstr = [];

if isempty(point_ID)
    kmlstr = [kmlstr, sprintf('<Placemark>\n')];
else
    kmlstr = [kmlstr, sprintf('<Placemark id="%s">\n', point_ID)];
end
kmlstr = [kmlstr, sprintf('\t<name>%s</name>\n', point_name)];

kmlstr = [kmlstr, sprintf('\t<Style>\n')];
kmlstr = [kmlstr, sprintf('\t\t<IconStyle>\n')];
kmlstr = [kmlstr, sprintf('\t\t\t<color>%s</color>\n',...
    ge_rgb2hexstr(point_IconColor(1)*255,point_IconColor(2)*255,point_IconColor(3)*255, point_IconAlpha*255))];
kmlstr = [kmlstr, sprintf('\t\t\t<scale>%f</scale>\n', point_IconScale)];
kmlstr = [kmlstr, sprintf('\t\t\t<Icon>\n')];
kmlstr = [kmlstr, sprintf('\t\t\t\t<href>%s</href>\n', point_IconStr)];
kmlstr = [kmlstr, sprintf('\t\t\t</Icon>\n')];
kmlstr = [kmlstr, sprintf('\t\t</IconStyle>\n')];
kmlstr = [kmlstr, sprintf('\t\t<LabelStyle>\n')];
kmlstr = [kmlstr, sprintf('\t\t\t<color>%s</color>\n',...
    ge_rgb2hexstr(point_LabelColor(1)*255,point_LabelColor(2)*255,point_LabelColor(3)*255, point_LabelAlpha*255))];
kmlstr = [kmlstr, sprintf('\t\t\t<scale>%f</scale>\n', point_LabelScale)];
kmlstr = [kmlstr, sprintf('\t\t</LabelStyle>\n')];
kmlstr = [kmlstr, sprintf('\t</Style>\n')];

kmlstr = [kmlstr, sprintf('\t<Point>\n')];
kmlstr = [kmlstr, sprintf('\t\t<altitudeMode>%s</altitudeMode>\n', point_altitudemode)];
kmlstr = [kmlstr, sprintf('\t\t<coordinates>%.13f,%.13f,%.13f</coordinates>\n', lon*180/pi, lat*180/pi, h)];
kmlstr = [kmlstr, sprintf('\t\t\t</Point>\n')];
kmlstr = [kmlstr, sprintf('\t\t</Placemark>\n')];

end

