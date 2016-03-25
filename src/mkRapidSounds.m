function snd = mkRapidSounds
% inputs: none
% outputs: snd, a 1xn vector of sound handles
% All sounds *should* have a Fs of 44100Hz
    InitializePsychSound(1);
    try PsychPortAudio('Close')
    catch
        warning('No active audio device')
    end

    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    basedir = 'misc/sounds/';
    if isOctave
        readsound = @wavread;
    else
        readsound = @audioread;
    end
    [right{1}, Fs] = readsound([basedir, 'beep.wav']);
    [right{2}, Fs] = readsound([basedir, 'orch1.wav']);
    [right{3}, Fs] = readsound([basedir, 'orch2.wav']);
    [right{4}, Fs] = readsound([basedir, 'orch3.wav']);
    [right{5}, Fs] = readsound([basedir, 'orch4.wav']);
    [right{6}, Fs] = readsound([basedir, 'orch5.wav']);
    [right{7}, Fs] = readsound([basedir, 'orch6.wav']);
    [right{8}, Fs] = readsound([basedir, 'orch7.wav']);
    [right{9}, Fs] = readsound([basedir, 'orch8.wav']);

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
