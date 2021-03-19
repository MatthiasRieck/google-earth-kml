function [ str ] = ge_animate( AnimationObjects, varargin )
% Combinate multiple animation objects to create a combined animation using
% a kml tour
% 
% Required Inputs
% ?AnimationObjects Cell array of or single animation struct
% 
% Param-Value-Pairs
% %#TABLE[l c c l]{c c c n}
% -------------------------------------------------------------------------
% Name             | Type           | Default Value    | Description
% -------------------------------------------------------------------------
% Name             | char           | animation        | Animation Name
% -------------------------------------------------------------------------

% Input Parser ============================================================
p = inputParser();

% Parameter Value Pairs
addParameter(p, 'Name', 'animation', @ischar);

% Parse
parse(p, varargin{:});
Name = p.Results.Name;

% Process Inputs ==========================================================
if ~iscell(AnimationObjects)
    AnimationObjects = {AnimationObjects};
end

% Process Animation Objects ===============================================
% make time frame unique
times = [];

for i = 1:numel(AnimationObjects)
    times = [times; AnimationObjects{i}.time(:)]; %#ok<AGROW>
end

times = unique(times);

% Check if there is a camera setting
hasCameraAnimation = false;
cameraIndices = [];
for i = 1:numel(AnimationObjects)
    if strcmpi(AnimationObjects{i}.type, 'Camera') || strcmpi(AnimationObjects{i}.type, 'LookAt')
        cameraIndices = [cameraIndices, i];
        hasCameraAnimation = true;
    end
end

% Extract Camera Setting from AnimationObjects
if hasCameraAnimation
    cameraObject                    = AnimationObjects(cameraIndices);
    AnimationObjects(cameraIndices) = [];
    if numel(cameraIndices) > 1
        warning('More than one Camera defined, taking first one');
        cameraObject = cameraObject(1);
    end
    
    cameraObject = cameraObject{1};
end

% Write Animation =========================================================
str = [];

str = [str, sprintf('<gx:Tour>\n')];
str = [str, sprintf('\t<name>%s</name>\n', Name)];
str = [str, sprintf('\t<gx:Playlist>\n')];

% Loop Over time steps
for i = 1:numel(times)
    str = [str, sprintf('\t\t<gx:AnimatedUpdate>\n')];
    
    % Get Animation Duration
    duration = 0;
    if i > 1
        duration = times(i) - times(i-1);
    end
    
    str = [str, sprintf('\t\t\t<gx:duration>%f</gx:duration>\n', duration)];
    str = [str, sprintf('\t\t\t<Update>\n')];
    str = [str, sprintf('\t\t\t\t<targetHref></targetHref>\n')];
    str = [str, sprintf('\t\t\t\t<Change>\n')];
    
    % Iterate ober all animation objects
    for k_obj = 1:numel(AnimationObjects)
        obj = AnimationObjects{k_obj};
        str = [str, sprintf('\t\t\t\t\t<%s targetId="%s">\n', obj.type, obj.id)];
        
        obj_time = obj.time;
        
        names = fieldnames(obj.data);
        
        for k_name = 1:numel(names)
            entry = obj.data.(names{k_name});
            if strcmpi('Icon', obj.type)
                indtimeoverlay = find(obj.time == times(i));
                str = [str, sprintf('\t\t\t\t\t\t<%s>%s</%s>\n',...
                    names{k_name},...
                    obj.data.(names{k_name}){indtimeoverlay},...
                    names{k_name})];
            elseif isstruct(entry)
                str = [str, sprintf('\t\t\t\t\t\t<%s', names{k_name})];
                
                entychilds = fieldnames(entry);
                for k_child = 1:numel(entychilds)
                    str = [str, sprintf(' %s="%f"', entychilds{k_child},...
                        interp1(obj_time,entry.(entychilds{k_child}),times(i)))];
                end
                str = [str, sprintf('/>\n')];
            else
                str = [str, sprintf('\t\t\t\t\t\t<%s>%f</%s>\n',...
                    names{k_name},...
                    interp1(obj_time,entry,times(i)),...
                    names{k_name})];
            end
        end
        str = [str, sprintf('\t\t\t\t\t</%s>\n', obj.type)];
    end
    
    str = [str, sprintf('\t\t\t\t</Change>\n')];    
    str = [str, sprintf('\t\t\t</Update>\n')];
    str = [str, sprintf('\t\t</gx:AnimatedUpdate>\n')];
    
    % Wait
    if hasCameraAnimation
        str = [str, sprintf('\t\t<gx:FlyTo>\n')];
        str = [str, sprintf('\t\t\t<gx:duration>%f</gx:duration>\n', duration)];
        str = [str, sprintf('\t\t\t<gx:flyToMode>%s</gx:flyToMode>\n', cameraObject.flytomode)];
        str = [str, sprintf('\t\t\t<%s>\n', cameraObject.type)];
        
        names = fieldnames(cameraObject.data);
        for k_name = 1:numel(names)
            entry = cameraObject.data.(names{k_name});
            str = [str, sprintf('\t\t\t\t<%s>%f</%s>\n',...
                    strrep(names{k_name}, '_', ':'),...
                    interp1(cameraObject.time,entry,times(i)),...
                    strrep(names{k_name}, '_', ':'))];
        end
        str = [str, sprintf('\t\t\t\t<altitudeMode>%s</altitudeMode>\n', cameraObject.altitudemode)];
        str = [str, sprintf('\t\t\t</%s>\n', cameraObject.type)];
        str = [str, sprintf('\t\t</gx:FlyTo>\n')];
    else
        str = [str, sprintf('\t\t<gx:Wait>\n')];
        str = [str, sprintf('\t\t\t<gx:duration>%f</gx:duration>\n', duration)];
        str = [str, sprintf('\t\t</gx:Wait>\n')];
    end
end

% trailing
str = [str, sprintf('\t</gx:Playlist>\n')];
str = [str, sprintf('</gx:Tour>\n')];

end

