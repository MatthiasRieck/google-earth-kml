function [ hexstr ] = ge_rgb2hexstr(r,g,b,a)

a = round(a);
b = round(b);
g = round(g);
r = round(r);

hexstr = sprintf('%02x%02x%02x%02x', a,b,g,r);

end
