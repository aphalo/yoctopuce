library(readr)
library(ggplot2)
library(lubridate)

data2 <- read_delim("inst-not/TSL2591-Lux-I2C-sensor/data2.csv",
                    delim = ";", escape_double = FALSE, trim_ws = TRUE,
                    col_select = 2:3)
colnames(data2) <- c("time", "illuminance")
# problems(data2)
# spec(data2)
subset(data2, time >= ymd_hms("2024-09-29 10:00:00")) |>
  ggplot(aes(time, illuminance)) + geom_line()

data3 <- read_delim("inst-not/TSL2591-Lux-I2C-sensor/data-2ch-3log-zz.csv",
                    delim = ";", escape_double = FALSE, trim_ws = TRUE,
                    col_select = 2:5)
colnames(data3) <- c("time", "VIS", "IR", "Illum")
# problems(data2)
# spec(data2)

ggplot(data3, aes(time, VIS)) + geom_line()
ggplot(data3, aes(time, IR)) + geom_line()
ggplot(data3, aes(time, Illum)) + geom_line()
ggplot(data3, aes(time, VIS-IR)) + geom_line()

subset(data3, time >= ymd_hms("2024-09-29 19:30:00")) |>
  ggplot(aes(time, Illum)) + geom_line()

