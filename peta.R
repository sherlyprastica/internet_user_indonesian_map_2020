library(tidyverse)
library(dplyr)
library(tidyr)
library(readxl)
library(raster)
library(sf)
require(maps)
require(viridis)
theme_set(
  theme_void()
)

peta_dunia <- map_data('world')
head(peta_dunia)

#load data pengguna internet
internet_user <- read_xlsx("../data persebaran internet/persebaran_pengguna_internet_fix_202203161536.xlsx")
internet_user <- internet_user %>% select(`NAME_1`, `2020_fix`)
View(internet_user)

#show map all world
ggplot(peta_dunia, aes(x=long, y=lat, group=group)) + geom_polygon(fill='lightgray', colour='white')

#show indonesian map
peta_indonesia <- map_data('world', region = 'Indonesia')
indonesia_map <- ggplot(peta_indonesia, aes(x=long, y=lat, group=group)) + geom_polygon(fill='lightgray', colour='white')
# Indonesia terletak antara 6° LU - 11° LS dan 95° BT - 141° BT.
indonesia_map <- ggplot(peta_dunia, aes(x=long, y=lat, group=group)) + geom_polygon(fill='lightgray', colour='white') + xlim(95, 141) + ylim(-11, 6)
#memotong berdasar provinsi
indonesia1 <- getData('GADM', country='IDN', level=1)
ind1 <- readRDS('gadm36_IDN_1_sp.rds')
ind1A <- fortify(ind1)
warna <- rainbow(length(unique(ind1A$id)))
ggplot(peta_indonesia, aes(x=long, y=lat, group=group)) + geom_polygon(data=ind1A, aes(x=long, y=lat, group=group, fill=id), color='grey')
ind1@data$id <- rownames(ind1@data)
ind1B <- plyr::join(ind1A, ind1@data, by="id")
ind2B <- plyr::join(ind1B, internet_user, by="NAME_1")
ggplot(peta_indonesia, aes(x=long, y=lat, group=group)) + geom_polygon(data=ind2B, aes(x=long, y=lat, group=group, fill=`2020_fix`), color='grey') + labs(title="Peta Persebaran Pengguna Internet di Indonesia pada Tahun 2020")
