function rmDev(dev)
% cleans up response device-specific things
% inputs: dev
% outputs: none
    if strcmpi(dev.type, 'keyboard')
        KbQueueRelease;
    elseif strcmpi(dev.type, 'force')
        release(dev.device); % check later
    else
        warning('No supported device to clean up!')
    end
    dev = [];
end
