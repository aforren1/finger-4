function mkSmallBoxes(scrn, update_scrn_press, rect_locs, colour);

    if any(update_scrn_press > 0)
        Screen('FillRect', scrn.window, colour,...
               rect_locs(:, find(update_scrn_press > 0)) + ...
               [1;1;-1;-1]*(rect_locs(3,1) - rect_locs(1,1))*.15);
    end
end
