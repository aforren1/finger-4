function %drawCCCOMBO(scrn, CCCOMBO)

    Screen('TextSize', scrn.window, 14 + CCCOMBO);
    DrawFormattedText(scrn.window, num2str(CCCOMBO), .8*scrn.size(3), ...
                      scrn.TXT_RATIO*scrn.size(4) , scrn.txtcol);

end
