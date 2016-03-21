function startDev(dev)

    if strcmpi(dev.type, 'keyboard')
        KbQueueStart;
    else
        stop(dev.device);
        start(dev.device);
        trigger(dev.device);
    end

end
