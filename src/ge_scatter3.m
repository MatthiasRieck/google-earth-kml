function [ kmlstr ] = ge_scatter3( lat, lon, h, u, v, w, varargin )
%GE_SCATTER3 Summary of this function goes here
%   Detailed explanation goes here

kmlstr = [];

for i = 1:numel(lat)
    [vlat, vlon, vh] = ned2geodetic(u(i), v(i), w(i), lat(i), lon(i), h(i),...
        referenceEllipsoid('WGS84'), 'rad');
    
    kmlstr = [kmlstr,...
        ge_plot3([lat(i), vlat], [lon(i), vlon], [h(i), vh], varargin{:})]; %#ok<AGROW>
end

end

