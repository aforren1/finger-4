function err = testScreen
% make sure screen works ok

    try
        addpath src
        [~, scrn_consts, ~] = mkConstants;
        scrn = mkScreen(false, true, scrn_consts);
        Screen('FillRect', scrn.window, scrn.red);
        WaitSecs(.5);
        Screen('Flip', scrn.window);
        Screen('FillRect', scrn.window, scrn.colour);
        WaitSecs(.5);
        Screen('Flip', scrn.window);
        WaitSecs(.3);
        sca;
        err = 0;
    catch ME
        err = 1;
        sca;
        warning('test failed!');
        rethrow(ME);
    end
end
