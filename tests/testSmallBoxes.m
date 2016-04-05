function err = testSmallBoxes(kybrd)
% globals, other variables

    try
        addpath src
        addpath misc/mfiles
        [resp_consts, scrn_consts, misc_consts] = mkConstants;
        tgt = mapRapid(dlmread(['misc/tfiles/','testrapid','.tgt']));
        fingers = unique(tgt.finger);
        dev = mkRespDev(kybrd, fingers, resp_consts);
        scrn = mkScreen(false, true, scrn_consts); % small, skip tests
        rect_locs = mkBoxes(scrn, dev.valid_indices);
        mkPressBoxes(scrn, [0 1 0 0], rect_locs, scrn.green);
        mkSmallBoxes(scrn, [0 1 0 0], rect_locs, scrn.colour);
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
