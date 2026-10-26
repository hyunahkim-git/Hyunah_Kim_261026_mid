score <- c(0.20, 0.60)
OR <- c(estimate = 0.47, lower = 0.22, upper = 0.97)
CASI <- c(estimate = -0.92, lower = -1.51, upper = -0.33)
p0 <- 0.40

delta <- diff(score)
delta

OR_new <- OR ^ delta
OR_new

CASI_new <- CASI * delta
CASI_new

odds0 <- p0 / (1 - p0)
odds0

odds1 <- odds0 * OR_new["estimate"]
odds1

p1 <- odds1 / (1 + odds1)
p1
