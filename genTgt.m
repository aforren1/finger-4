% day 1
addpath src
% unambiguous symbols
mkRapidTgt(1, 1, 0, 0, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(1, 2, 0, 0, 25);
mkTRTgt(1, 3, 0, 0, 0, 3); % (day, block, easy, swapped, img_type, reps)
mkTRTgt(1, 4, 0, 0, 0, 3);
mkTRTgt(1, 5, 0, 0, 0, 3);

% ambiguous symbols
mkRapidTgt(1, 6, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(1, 7, 0, 1, 25);
mkTRTgt(1, 8, 0, 0, 1, 3); % (day, block, easy, swapped, img_type, reps)
mkTRTgt(1, 9, 0, 0, 1, 3);
mkTRTgt(1, 10, 0, 0, 1, 3);


% day 2
mkRapidTgt(2, 1, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(2, 2, 0, 1, 25);
mkRapidTgt(2, 3, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(2, 4, 0, 1, 25);
mkRapidTgt(2, 5, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(2, 6, 0, 1, 25);
mkRapidTgt(2, 7, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(2, 8, 0, 1, 25);
mkRapidTgt(2, 9, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(2, 10, 0, 1, 25);

% day 3
mkRapidTgt(3, 1, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(3, 2, 0, 1, 25);
mkRapidTgt(3, 3, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(3, 4, 0, 1, 25);
mkRapidTgt(3, 5, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(3, 6, 0, 1, 25);
mkRapidTgt(3, 7, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(3, 8, 0, 1, 25);
mkRapidTgt(3, 9, 0, 1, 25); % (day, block, swapped, img_type, reps)
mkRapidTgt(3, 10, 0, 1, 25);

% day 4 (n - 1)
mkRapidTgt(4, 1, 0, 1, 25); % warmup symbols
mkRapidTgt(4, 2, 0, 1, 25);
mkTRTgt(4, 3, 0, 0, 1, 3); % symbols
mkTRTgt(4, 4, 0, 0, 1, 3);
mkTRTgt(4, 5, 0, 0, 1, 3);

mkRapidTgt(4, 6, 0, 0, 25); % warmup hands
mkRapidTgt(4, 7, 0, 0, 25);
mkTRTgt(4, 8, 0, 0, 0, 3); % hands
mkTRTgt(4, 9, 0, 0, 0, 3);
mkTRTgt(4, 10, 0, 0, 0, 3);

% day 5 (n) (swap!)
% ambiguous symbols
mkRapidTgt(5, 1, [7 9], 1, 25); % (day, block, swapped, img_type, reps)
mkTRTgt(5, 2, 0, [7 9], 1, 3); % (day, block, easy, swapped, img_type, reps)
mkTRTgt(5, 3, 0, [7 9], 1, 3);
mkTRTgt(5, 4, 0, [7 9], 1, 3);

mkRapidTgt(5, 5, 0, 0, 25); % warmup hands
mkTRTgt(5, 6, 0, 0, 0, 3); % hands
mkTRTgt(5, 7, 0, 0, 0, 3);
mkTRTgt(5, 8, 0, 0, 0, 3);
