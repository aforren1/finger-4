## Timed response and rapid-fire training

To download, install git and change to the desired installation directory. Then type
```
git clone https://github.com/aforren1/finger-4
```

This will create a directory called "finger-4". This can be updated to the most recent software via
```
git pull
```
When you are located in the "finger-4" directory.


To start an experiment, open MATLAB or Octave and change your directory (via `cd` or the menu) to the
top-level "finger-4" directory. Then, type `Experiment;`to start the experiment. The program will prompt you for an id (any integer, as long as you keep it consistent), the day (probably 1-5), and the block number (probably 1-10). From there, the program will pick the appropriate block.

`.tgt` files for the timed response follow the pattern:

> dyX_bkX_ezX_swX_shX.tgt

Where `dyX` stands for the day and number, `bkX` stands for the block and
number, `ezX` is whether the block is easy (1) or not (0), `swX` is whether
there are any swapped indices in the trial (1 or 0), and `shX` is whether
hands (0) or shapes (1) are shown.

The naming convention is the same for training blocks, except there is no `ez`
condition (all are hard!). For example, a valid `.tgt` file for a timed response
block would be

> dy1_bk3_ez0_sw0_sh1

and a valid training one would be

> dy1_bk3_sw0_sh1

The data file will be automatically saved to the `/data` directory. Keep an eye on the data directory to make sure that you don't do one twice!
