
function err = testDev(kybrd);
% test that we can make a response device and destroy it
    try
        addpath src
        addpath misc/mfiles
        [resp_consts] = mkConstants;
        tgt = mapRapid(dlmread(['misc/tfiles/','testBehav_rapid','.tgt']));
        dev = mkRespDev(kybrd, unique(tgt.finger), resp_consts);
        rmDev(dev);
        err = 0;
    catch ME
        err = 1;
        sca;
        warning('test failed!');
        rethrow(ME);
    end
end
