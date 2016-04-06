
function err = testRapidSounds
% globals, other variables

    try
        addpath src
        addpath misc/mfiles
        snd = mkTRSounds;
        for ii = 1:length(snd)
            t0 = GetSecs;
            t1 = PsychPortAudio('Start', snd(ii), 1, 0, 1); % reps, when, waitforstart
            t1 - t0 % t1 returns the est. of when the sound actually got to the speakers
            WaitSecs(.5);
        end
        PsychPortAudio('Close');
        err = 0;
    catch ME
        err = 1;
        sca;
        try PsychPortAudio('Close'); catch warning('No active audio device') end
        warning('test failed!');
        rethrow(ME);
    end
end
