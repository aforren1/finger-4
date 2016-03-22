function output = Rapid
    % Rapid-fire training
    try % rethrow error after closing Screens, sounds, etc.

        %% Get functions into memory, add things to the path
        WaitSecs(0.001);
        GetSecs;
        Screen('preference', 'verbosity', 1);
        warning('off', 'all');
        addpath('misc', 'src'); %'misc/mfiles' for ifelse

        %% constants and other variables used in this scope
        [c_resp, c_scrn, c_misc] = mkConstants; % `c_` denotes consts
        CCCOMBO = 0;
        SCORE = GetSecs; % start timekeeping after getting everything set up

        %% Put together resources
        ui = mkUI;
        scrn = mkScreen(ui.size, ui.skip, c_scrn);
        tgt = mapRapid(dlmread(['misc/tfiles/', ui.tgt]));
        tgt.id = ui.id;

        rawimg = mkRawImg(tgt.img_type(1));
        ptbimg = mkPtbImg(rawimg, scrn);
        if tgt.swapped % swap images
            ptbimg([tgt.swap2 tgt.swap1]) = ptbimg([tgt.swap1 tgt.swap2]);
        end
        %ptbimg = ptbimg(unique(tgt.finger)); % subset based on fingers
        % make the response device and figure out which are relevant
        dev = mkRespDev(ui.kybrd, unique(tgt.finger), c_resp);

        snd = mkRapidSounds;
        output = cell(1, max(tgt.trial));
        HideCursor;
        dev.zero_volts = mkCountdown(scrn, dev, c_misc);

        for ii = 1:length(tgt.trial)
            Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
            mkBoxes(scrn, dev.valid_indices);
            Screen('TextSize', scrn.window, 14 + CCCOMBO);
            DrawFormattedText(scrn.window, num2str(CCCOMBO), 'right', ...
                              scrn.TXT_RATIO*scrn.size(4) , scrn.txtcol);
            Screen('Flip', scrn.window);
            [tempout{ii},CCCOMBO] = trialRapid(scrn, tgt, ptbimg,...
                                               dev, snd, ii, CCCOMBO);
        end

        SCORE = round(GetSecs - SCORE) * 100; % total duration of the block
        Screen('TextSize', scrn.window, 40);
        DrawFormattedText(scrn.window, ['FINAL SCORE: ', num2str(SCORE)],...
                          'center', 'center', scrn.txtcol);
        Screen('Flip', scrn.window);
        WaitSecs(2);

        % format departing data
        output = cell2mat(tempout(1));
        for ii = 2:length(tempout) % convert output to 2d matrix
            output = [output; cell2mat(tempout(ii))];
        end

        % Wrap up residual things in the environment
        Priority(0);
        sca;
        ShowCursor;
        try KbQueueRelease; catch warning('Not using the keyboard') end;
        try PsychPortAudio('Close'); catch warning('No active audio device') end

    catch ME
        Priority(0);
        sca;
        ShowCursor;
        try KbQueueRelease; catch warning('Not using the keyboard') end;
        try PsychPortAudio('Close'); catch warning('No active audio device') end
            % other nice things to clean up before failing
        ME
        rethrow(ME);
    end

end
