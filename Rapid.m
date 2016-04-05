function output = Rapid
    % Rapid-fire training
    try % rethrow error after closing Screens, sounds, etc.

        %% Get functions into memory, add things to the path
        WaitSecs(0.001);
        GetSecs;
        Screen('preference', 'verbosity', 1);
        warning('off', 'all');
        addpath('misc', 'src', 'misc/mfiles'); % for ifelse

        %% constants and other variables used in this scope
        [c_resp, c_scrn, c_misc] = mkConstants; % `c_` denotes consts
        CCCOMBO = 0;

        %% Put together resources
        ui = mkUI;
        scrn = mkScreen(ui.size, ui.skip, c_scrn);
        tgt = mapRapid(dlmread(['misc/tfiles/', ui.tgt, '.tgt']));
        tgt.id = ui.id;

        rawimg = mkRawImg(tgt.img_type(1));
        ptbimg = mkPtbImg(rawimg, scrn);
        if tgt.swapped % swap images
            ptbimg([tgt.swap2 tgt.swap1]) = ptbimg([tgt.swap1 tgt.swap2]);
        end

        % make the response device and figure out which are relevant
        dev = mkRespDev(ui.kybrd, unique(tgt.finger), c_resp);

        mkRapidSounds;
        output = cell(1, max(tgt.trial));
        HideCursor;
        dev.zero_volts = mkCountdown(scrn, dev, c_misc);
        SCORE = GetSecs; % start timekeeping after getting everything set up
        MAX_COMBO = 0;

        for ii = 1:length(tgt.trial)
            Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
            mkBoxes(scrn, dev.valid_indices);
            %drawCCCOMBO(scrn, CCCOMBO);
            Screen('Flip', scrn.window);
            [tempout{ii},CCCOMBO] = trialRapid(scrn, tgt, ptbimg,...
                                               dev, ii, CCCOMBO);
            MAX_COMBO = ifelse(CCCOMBO > MAX_COMBO, CCCOMBO, MAX_COMBO);
        end

        SCORE = 1000 - (round(GetSecs - SCORE) * 100); % total duration of the block
        Screen('TextSize', scrn.window, 40);
        DrawFormattedText(scrn.window, ['FINAL SCORE: ', num2str(SCORE)],...
                          'center', 'center', scrn.txtcol);
        Screen('Flip', scrn.window);
        WaitSecs(2);
        DrawFormattedText(scrn.window, ['MAXIMUM COMBO: ', num2str(MAX_COMBO)],...
                          'center', 'center', scrn.txtcol);
        Screen('Flip', scrn.window);
        WaitSecs(2);

        % format departing data
        output = cell2mat(tempout(1));
        for ii = 2:length(tempout) % convert output to 2d matrix
            output = [output; cell2mat(tempout(ii))];
        end
        dlmwrite(['data/id',num2str(ui.id),'_', ui.tgt, '.csv'], output);
        % Wrap up residual things in the environment
        purge;
        Priority(0);

    catch ME
        purge;
            % other nice things to clean up before failing
        rethrow(ME);
    end

end
