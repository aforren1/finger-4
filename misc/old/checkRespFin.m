function [pressedkey, t_press, traces] = checkRespFin(dev, pressed)
% DEPRECATED (note to self). Handling if there was a press or not is easier
% outside
% resp = CHECKRESPFIN(dev, resp) is called once per trial, and is used
% to clean up the temporary response checks and fill in any blanks
% pass in vector of responses to see if any have been pressed
% exclude traces output for keyboard presses

    if strcmpi(dev.type, 'keyboard')
        if ~pressed % for keyboard presses, maybe makes sense to handle this
                    % for each particular case outside the function. Below
                    % makes sense for the timed response, but not as a
                    % general purpose cleanup. It's easier to check
                    % `if isnan(pressedkey) & strcmpi(dev.device, 'keyboard')`
                    % then handle the outputs appropriately in the case that
                    % there *are* existing responses
            pressedkey = NaN;
            t_press = NaN;
            traces = NaN;
        else
            %TODO: when should there be post-hoc cleanup in the keyboard?
        end

    else % doing this step makes sense for the
        if ~pressed
            pressed = false;
            pressedkey = NaN;
            t_press = NaN;
        end
        n_samples = get(dev.device, 'SamplesAvailable');
        if (n_samples > 0)
            [traces, timestamp] = getdata(dev.device, n_samples);
            for d = 1:length(dev.scaleV2N)
                traces(:, d) = ...
                    (traces(:, d) - dev.zero_volts(d)).*dev.scaleV2N(d);
            end
        else
            error('Bad reading from board!')
        end

    end


end
