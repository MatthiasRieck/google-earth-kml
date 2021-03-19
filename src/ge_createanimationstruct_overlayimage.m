function [ struct ] = ge_createanimationstruct_overlayimage( iconID, time, filenames )
%GE_CREATEANIMATIONSTRUCT_LOCATION Summary of this function goes here
%   Detailed explanation goes here
% TODO: Write documentation

% TODO: Add other positions ScreenY Overlay, Size, RotationXY, 

% Process
[time_unique, ind] = unique(time);

if numel(ind) ~= numel(time)
    warning('Data was not unique');
end

%
struct.type = 'Icon';
struct.id   = iconID;
struct.time = time_unique;
struct.data.href = filenames;

end

