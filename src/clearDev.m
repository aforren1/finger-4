function clearDev(dev)
    if strcmpi(dev.type, 'keyboard')
        KbQueueFlush;
    else
        %???
    end
end
