vitesse <- c(0, 600, 10:20 * 100, 2230, 2480, 2810, 3140)
conso <- c(0, 85, 142, 157, 178, 200, 225, 254, 293, 324, 365, 411, 464, 607, 799, 1129, 1576)

library(ggplot2)
theme_set(theme_bw(16))
qplot(vitesse, conso) + 
  geom_line() +
  geom_abline(slope = 142 / 1000, color = "blue")

qplot(vitesse, conso / vitesse) +
  geom_line() + ylim(0, NA) +
  geom_hline(yintercept = min(conso / vitesse, na.rm = TRUE), color = "blue")
