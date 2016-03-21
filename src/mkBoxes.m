function rect_locs = mkBoxes(scrn, fingers)
    % rect_locs gives us where we can put feedback later on; this'll decouple
    % the regular old rectangles and feedback
    outline = scrn.txtcol;
    n_finger = length(fingers);

    spacing = linspace(.2, .8, n_finger);
    rect_area = (spacing(2) - spacing(1))/1.5;
    xscrn = scrn.size(3);
    yscrn = scrn.size(4);

    base_rect = rect_area * [0 0 xscrn xscrn];
    xrectpos = spacing * xscrn;
    yrectpos = 0.8 * yscrn * ones(1, length(spacing));

    rect_locs = nan(4, n_finger);
    for pp = 1:length(yrectpos)
        rect_locs(:,pp) = CenterRectOnPointd(base_rect,...
        xrectpos(pp), yrectpos(pp));
    end
    Screen('FrameRect', scrn.window, outline, rect_locs);

end
