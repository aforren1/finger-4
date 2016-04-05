
function mkTRTgt(day, block, easy, swapped, img_type, reps)
 % day is the day (integer)
 % block is the block number (int)
 % easy is whether the time is easy (500 ms fixed img presentation) or not
 % swapped is 1x2 vector of the swapped image indices (or 0 if no swap)
 % img_type is 0 (hands) or 1 (shapes)
 % reps is the number of repetitions for entire array
 % out_path is the output path
 % filename is determined by args, eg. 'dy1_bk1_ez1_sw0_sh1.tgt' would be
 % 'day 1, block 1, easy, no swaps, shapes'.
out_path = '~/Documents/BLAM/finger-4/misc/tfiles/'; % change for your comp!
seed = day * block; % avoid explicit patterns in seeding
%rng(seed);
rand('seed', seed);
ind_finger = [7 8 9 10];
times = [.4:.05:.8];
% generate all combinations of times and images
[a1, a2] = meshgrid(ind_finger, times);
combos = repmat([a1(:) a2(:)], reps, 1); % 36 * reps trials
combos = combos(randperm(size(combos, 1)), :);
combo_size = size(combos, 1);
if easy
    combos(:, 2) = 0.5; % show image at approx. the first beep
end
if any(swapped > 0) % if not zero
    combos(:, 3) = swapped(1);
    combos(:, 4) = swapped(2);
    swapped2 = 1;
else
    combos(:, 3:4) = 0;
    swapped2 = 0;
end

% day, block, trial, easy, swapped, img_type, tgt finger,
% time, swap1, swap2
final_output = [repmat(day, combo_size, 1) ...
               repmat(block, combo_size, 1) ...
               (1:combo_size)' ... % trials
               repmat(easy, combo_size, 1) ...
               repmat(swapped2, combo_size, 1) ...
               repmat(img_type, combo_size, 1) combos];

file_name = ['dy',num2str(day), '_bk', num2str(block), '_ez', num2str(easy),...
             '_sw', num2str(swapped2), '_sh', num2str(img_type), '.tgt'];

dlmwrite([out_path, file_name], final_output, '\t');
end
