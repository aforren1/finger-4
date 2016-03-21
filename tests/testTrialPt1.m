
function err = testTrialPt1(kybrd)
% globals, other variables

    try
        addpath src
        snd = mkRapidSounds;
        CCCOMBO = 10;
        ii = 1;
        [resp_consts, scrn_consts, misc_consts] = mkConstants;
        tgt = mapRapid(dlmread(['misc/tfiles/','dy3_bk4_ez0_sw1_sh1.tgt']));
        fingers = unique(tgt.finger);
        dev = mkRespDev(kybrd, fingers, resp_consts);
        scrn = mkScreen(false, true, scrn_consts); % small, skip tests
        rawimg = mkRawImg(1); %shapes
        ptbimg = mkPtbImg(rawimg, scrn);

        Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
        mkBoxes(scrn, dev.valid_indices);
        drawCCCOMBO(scrn, CCCOMBO);
        Priority(scrn.priority);
        Screen('DrawTexture', scrn.window, ptbimg(tgt.finger(ii)));

        t_ref = GetSecs; % I *think* this tells 'Flip' to return a projected time
        t_img = Screen('Flip', scrn.window, t_ref + 0.5*scrn.ifi);
        startDev(dev);
        new_press = nan(3,2); % store responses; (:,1) is
        update_scrn_press = zeros(1, length(dev.valid_indices));
        while isnan(new_press(1))
            [new_press(1,:), update_scrn_press] = checkTempResp(dev,...
                                                                update_scrn_press);
            WaitSecs(0.01);
        end

        if new_press(1,1) ~= tgt.finger(ii)
            %wait until released
            CCCOMBO = 0;
            update_scrn_press = penaltyRapid(scrn, dev, tgt, ptbimg,...
                                             update_scrn_press, ii, CCCOMBO);
            % try 2
            while isnan(new_press(2,1))
                [new_press(2,:), update_scrn_press] = checkTempResp(dev,...
                                                                    update_scrn_press);
                WaitSecs(0.01);
            end
            if new_press(2,1) ~= tgt.finger(ii)
                %wait until released
                update_scrn_press = penaltyRapid(scrn, dev, tgt, ptbimg,...
                                                 update_scrn_press, ii, CCCOMBO);
                % try 3
                while isnan(new_press(3,1))
                    [new_press(3,:), update_scrn_press] = checkTempResp(dev,...
                                                                        update_scrn_press);
                    WaitSecs(0.01);
                end

                if new_press(3,1) ~= tgt.finger(ii)
                    % wrong, wrong, wrong.
                    update_scrn_press = penaltyRapid(scrn, dev, tgt, ptbimg,...
                                                     update_scrn_press, ii, CCCOMBO);
                end
            end
        else
            % hooray!
            PsychPortAudio('Start', ifelse(CCCOMBO + 1 > 7, 7, CCCOMBO + 1),1,0,1);
            CCCOMBO = CCCOMBO + 1;
        end
        % cleanup pt.1
        Priority(0);
        new_press(:,2) = new_press(:,2) - t_img;
        clearDev(dev);
        stopDev(dev);
        if any(~isnan(new_press(:,1)))
            drawCCCOMBO(scrn, CCCOMBO);
            Screen('DrawTexture', scrn.window, ptbimg(tgt.finger(ii)));
            rect_locs = mkBoxes(scrn, dev.valid_indices);
            mkPressBoxes(scrn, update_scrn_press, rect_locs, scrn.green);
            Screen('Flip', scrn.window);
        end
        WaitSecs(.3); % show feedback for long enough

        new_press

        stopDev(dev);
        PsychPortAudio('Close');
        rmDev(dev);
        Priority(0);
        sca;
        err = 0;
    catch ME
        err = 1;
        sca;
        Priority(0);
        PsychPortAudio('Close');
        warning('test failed!');
        rethrow(ME);
    end
end
