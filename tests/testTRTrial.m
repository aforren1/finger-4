function err = testTRTrial(kybrd)
% globals, other variables

    try
        addpath src
        snd = mkTRSounds;
        ii = 1;
        [resp_consts, scrn_consts, misc_consts] = mkConstants;
        tgt = mapTR(dlmread(['misc/tfiles/','testBehav_tr.tgt']));
        tgt.id = 55;
        fingers = unique(tgt.finger);
        dev = mkRespDev(kybrd, fingers, resp_consts);
        scrn = mkScreen(false, true, scrn_consts); % small, skip tests
        rawimg = mkRawImg(tgt.img_type(1)); %shapes
        ptbimg = mkPtbImg(rawimg, scrn);

        Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
        mkBoxes(scrn, dev.valid_indices);
        t_ref = Screen('Flip', scrn.window);

        % think about this
        Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
        mkBoxes(scrn, dev.valid_indices);
        Priority(scrn.priority);
        t_ref_copy = Screen('Flip', scrn.window, t_ref + 0.5*scrn.ifi);
        PsychPortAudio('Start', 1, 1, t_ref + scrn.ifi, 0); % 1 is beep train
        t_ref = t_ref_copy;
        startDev(dev);
        t_bp4 = t_ref + 0.5 + 1.5; % 0.5 for aud delay, 1.5 for actual train dur
        img_frame = round((0.5 + 1)/scrn.ifi); %draw on last frame for test
        n_frames = round(2.4/scrn.ifi);

        for frame = 1:n_frames
            Screen('FillRect', scrn.window, scrn.colour);
            mkBoxes(scrn, dev.valid_indices);

            if frame >= img_frame
                Screen('DrawTexture', scrn.window, ptbimg(tgt.finger(ii)));
            end


            Screen('DrawingFinished', scrn.window);
            t_ref = Screen('Flip',scrn.window, t_ref + (0.5) * scrn.ifi);
        end

        Priority(0);

        purge;
    catch ME
        purge;
        warning('test failed!');
        rethrow(ME);
    end
end
