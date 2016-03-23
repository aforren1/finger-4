function tgt_out = mapRapid(tgt)
    % give things names (throw into a struct)
    tgt_out.day = tgt(:, 1);
    tgt_out.block = tgt(:, 2);
    tgt_out.trial = tgt(:, 3);
    tgt_out.swapped = tgt(:, 4);
    tgt_out.img_type = tgt(:, 5);
    tgt_out.finger = tgt(:, 6);
    tgt_out.swap1 = tgt(:, 7);
    tgt_out.swap2 = tgt(:, 8);
end
