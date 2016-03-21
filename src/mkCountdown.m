function zero_volts = mkCountdown(scrn, dev, c_m)
% inputs: scrn (from mkScreen), dev (from mkRespDev), and c_m (constants for
%         miscellaneous things, from mkConstants)
% outputs: empty ([]) if keyboard, 1xn of corrected baseline if transducers
	when = GetSecs + (1:c_m.LEN_CNTDWN);

    if ~strcmpi(dev.type, 'keyboard')
        stop(dev.device);
        start(dev.device);
    end

	for current = 1:c_m.LEN_CNTDWN
		if ~strcmpi(dev.type, 'keyboard')
			if LEN_CNTDWN - current == c_m.START_ZERO
				trigger(dev.device);

			elseif c_m.LEN_CNTDWN - current == c_m.START_ZERO - c_m.LEN_ZERO
				stop(dev.device);
				n_samples = get(dev.device, 'SamplesAvailable');
				[zero_data, zero_time] = getdata(dev.device, n_samples);
				zero_volts = mean(zero_data, 1);
			end
		else % Return empty array, likely non-DAQ input
			zero_volts = [];
		end

		DrawFormattedText(scrn.window, strcat('Experiment starting in t-', ...
		num2str(c_m.LEN_CNTDWN - current),' seconds. \n\nIf force transducers', ...
		' are being used,\n\nzeroing is also being done now.\n\nKeep your fingers',...
		' resting on the keys.'), 'center', 'center', scrn.txtcol);
		Screen('Flip', scrn.window, when(current));
	end

end
