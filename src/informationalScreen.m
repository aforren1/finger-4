function informationalScreen(scrn, cond, valid_keys)
% display task and requested keys
    cond = ifelse(strcmpi(cond, 'tr'), 'Timed Response', 'Rapid-fire Training');
    stat1 = ['This block is a ', cond, ' block.'];
    if iscell(valid_keys)
        stat2 = strtrim(sprintf('%s ', valid_keys{:}));
        stat2 = ['You will be using the following keys: \n \n', stat2];
    else % using force transducers
        stat2 = '';
    end
    Screen('FillRect', scrn.window, scrn.colour); % 'wipe' screen
    DrawFormattedText(scrn.window, [stat1, '\n', stat2],...
                      'center','center', scrn.txtcol);
    Screen('Flip', scrn.window);
    WaitSecs(5);
end
