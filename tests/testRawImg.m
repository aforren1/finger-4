function err = testRawImg
    try
        addpath src

        rawim = mkRawImg(1); %shapes
        rawim2 = mkRawImg(0); % hands


        figure(1);
        imshow(rawim{3});
        figure(2);
        imshow(rawim2{3});
        figure(3);
        imshow(rawim{6});
        figure(4);
        imshow(rawim2{6});
        err = 0;
    catch ME
        err = 1;
        sca;
        warning('test failed!');
        warning(ME.stack);
        rethrow(ME);
    end
end
