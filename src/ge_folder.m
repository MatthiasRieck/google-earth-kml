function [ str ] = ge_folder( name, kmlstr_content, varargin )
%GE_FOLDER Summary of this function goes here
%   Detailed explanation goes here


p = inputParser();

addParameter(p, 'Open', false, @islogical);
addParameter(p, 'Visible', true, @islogical);
addParameter(p, 'Type', 'normal', @ischar); % normal, hide, radio

parse(p, varargin{:});

open_flg    = p.Results.Open;
type_str    = p.Results.Type;
visible_flg = p.Results.Visible;

str = [];

str = [str, sprintf('<Folder>\n')];
str = [str, sprintf('\t<name>%s</name>\n', name)];
str = [str, sprintf('\t<visibility>%i</visibility>\n', uint8(visible_flg))];
if open_flg
    str = [str, sprintf('\t<open>%i</open>\n', uint8(open_flg))];
end
if strcmpi(type_str, 'radio')
%     <Style>
% 			<ListStyle>
% 				<listItemType>radioFolder</listItemType>
% 				<bgColor>ff0000ff</bgColor>
% 				<maxSnippetLines>4</maxSnippetLines>
% 			</ListStyle>
% 		</Style>
    str = [str, sprintf('\t<Style>\n')];
    str = [str, sprintf('\t\t<ListStyle>\n')];
    str = [str, sprintf('\t\t\t<listItemType>radioFolder</listItemType>\n')];
    str = [str, sprintf('\t\t\t<bgColor>00000000</bgColor>\n')];
    str = [str, sprintf('\t\t\t<maxSnippetLines>2</maxSnippetLines>\n')];
    str = [str, sprintf('\t\t</ListStyle>\n')];
    str = [str, sprintf('\t</Style>\n')];
elseif strcmpi(type_str, 'hide')
    str = [str, sprintf('\t<Style>\n')];
    str = [str, sprintf('\t\t<ListStyle>\n')];
    str = [str, sprintf('\t\t\t<listItemType>checkHideChildren</listItemType>\n')];
    str = [str, sprintf('\t\t\t<bgColor>00000000</bgColor>\n')];
    str = [str, sprintf('\t\t\t<maxSnippetLines>2</maxSnippetLines>\n')];
    str = [str, sprintf('\t\t</ListStyle>\n')];
    str = [str, sprintf('\t</Style>\n')];
end
str = [str, sprintf('%s\n', ge_identstr(kmlstr_content))];
str = [str, sprintf('</Folder>')];

end

