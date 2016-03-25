function snd = mkTRSounds
% inputs: none
% outputs: snd, a 1xn vector of sound handles
% All sounds *should* have a Fs of 44100Hz

    InitializePsychSound(1);
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    basedir = 'misc/sounds/';
    if isOctave
        readsound = @wavread;
    else
        readsound = @audioread;
    end
    [right{1}, Fs] = readsound([basedir, 'beepTrain.wav']);
    [right{2}, Fs] = readsound([basedir, 'smw_coin.wav']);

    pamaster = PsychPortAudio('Open', [], 9, 1, Fs, 2, []);
    PsychPortAudio('Start', pamaster, 0, 0, 1);
    snd = zeros(1, length(right));
    for ii = 1:length(right)
        snd(ii) = PsychPortAudio('OpenSlave', pamaster, 1);
        temp = right{ii}';
        PsychPortAudio('CreateBuffer', snd(ii), [temp; temp]);
        PsychPortAudio('FillBuffer', snd(ii), [temp; temp]);
    end
end
