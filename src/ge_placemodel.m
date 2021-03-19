function [ str ] = ge_placemodel( lat_rad,lon_rad,alt_m,Psi_rad,Theta_rad,Chi_rad,FileName, varargin )
%GE_PLACEDAEMODEL Summary of this function goes here
%   Detailed explanation goes here

% Intput Parser ===========================================================
p = inputParser();

addParameter(p,           'Name', '3D-Model',    @ischar);
addParameter(p,    'Location_id',         [],    @ischar);
addParameter(p, 'Orientation_id',         [],    @ischar);
addParameter(p,         'xScale',          1, @isnumeric);
addParameter(p,         'yScale',          1, @isnumeric);
addParameter(p,         'zScale',          1, @isnumeric);
addParameter(p,  'AltitudeModel', 'absolute', @ischar);

parse(p, varargin{:});

model_name      = p.Results.Name;
location_id     = p.Results.Location_id;
orientation_id  = p.Results.Orientation_id;
xScale          = p.Results.xScale;
yScale          = p.Results.yScale;
zScale          = p.Results.zScale;
AltitudeModel   = p.Results.AltitudeModel;

% Make kml part ===========================================================
str = [];

% <Placemark>
str = [str, sprintf('<Placemark>\n')];
%     <name>Modell ohne Namen</name>
str = [str, sprintf('<name>%s</name>\n', model_name)];
%     <Model id="model_1">
str = [str, sprintf('<Model>\n')];
%     <altitudeMode>absolute</altitudeMode>
str = [str, sprintf('<altitudeMode>%s</altitudeMode>\n', AltitudeModel)];
%     <Location>
if isempty(location_id)
    str = [str, sprintf('<Location>\n')];
else
    str = [str, sprintf('<Location id="%s">\n', location_id)];
end
%     <longitude>140.0364117366013</longitude>
str = [str, sprintf('<longitude>%f</longitude>\n',lon_rad*180/pi)];
%     <latitude>35.63376102400667</latitude>
str = [str, sprintf('<latitude>%f</latitude>\n',lat_rad*180/pi)];
%     <altitude>0</altitude>
str = [str, sprintf('<altitude>%f</altitude>\n',alt_m)];
%     </Location>
str = [str, sprintf('</Location>\n')];
%     <Orientation>
if isempty(orientation_id)
    str = [str, sprintf('<Orientation>\n')];
else
    str = [str, sprintf('<Orientation id="%s">\n', orientation_id)];
end
%     <heading>0</heading>
str = [str, sprintf('<heading>%f</heading>\n',Psi_rad*180/pi)];
%     <tilt>0</tilt>
str = [str, sprintf('<tilt>%f</tilt>\n',Theta_rad*180/pi)];
%     <roll>0</roll>
str = [str, sprintf('<roll>%f</roll>\n',Chi_rad*180/pi)];
%     </Orientation>
str = [str, sprintf('</Orientation>\n')];
%     <Scale>
str = [str, sprintf('<Scale>\n')];
%     <x>1</x>
str = [str, sprintf('<x>%f</x>\n',xScale)];
%     <y>1</y>
str = [str, sprintf('<y>%f</y>\n',yScale)];
%     <z>1</z>
str = [str, sprintf('<z>%f</z>\n',zScale)];
%     </Scale>
str = [str, sprintf('</Scale>\n')];
%     <Link>
str = [str, sprintf('<Link>\n')];

str = [str, sprintf('<href>%s</href>\n',FileName)];
%     </Link>
str = [str, sprintf('</Link>\n')];
%     <ResourceMap>
str = [str, sprintf('<ResourceMap>\n')];
%     </ResourceMap>
str = [str, sprintf('</ResourceMap>\n')];
%     </Model>
str = [str, sprintf('</Model>\n')];
%     </Placemark>
str = [str, sprintf('</Placemark>\n')];

end

