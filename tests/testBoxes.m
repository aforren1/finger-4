function err = testBoxes(kybrd)
% globals, other variables

    try
        addpath src
        [resp_consts, scrn_consts, misc_consts] = mkConstants;
        tgt = mapRapid(dlmread(['misc/tfiles/','dy3_bk4_ez0_sw1_sh1.tgt']));
        fingers = unique(tgt.finger);
        dev = mkRespDev(kybrd, fingers, resp_consts);
        scrn = mkScreen(false, true, scrn_consts); % small, skip tests
        rect_locs = mkBoxes(scrn, dev.valid_indices);
        Screen('Flip', scrn.window);
        WaitSecs(.5);
        rmDev(dev);
        sca;
        err = 0;
    catch ME
        err = 1;
        sca;
        warning('test failed!');
        rethrow(ME);
    end
end
