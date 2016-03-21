function ptbim = mkPtbImg(rawim, scrn)
    % inputs: rawim (from mkRawImg)
    %         scrn (from mkScreen)
    %
    % outputs: ptbim; call via:
    %          Screen('DrawTexture', scrn.window, ptbim(tgt.img(trialnum)));

    for ii = 1:length(rawim)
        % rescale the image as a function of screen size
        tempimg = imresize(rawim{ii}, [scrn.IMG_RATIO*scrn.size(3) NaN]);
        if ~scrn.REVERSE_COLOURS
            tempimg = imcomplement(tempimg);
        end
        ptbim(ii) = Screen('MakeTexture', scrn.window, tempimg);
    end

end
