function output = trialTR(scrn, tgt, ptbimg, dev, ii)

    Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
    mkBoxes(scrn, dev.valid_indices);
    t_ref = Screen('Flip', scrn.window);


    % think about this
    Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
    mkBoxes(scrn, dev.valid_indices);
    Priority(scrn.priority);
    PsychPortAudio('Start', 1, 1, t_ref + scrn.ifi, 0); % 1 is beep train

    t_ref = Screen('Flip', scrn.window, t_ref + 0.5*scrn.ifi);
    startDev(dev);
    t_bp4 = t_ref + 0.5 + 1.5; % 0.5 for aud delay, 1.5 for actual train dur
    img_frame = round((0.5 + tgt.t_img(ii))/ifi);
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


end
