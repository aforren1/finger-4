function ui = mkUI

ui.id = input('What is the subject ID (numeric)? ');
ui.tgt = input('What is the target file (without .tgt append)? ', 's');
%ui.size = input('Big screen (true or false)? false for debug. ');
ui.size = true;
%ui.skip = input('Skip Psychtoolbox screen tests (true or false)? ');
ui.skip = true;
%ui.kybrd = input('Use the keyboard (true or false)? ');
ui.kybrd = true;

end
