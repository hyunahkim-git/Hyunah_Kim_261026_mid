sequencing <- data.frame(
  platform = c("Illumina", "Oxford Nanopore", "PacBio HiFi"),
  yield_Gb = c(18, 30, 12),
  host_fraction = c(0.20, 0.70, 0.10),
  cost_USD = c(150, 200, 300)
)
budget <- 600
view(sequencing)
sequencing$n_samples <- floor(budget / sequencing$cost_USD)
sequencing$microbial_Gb_per_sample <- sequencing$yield_Gb * (1 - sequencing$host_fraction)
sequencing$total_microbial_Gb <-sequencing$n_samples * sequencing$microbial_Gb_per_sample
