dat_tr <- importTR()
dat_tr <- dat_tr[dat_tr$id == 200,]
tr_remaps <- dat_tr[dat_tr$swapped == 1,] # remapped trials
tr_remaps_new <- tr_remaps[tr_remaps$finger %% 2 == 1,] 
tr_remaps_old <- tr_remaps[tr_remaps$finger %% 2 == 0,]
tr_remaps_new$went_old <- ifelse(abs(tr_remaps_new$resp1 - tr_remaps_new$finger) == 2, 1, 0)

aa <- timeSlide(tr_remaps_new$t_prep, tr_remaps_new$went_old, step_size = 0.005)
aa$type <- 'New Map, Went To Old Mapping'
bb <- timeSlide(tr_remaps_new$t_prep, tr_remaps_new$correct, step_size = 0.005)
bb$type <- 'New Map, Correct'
cc <- timeSlide(tr_remaps_old$t_prep, tr_remaps_old$correct, step_size = 0.005)
cc$type <- 'Old Map, Correct'

new_dat <- rbind(aa, bb, cc)

gg_color_hue <- function(n) {
  hues = seq(15, 375, length=n+1)
  hcl(h=hues, l=65, c=100)[1:n]
}

new_cols <- gg_color_hue(3)
ggplot(new_dat, aes(x = t_prep, y = correct, colour = factor(type))) + 
  geom_line(size = 1) +
  geom_point(data = tr_remaps_new, aes(x = t_prep, y = -0.025), 
             colour = new_cols[1], shape = '|', size = 3) +
  geom_point(data = tr_remaps_old, aes(x = t_prep, y = -0.07), 
             colour = new_cols[3], shape = '|', size = 3) +
  scale_x_continuous(breaks = seq(0, .6, .1), limits = c(0, 1.2)) +
  xlab('Preparation Time (seconds)') +
  ylab('P(Correct|Prep Time) (red and blue)\n
       P(Old Map|Prep Time) (green)') +
  guides(colour = guide_legend(title = 'Condition')) +
  ggtitle('Old Habits Die Hard (At Low Preparation Time)') +
  theme_bw()
