
function err = testTrialPt1(kybrd)
% globals, other variables

    try
        addpath src
        snd = mkRapidSounds;
        CCCOMBO = 10;
        ii = 1;
        [resp_consts, scrn_consts, misc_consts] = mkConstants;
        tgt = mapRapid(dlmread(['misc/tfiles/','dy3_bk4_ez0_sw1_sh1.tgt']));
        tgt.id = 55;
        fingers = unique(tgt.finger);
        dev = mkRespDev(kybrd, fingers, resp_consts);
        scrn = mkScreen(true, true, scrn_consts); % small, skip tests
        rawimg = mkRawImg(1); %shapes
        ptbimg = mkPtbImg(rawimg, scrn);

        Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
        mkBoxes(scrn, dev.valid_indices);
        drawCCCOMBO(scrn, CCCOMBO);
        vbl = Screen('Flip', scrn.window);

        Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
        mkBoxes(scrn, dev.valid_indices);
        drawCCCOMBO(scrn, CCCOMBO);
        Priority(scrn.priority);
        Screen('DrawTexture', scrn.window, ptbimg(tgt.finger(ii)));

        PsychPortAudio('Start', 1, 1, vbl + scrn.ifi, 0); % start audio at flip
        t_img = Screen('Flip', scrn.window, vbl + 0.5*scrn.ifi);
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

        % coerce into frame
        if strcmpi(dev.type, 'keyboard')
            % 9 from tgt file, 9 from presses, id
            output = nan(1,16);
        elseif strcmpi(dev.type, 'force')
            [traces, timestamp] = readFT(dev);
            output = nan(length(timestamp), 16 + size(traces, 2));
        end

        output(:,1) = tgt.id;
        output(:,2) = tgt.day(ii);
        output(:,3) = tgt.block(ii);
        output(:,4) = tgt.trial(ii);
        output(:,5) = tgt.easy(ii);
        output(:,6) = tgt.swapped(ii);
        output(:,7) = tgt.img_type(ii);
        output(:,8) = tgt.finger(ii);
        output(:,9) = tgt.swap1(ii);
        output(:,10) = tgt.swap2(ii);
        output(:,11:12) = new_press(1,:); % convert nan to -1 for csv
        output(:,13:14) = ifelse(isnan(new_press(2,1)), -1, new_press(2,:));
        output(:,15:16) = ifelse(isnan(new_press(3,1)), -1, new_press(3,:));

        if strcmpi(dev.type, 'force')
            output(:, 17) = timestamp;
            output(:, 18:size(traces, 2)) = traces;
        end
output

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
