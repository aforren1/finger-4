function scrn = mkScreen(size, skip, scrn_consts)
% inputs: size (bool)
%         skip (bool)
%         scrn_consts (struct, see mkConstants)
%
% outputs: scrn (struct with):
%    num: screen number
%    colour: the colour of the background
%    black, white, gray, red, blue, green (all rgb)
%    window: What `Flip` and the like refer to
%    size: size of screen
%    center: the center of the screen [x, y]
%    priority: max priority
%    ifi: interflip interval

    scrn = scrn_consts;
    AssertOpenGL;
    if skip
        Screen('Preference', 'SkipSyncTests', 1);
        Screen('Preference', 'SuppressAllWarnings', 1);
    end
    screens = Screen('Screens');
    scrn.num = max(screens);
    scrn.black = BlackIndex(scrn.num);
    scrn.white = WhiteIndex(scrn.num);
    scrn.gray = [190 190 190];
    scrn.red = [255, 30, 63];
    scrn.blue = [85, 98, 255];
    scrn.green = [97, 255, 77];
    scrn.colour = ifelse(scrn.REVERSE_COLOURS, scrn.white, scrn.black);
    scrn.txtcol = ifelse(scrn.REVERSE_COLOURS, scrn.black, scrn.white);

    if size % big screen
        [scrn.window, scrn.size] = Screen('OpenWindow', scrn.num, scrn.colour);
    else
        [scrn.window, scrn.size] = Screen('OpenWindow', scrn.num,...
        scrn.colour, [400 400 800 800]);
    end
    [scrn.center(1), scrn.center(2)] = RectCenter(scrn.size); %x,y of center
    Screen('BlendFunction', scrn.window, ...
           'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    scrn.priority = MaxPriority(scrn.window);
    scrn.ifi = Screen('GetFlipInterval', scrn.window);
end
