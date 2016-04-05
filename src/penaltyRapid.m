
function u_s_p = penaltyRapid(scrn, dev, tgt, ptbimg, u_s_p, ii, CCCOMBO)

    %wait until released; hack for now
    % punishment time
    rect_locs = mkBoxes(scrn, dev.valid_indices);
    mkPressBoxes(scrn, u_s_p, rect_locs, scrn.red);
    Screen('DrawTexture', scrn.window, ptbimg(tgt.finger(ii)));
    %drawCCCOMBO(scrn, CCCOMBO);
    Screen('Flip', scrn.window);
    WaitSecs(.8);
    u_s_p = zeros(1, length(dev.valid_indices));
    rect_locs = mkBoxes(scrn, dev.valid_indices);
    %drawCCCOMBO(scrn, CCCOMBO);
    Screen('DrawTexture', scrn.window, ptbimg(tgt.finger(ii)));
    Screen('Flip', scrn.window);
    clearDev(dev);

end
