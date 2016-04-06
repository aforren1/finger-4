function output = Experiment

    addpath('src');
    ui = mkUI;
    tfiles = dir(fullfile('misc/tfiles/', '*.tgt'));
    tfiles = {tfiles.name}';
    index = find(cellfun('length', ...
                 regexp(tfiles, ['dy', num2str(ui.day), '_bk', num2str(ui.block), '_'])) == 1);
    ui.tgt = tfiles{index};
    if strfind(ui.tgt, 'ez')
        output = TimedResponse(ui);
    else
        output = Rapid(ui);
    end
end
