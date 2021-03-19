function [ kmlstr ] = ge_poly3( lat, lon, h, varargin )
%GE_POLY3 Summary of this function goes here
%   Detailed explanation goes here

p = inputParser();

addParameter(p, 'Name', 'poly3', @ischar);
addParameter(p,   'ID', [], @ischar);
addParameter(p, 'AltitudeMode', 'absolute', @ischar);
addParameter(p, 'Tesselate', true, @islogical);
addParameter(p, 'Extrude', false, @islogical);

addParameter(p, 'LineWidth', 1, @isnumeric);
addParameter(p, 'LineColor', [1,1,1], @isnumeric);
addParameter(p, 'LineAlpha', 1, @isnumeric);

addParameter(p, 'FaceColor', [1,1,1], @isnumeric);
addParameter(p, 'FaceAlpha', 1, @isnumeric);

addParameter(p, 'AutoClose', true, @islogical);


parse(p, varargin{:});
plot_name       = p.Results.Name;
plot_id         = p.Results.ID;
altitude_mode   = p.Results.AltitudeMode;
tesselate_flg   = p.Results.Tesselate;
extrude_flg     = p.Results.Extrude;

LineWidth       = p.Results.LineWidth;

LineColor       = p.Results.LineColor;
LineAlpha       = p.Results.LineAlpha;

FaceColor       = p.Results.FaceColor;
FaceAlpha       = p.Results.FaceAlpha;

AutoClose       = p.Results.AutoClose;


% Process Input ===========================================================
lat = lat(:);
lon = lon(:);
h   = h(:);

if AutoClose
    if lat(1) ~= lat(end) && lon(1) ~= lat(end) && h(1) ~= h(end)
        lat = [lat; lat(1)];
        lon = [lon; lon(1)];
        h   = [h;     h(1)];
    end
end

% Write File ==============================================================
kmlstr = [];
if isempty(plot_id)
    kmlstr = [kmlstr, sprintf('<Placemark>\n')];
else
    kmlstr = [kmlstr, sprintf('<Placemark id="%s">\n', plot_id)];
end
kmlstr = [kmlstr, sprintf('\t<name>%s</name>\n', plot_name)];

% Style
kmlstr = [kmlstr, sprintf('\t<Style>\n')];
kmlstr = [kmlstr, sprintf('\t\t<LineStyle>\n')];
kmlstr = [kmlstr, sprintf('\t\t\t<color>%s</color>\n', ge_rgb2hexstr(LineColor(1)*255,LineColor(2)*255,LineColor(3)*255, LineAlpha*255))];
kmlstr = [kmlstr, sprintf('\t\t\t<width>%f</width>\n', LineWidth)];
kmlstr = [kmlstr, sprintf('\t\t</LineStyle>\n')];
kmlstr = [kmlstr, sprintf('\t\t<PolyStyle>\n')];
kmlstr = [kmlstr, sprintf('\t\t\t<color>%s</color>\n', ge_rgb2hexstr(FaceColor(1)*255,FaceColor(2)*255,FaceColor(3)*255, FaceAlpha*255))];
kmlstr = [kmlstr, sprintf('\t\t</PolyStyle>\n')];
kmlstr = [kmlstr, sprintf('\t</Style>\n')];

% Polygon Definition
kmlstr = [kmlstr, sprintf('\t<Polygon>\n')];
kmlstr = [kmlstr, sprintf('\t\t<tessellate>%i</tessellate>\n', uint8(tesselate_flg))];
kmlstr = [kmlstr, sprintf('\t\t<extrude>%i</extrude>\n', uint8(extrude_flg))];
kmlstr = [kmlstr, sprintf('\t\t<altitudeMode>%s</altitudeMode>\n', altitude_mode)];
kmlstr = [kmlstr, sprintf('\t\t<outerBoundaryIs>\n')];
kmlstr = [kmlstr, sprintf('\t\t\t<LinearRing>\n')];
kmlstr = [kmlstr, sprintf('\t\t\t\t<coordinates>\n')];

% Coordinates
for i = 1:numel(lon)
    kmlstr = [kmlstr, sprintf('\t\t\t\t\t%.13f,%.13f,%.13f\n', lon(i)*180/pi, lat(i)*180/pi, h(i))]; %#ok<AGROW>
end


kmlstr = [kmlstr, sprintf('\t\t\t\t</coordinates>\n')];
kmlstr = [kmlstr, sprintf('\t\t\t</LinearRing>\n')];
kmlstr = [kmlstr, sprintf('\t\t</outerBoundaryIs>\n')];
kmlstr = [kmlstr, sprintf('\t</Polygon>\n')];
kmlstr = [kmlstr, sprintf('</Placemark>\n')];

end

