function snd = mkRapidSounds
% inputs: none
% outputs: snd, a 1xn vector of sound handles
% All sounds *should* have a Fs of 44100Hz
    try PsychPortAudio('Close'); catch warning('No active audio device') end

    basedir = 'misc/sounds/';
    [right{1}, Fs] = wavread([basedir, 'beep.wav']);
    [right{2}, Fs] = wavread([basedir, 'orch1.wav']);
    [right{3}, Fs] = wavread([basedir, 'orch2.wav']);
    [right{4}, Fs] = wavread([basedir, 'orch3.wav']);
    [right{5}, Fs] = wavread([basedir, 'orch4.wav']);
    [right{6}, Fs] = wavread([basedir, 'orch5.wav']);
    [right{7}, Fs] = wavread([basedir, 'orch6.wav']);

    InitializePsychSound(1);
    pamaster = PsychPortAudio('Open', [], 9, 1, Fs, 2, []);
    PsychPortAudio('Start', pamaster, 0, 0, 1);
    %PsychPortAudio('Volume', pamaster, 0.5);
    snd = zeros(1, length(right));
    for ii = 1:length(right)
        snd(ii) = PsychPortAudio('OpenSlave', pamaster, 1);
        temp = right{ii}';
        if ii == 1
            PsychPortAudio('CreateBuffer', snd(ii), [temp; temp]);
            PsychPortAudio('FillBuffer', snd(ii), [temp; temp]);
        else
            PsychPortAudio('CreateBuffer', snd(ii), temp);
            PsychPortAudio('FillBuffer', snd(ii), temp);
        end
    end
end
