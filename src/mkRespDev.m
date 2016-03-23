function dev = mkRespDev(kybrd, valid_keys, resp_consts);
% inputs:
%
% kybrd is ui.kybrd (whether it uses a keyboard or not)
% valid_keys is unique(tgt.finger), or all possible keys pressed during block
% resp_consts are various constants used by the response device
%
% outputs:
%
% dev is a struct containing the following:
%    type: string (essentially subclass)
%    if keyboard,
%      valid_indices: unique(tgt.finger) (eg. [1,6,7,8])
%      valid_keys: actual key names (eg. {'a','h','u','i'})
%    if force transducers,
%      FORCE_MIN: minimum force to count as response
%      FORCE_MAX: max force to count as response
%      PRESS_TOL: acceptable distance of press from 4th beep
%      device: the DAQ object
%      zero_volts: A 1xn vector for storing the zeroing condition
%      volt_2_newts: conversion of DAQ voltage to newtons (1x10?)
%      valid_pos: a 1xn vector, n being the number of valid keys
%                 This is used to compare for correctness
% TODO: Accomodate key presses on windows

l_valid = length(valid_keys);

    if kybrd
        dev.type = 'keyboard';
        keys = zeros(1, 256);
        keys(KbName(resp_consts.ALL_KEYS(valid_keys))) = 1;
        KbQueueCreate(-1, keys);
        dev.valid_indices = valid_keys; % valid positions, rather than actual keys
        dev.valid_keys = resp_consts.ALL_KEYS(valid_keys);
        dev.FORCE_MIN = ones(1, l_valid); % if 1 (press), fill in whole thing
        dev.FORCE_MAX = dev.FORCE_MIN * 100; % for compatibility with transducers
        dev.PRESS_TOL = resp_consts.PRESS_TOL;

    else % Force transducers, only works on windows
        if ~ispc
            error('DAQ only works on Windows (barring new hardware)');
        end
        dev.type = 'force';
        dev.FORCE_MIN = resp_consts.FORCE_MIN * ones(1, l_valid);
        dev.FORCE_MAX = resp_consts.FORCE_MAX * ones(1, l_valid);
        dev.PRESS_TOL = resp_consts.PRESS_TOL;
        daqreset;
        daqs = daqhwinfo('nidaq');
        daqIDs = daqs.InstalledBoardIds;
        if length(daqIDs) >= 1
            daqID = daqIDs{1};
        else
            error('No NI-DAQ device available.');
        end

        dev.device = analoginput('nidaq', daqID);
        dev.device.inputType = 'SingleEnded';
        temp_pos = [0 8 1 9 2 10 3 11 4 12]; % setup for nidaq
        dev.valid_indices = temp_pos(valid_keys);
        addchannel(dev.device, dev.valid_indices);

        set(dev.device, 'SampleRate', 200);
        set(dev.device, 'SamplesPerTrigger', 4000);
        set(dev.device, 'TriggerType', 'Manual');
        set(dev.device, 'BufferingMode', 'Manual');
        set(dev.device, 'BufferingConfig', [2 2000]);

        dev.zero_volts = zeros(1, l_valid); % adjust in countdown

        calibration = load(fullfile('misc/calibfiles/cfB_2012_08_24_regress.mat'));
        dev.volt_2_newts = calibration.Volts2N(valid_keys);
    end

end
