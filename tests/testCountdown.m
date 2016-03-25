
function err = testCountdown(kybrd)
% globals, other variables

    try
        addpath src
        [resp_consts, scrn_consts, misc_consts] = mkConstants;
        tgt = mapRapid(dlmread(['misc/tfiles/','testBehav_rapid.tgt']));
        fingers = unique(tgt.finger);
        dev = mkRespDev(kybrd, fingers, resp_consts);
        scrn = mkScreen(false, true, scrn_consts); % small, skip tests
        zero_volts = mkCountdown(scrn, dev, misc_consts);
        zero_volts
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
