function mkPressBoxes(scrn, update_scrn_press, rect_locs, colour);

    if any(update_scrn_press > 0)
        Screen('FillRect', scrn.window, colour,...
               rect_locs(:, find(update_scrn_press > 0)));
    end
end
