function output = TimedResponse(ui)
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

        %% Put together resources
        %ui = mkUI;
        scrn = mkScreen(ui.size, ui.skip, c_scrn);
        tgt = mapTR(dlmread(['misc/tfiles/', ui.tgt]));
        tgt.id = ui.id;

        rawimg = mkRawImg(tgt.img_type(1));
        ptbimg = mkPtbImg(rawimg, scrn);
        if tgt.swapped % swap images
            ptbimg([tgt.swap2 tgt.swap1]) = ptbimg([tgt.swap1 tgt.swap2]);
        end

        dev = mkRespDev(ui.kybrd, unique(tgt.finger), c_resp);

        mkTRSounds;
        output = cell(1, max(tgt.trial));
        HideCursor;
        dev.zero_volts = mkCountdown(scrn, dev, c_misc);

        for ii = 1:length(tgt.trial)
            Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
            mkBoxes(scrn, dev.valid_indices);
            Screen('Flip', scrn.window);
            tempout{ii} = trialTR(scrn, tgt, ptbimg, dev, ii);
        end

        % format departing data
        output = cell2mat(tempout(1));
        for ii = 2:length(tempout) % convert output to 2d matrix
            output = [output; cell2mat(tempout(ii))];
        end

        % ugly writing of headers
        tfile2 = ui.tgt(1:end-4);
        filename = ['data/id', num2str(ui.id),'_', tfile2, '.csv'];
        headers = {'id', 'day', 'block', 'trial', 'easy', 'swapped', 'img_type',...
                   'finger', 't_img', 'swap1', 'swap2', 'press1', 't_press1', ...
                   'press2', 't_press2', 'press3', 't_press3'};
        if strcmpi(dev.type, 'force')
            % ugly ugly ugly hack, make sure to check the actual size!!!
            headers = [headers, {timestamp, 'f7', 'f8', 'f9', 'f10'}];
        end
        fid = fopen(filename, 'wt');
        csvFun = @(str)sprintf('%s, ',str);
        xchar = cellfun(csvFun, headers, 'UniformOutput', false);
        xchar = strcat(xchar{:});
        xchar = strcat(xchar(1:end-1), '\n');
        fprintf(fid, xchar);
        fclose(fid);

        dlmwrite(filename, output);

        % Wrap up residual things in the environment
        purge;
        Priority(0);

    catch ME
        purge;
            % other nice things to clean up before failing
        rethrow(ME);
    end
