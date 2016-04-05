
importRapid <- function() {
  base_dir <- '/home/aforrence/Documents/BLAM/finger-4/data'
  all_files <- list.files(path = base_dir, full.names = TRUE)
  tr <- list.files(path = base_dir, pattern = 'ez', full.names = TRUE)
  rapid <- all_files[!all_files %in% tr] 
  ii <- 1
  for (file in rapid) {
    if (ii == 1) {
      final_dat <- read.table(file, header = FALSE, sep = ',')
    } else {
        temp_dat <- read.table(file, header = FALSE, sep = ',')
        final_dat <- rbind(final_dat, temp_dat)
        rm(temp_dat)
    }
    ii = ii + 1
  }
  names(final_dat) <- c('id', 'day', 'block', 'trial', 
                        'swapped', 'img_type', 'finger',
                        'swap1', 'swap2', 'resp1', 't_resp1',
                        'resp2', 't_resp2', 'resp3', 't_resp3')
  final_dat$day <- factor(final_dat$day)
  final_dat$swapped <- factor(final_dat$swapped)
  final_dat$img_type <- factor(final_dat$img_type)
  final_dat$finger <- factor(final_dat$finger)
  final_dat[final_dat == -1] <- NA
  final_dat[final_dat == 'NaN'] <- NA
  nas <- apply(final_dat, 1, function(z) sum(is.na(z)))
  final_dat$correct <- ifelse(final_dat$resp1 == final_dat$finger, 1, 0)
  final_dat$n_tries <- ifelse(nas == 6, 0, ifelse(nas == 4, 1, ifelse(nas == 2, 2, 3)))

  final_dat
}


importTR <- function() {
  base_dir <- '/home/aforrence/Documents/BLAM/finger-4/data'
  tr <- list.files(path = base_dir, pattern = 'ez', full.names = TRUE)
  ii <- 1
  for (file in tr) {
    if (ii == 1) {
      final_dat <- read.table(file, header = FALSE, sep = ',')
    } else {
      temp_dat <- read.table(file, header = FALSE, sep = ',')
      final_dat <- rbind(final_dat, temp_dat)
      rm(temp_dat)
    }
    ii = ii + 1
  }
  names(final_dat) <- c('id', 'day', 'block', 'trial', 'easy',
                        'swapped', 'img_type', 'finger', 't_img',
                        'swap1', 'swap2', 'resp1', 't_resp1', 
                        'resp2', 't_resp2', 'resp3', 't_resp3')
  final_dat$day <- factor(final_dat$day)
  final_dat$swapped <- factor(final_dat$swapped)
  final_dat$img_type <- factor(final_dat$img_type)
  final_dat$finger <- factor(final_dat$finger)
  final_dat$resp1[which(final_dat$resp1 > 10)] <- NA # purge troublesome ones now
  final_dat[final_dat == -1] <- NA
  final_dat[final_dat == 'NaN'] <- NA
  final_dat$resp1 <- factor(final_dat$resp1)
  nas <- apply(final_dat, 1, function(z) sum(is.na(z)))
  final_dat$correct <- ifelse(final_dat$resp1 == final_dat$finger, 1, 0)
  final_dat$t_prep <- final_dat$t_resp1 - final_dat$t_img
  final_dat$n_tries <- ifelse(nas == 6, 0, ifelse(nas == 4, 1, ifelse(nas == 2, 2, 3)))
  final_dat
  
}


timeSlide <- function(x, y, step_size = 0.005, window_size = 0.05) {
  
  time_grid <- seq(min(x, na.rm =TRUE), max(x, na.rm = TRUE), by = step_size)
  out_grid <- matrix(nrow = length(time_grid), ncol = 3)
  
  for (ii in 1:length(time_grid)) {
    ref_time <- time_grid[ii]
    low_time <- ref_time - (window_size/2)
    high_time <- ref_time + (window_size/2)
    valid_times <- ifelse(x > low_time & x < high_time, TRUE, FALSE)
    out_grid[ii, 1] <- ref_time
    out_grid[ii, 2] <- mean(x[valid_times], na.rm = TRUE)
    out_grid[ii, 3] <- mean(y[valid_times], na.rm = TRUE)
  }
  out_grid
}
