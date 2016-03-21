function [resp_consts, scrn_consts, misc_consts] = mkConstants;
% I want to move away from global constants, which are slower
    resp_consts.FORCE_MIN = 3; % min force to count as response
    resp_consts.FORCE_MAX = 5; % max force to count as response
    resp_consts.PRESS_TOL = 0.075; % 75ms on either side of beep
    resp_consts.ALL_KEYS = {'a','w','e','f','v','b','h','u','i','l'};

    % note that scrn is turning into a god object...
    scrn_consts.CROSS_RATIO = 0.05; % fix cross is 5% of screen size
    scrn_consts.CROSS_PIX = 3; % pixel width of crosses
    scrn_consts.TXT_RATIO = 0.18; % text size as a ratio of y-axis size
    scrn_consts.IMG_RATIO = 0.22; % image size as a ratio of y-axis size
    scrn_consts.REVERSE_COLOURS = false; % false = black background

    % miscellaneous single-use constants
    misc_consts.LEN_CNTDWN = 6; % length of countdown
    misc_consts.START_ZERO = 3; % start of zeroing for transducers
    misc_consts.LEN_ZERO = 2; % length of zeroing
end
