function [new_press, update_scrn_press] = checkTempResp(dev, update_scrn_press)
% inputs: dev is is the output of mkRespDev()
%         update_scrn_press is a 1xn matrix, and represents the pattern of
%                           presses from the previous check, eg.
%                           [0 0 1 0 0] for the keyboard and
%                           [.02 0.1 1.3 -0.1 0] for the force transducers.
%                           These are used to update the screen display, with
%                           the box size scaling as a function of the values
%
% outputs: new_press is the occurrence of a new press (where n-1 was low and
%                    n is high), with the index of the value and the timestamp.
%                    Multiple 'new' presses are handled outside of this function.
%          update_scrn_press is a 1xn matrix as above, and represents this
%                            current block. This gets passed back around in
%                            subsequent checks.

new_press = []; % return anything substantial when no press, or NaN?
previous_press = update_scrn_press; % get indices with find(previous_press >= 1)
    if strcmpi(dev.type, 'keyboard')
        [pres, firstpress, firstrelease] = KbQueueCheck;
        if any(firstpress > 0) % any new presses
            press_key = KbName(find(firstpress > 0));
            if iscell(press_key) % make sure matlab also puts it in cell array
                press_key = cell2mat(press_key);
            end
            new_events = ismember(dev.valid_keys, press_key); % gives [0 0 0 1 0], eg.
            update_scrn_press = update_scrn_press + new_events;
            press_key = find(ismember(dev.valid_keys, press_key));
            t_press = min(firstpress(firstpress > 0));
            new_press = [dev.valid_indices(press_key), t_press];
            KbQueueFlush; % Flush existing events
        else
            new_press = [NaN NaN];
        end
        if any(firstrelease > 0)
            release_key = KbName(find(firstrelease > 0));
            new_release = ismember(dev.valid_keys, release_key);
            update_scrn_press = update_scrn_press - new_release;
        end


    elseif strcmpi(dev.type, 'force')
        tempforce = [];
        while(isempty(tempforce))
            tempforce = getsample(dev.device);
        end
        t_press = GetSecs; % get time as soon as sample is collected
        % subtract rest, transform to newtons
        tempforce = (tempforce-dev.zero_volts).*dev.volt_2_newts;
        tempforce(tempforce < 0) = 0; % set force floor
        % scale and put a ceiling on the display boxes
        update_scrn_press = tempforce/dev.FORCE_MIN;
        update_scrn_press(update_scrn_press > 1) = 1;
        update_scrn_press(update_scrn_press < 0) = 0;

        temp_new = ifelse(update_scrn_press >= 1, 1, 0);
        temp_old = ifelse(previous_press >= 1, 1, 0);
        temp_delt = temp_new - temp_old; % -1 is release, +1 is press
        if (any(temp_delt >= 1))
            press_key = find(temp_delt >= 1); % what if > 1?
            new_press = [press_key, t_press];
        else
            new_press = [NaN NaN];
        end
    else
        error('Unsupported device!');
    end

end
