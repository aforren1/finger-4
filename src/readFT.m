function [traces, timestamp] = readFT(dev)

n_samples = get(dev.device, 'SamplesAvailable');
if (n_samples > 0)
    [traces, timestamp] = getdata(dev.device, n_samples);
    for d = 1:length(dev.scaleV2N)
        traces(:,d) = (traces(:,d) - dev.zero_volts(d)).*dev.volts_2_newts(d);
    end
else
    error('Bad reading from board!')
end

end
