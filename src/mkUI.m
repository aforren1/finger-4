function ui = mkUI

ui.id = input('What is the subject ID (numeric)? ');
ui.day = input('Which day is it (numeric, ie. 1 through 5)? ');
ui.block = input('Which block is it (numeric, ie. 1 through 10)? ')
%ui.tgt = input('What is the target file (without .tgt append)? ', 's');
%ui.size = input('Big screen (true or false)? false for debug. ');
ui.size = false;
%ui.skip = input('Skip Psychtoolbox screen tests (true or false)? ');
ui.skip = true;
%ui.kybrd = input('Use the keyboard (true or false)? ');
ui.kybrd = true;

end
