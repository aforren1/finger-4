function err = testPtbImg
    % test displaying images with psychtoolbox
    try
        addpath src
        addpath misc/mfiles
        rawim = mkRawImg(1); %shapes
        rawim2 = mkRawImg(0); % hands
        [~, scrn_consts, ~] = mkConstants;
        %scrn_consts.REVERSE_COLOURS = true;
        scrn = mkScreen(false, true, scrn_consts);

        ptbim = mkPtbImg(rawim, scrn);
        Screen('DrawTexture', scrn.window, ptbim(3));
        Screen('Flip', scrn.window);
        WaitSecs(.3);
        ptbim = mkPtbImg(rawim2, scrn);
        Screen('DrawTexture', scrn.window, ptbim(3));
        Screen('Flip', scrn.window);
        WaitSecs(1);
        sca;
        err = 0;
    catch ME
        err = 1;
        sca;
        warning('test failed!');
        rethrow(ME);
    end
end
