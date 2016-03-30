
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
  
  final_dat[final_dat == -1] <- NA
  final_dat[final_dat == 'NaN'] <- NA
  nas <- apply(final_dat, 1, function(z) sum(is.na(z)))
  final_dat$correct <- final_dat$resp1 == final_dat$finger
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
  
  final_dat[final_dat == -1] <- NA
  final_dat[final_dat == 'NaN'] <- NA
  nas <- apply(final_dat, 1, function(z) sum(is.na(z)))
  final_dat$correct <- final_dat$resp1 == final_dat$finger
  final_dat$t_prep <- final_dat$t_resp1 - final_dat$t_img
  final_dat$n_tries <- ifelse(nas == 6, 0, ifelse(nas == 4, 1, ifelse(nas == 2, 2, 3)))
  final_dat
  
}

# plot timed response
library(ggplot2)
library(psyphy)
dat <- importTR()
ggplot(dat[dat$id == 200,], aes(t_prep, ifelse(correct, 1, 0))) + 
  geom_jitter(height = 0.2, alpha = .6) + 
  xlim(c(0,.6)) + 
  geom_smooth(method = 'glm', 
              method.args = list(family = binomial(mafc.probit(4))), se = FALSE) + 
  facet_wrap(~img_type + day)
# plot training
dat2 <- importRapid()
ggplot(dat2, aes(trial, t_resp1, colour = correct)) + 
  geom_point(alpha = 0.6) + 
  facet_wrap(~img_type + id + day)
