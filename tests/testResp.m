
function err = testResp(kybrd)

try
    addpath src
    CCCOMBO = 5;
    [resp_consts, scrn_consts, misc_consts] = mkConstants;
    tgt = mapRapid(dlmread(['misc/tfiles/','testBehav_rapid','.tgt']));
    fingers = unique(tgt.finger);
    dev = mkRespDev(kybrd, fingers, resp_consts);
    if strcmpi(dev.type, 'keyboard')
        KbQueueStart;
    else
        stop(dev.device);
        start(dev.device);
        trigger(dev.device);
    end
    new_press = [NaN NaN];
    update_scrn_press = zeros(1, length(dev.valid_indices));
    while isnan(new_press(1))
        [new_press, update_scrn_press] = checkTempResp(dev, update_scrn_press);
        WaitSecs(0.01);
    end
    new_press
    update_scrn_press

    rmDev(dev);
    Priority(0);
    sca;
    err = 0;
    catch ME
        err = 1;
        sca;
        Priority(0);
        warning('test failed!');
        rethrow(ME);
    end
end
