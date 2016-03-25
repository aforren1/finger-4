function output = trialTR(scrn, tgt, ptbimg, dev, ii)

    Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
    rect_locs = mkBoxes(scrn, dev.valid_indices);
    t_ref = Screen('Flip', scrn.window);
    update_scrn_press = zeros(1, length(dev.valid_indices));

    % think about this
    Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
    mkBoxes(scrn, dev.valid_indices);
    Priority(scrn.priority);
    PsychPortAudio('Start', 1, 1, t_ref + scrn.ifi, 0); % 1 is beep train

    t_ref = Screen('Flip', scrn.window, t_ref + 0.5*scrn.ifi);
    t_ref_copy = t_ref; % t_ref_copy is the time the audio comes on
    startDev(dev);
    img_frame = round((0.5 + tgt.t_img(ii))/scrn.ifi);
    n_frames = round(2.4/scrn.ifi);
    new_press = nan(3,2);
    press_count = 1;

    for frame = 1:n_frames
        Screen('FillRect', scrn.window, scrn.colour);
        mkBoxes(scrn, dev.valid_indices);

        if frame >= img_frame
            Screen('DrawTexture', scrn.window, ptbimg(tgt.finger(ii)));
        end

        [temp_press, update_scrn_press] = checkTempResp(dev, update_scrn_press);
        if ~isnan(temp_press(1)) && press_count < 4
            new_press(press_count, :) = temp_press;
            if press_count == 1
                first_scrn_press = update_scrn_press;
            end
            press_count = press_count + 1;
        end
        mkPressBoxes(scrn, update_scrn_press, rect_locs, scrn.gray);

        Screen('DrawingFinished', scrn.window);
        t_ref = Screen('Flip', scrn.window, t_ref + 0.5 * scrn.ifi);
    end

    Priority(0);

    new_press(:,2) = new_press(:,2) - t_ref_copy; % should be around 2 for correct
    stopDev(dev);
    clearDev(dev);
    Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
    t_diff = new_press(1, 2) - 2;
    if isnan(t_diff) || t_diff > dev.PRESS_TOL
        tempstr = 'Too late!';
        tct = 0;
    elseif t_diff < -dev.PRESS_TOL
        tempstr = 'Too early!';
        tct = 0;
    else
        tempstr = 'Good timing!';
        tct = 1;
    end

    if new_press(1,1) ~= tgt.finger(ii)
        tempstr2 = ' Wrong button!';
        tempcol = scrn.red;
        mkPressBoxes(scrn, dev.valid_indices' == tgt.finger(ii),...
                     rect_locs, scrn.blue)
    else
        tempstr2 = ' Right button!';
        tempcol = scrn.green;
        tct = tct + 1;
    end

    rect_locs = mkBoxes(scrn, dev.valid_indices);
    Screen('DrawTexture', scrn.window, ptbimg(tgt.finger(ii)));
    mkPressBoxes(scrn, first_scrn_press, rect_locs, tempcol);
    DrawFormattedText(scrn.window, [tempstr, tempstr2], 'center',...
                  scrn.TXT_RATIO*scrn.size(4), scrn.txtcol);
    Screen('Flip', scrn.window);
    if tct > 1
        PsychPortAudio('Start', 2, 1, t_ref + scrn.ifi, 0); % 1 is beep train
    end

    WaitSecs(.4);

    %coerce into frame
    if strcmpi(dev.type, 'keyboard')
        % 9 from tgt file, 9 from presses, id
        output = nan(1,17);
    elseif strcmpi(dev.type, 'force')
        [traces, timestamp] = readFT(dev);
        output = nan(length(timestamp), 19 + size(traces, 2));
    end
    output(:,1) = tgt.id;
    output(:,2) = tgt.day(ii);
    output(:,3) = tgt.block(ii);
    output(:,4) = tgt.trial(ii);
    output(:,5) = tgt.easy(ii);
    output(:,6) = tgt.swapped(ii);
    output(:,7) = tgt.img_type(ii);
    output(:,8) = tgt.finger(ii);
    output(:,9) = tgt.t_img(ii);
    output(:,10) = tgt.swap1(ii);
    output(:,11) = tgt.swap2(ii);
    output(:,12:13) = new_press(1,:); % convert nan to -1 for csv
    output(:,14:15) = ifelse(isnan(new_press(2,1)), -1, new_press(2,:));
    output(:,16:17) = ifelse(isnan(new_press(3,1)), -1, new_press(3,:));

    if strcmpi(dev.type, 'force')
        output(:, 18) = timestamp;
        output(:, 19:size(traces, 2)) = traces;
    end

end
