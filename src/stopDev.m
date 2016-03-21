function stopDev(dev)
    if strcmpi(dev.type, 'keyboard')
        KbQueueStop;
    else
        stop(dev.device);
    end
end
