function err = testTemplate
% globals, other variables

    try
        % some code
        err = 0;
    catch ME
        err = 1;
        sca;
        warning('test failed!');
        rethrow(ME);
    end
end
