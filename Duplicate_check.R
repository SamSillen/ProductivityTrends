#Duplicates have been found in training file, this code checks to see if they have come from WQP / AquaSat or a result of munging datasets. 


training <- read.csv("C:/Users/samsi/Dropbox/training.csv")

dups.check <- training %>%
  select(blue, red, green, swir1, swir2, nir, lagoslakeid, date, chl_a, landsat_id)

dups.check <- data.table(dups.check)

dups.check <- duplicated_rows(as.data.table(dups.check))

#420 duplicates; to see if these are AquaSat / WQP , I will compare duplicated observations in training file to raw aquasat file 
#if they match I will assume these duplicates are a result of data being enetered into WQP more than once. 

raw.aquasat <- read.csv("C:/Users/samsi/Dropbox/sr_wq_rs_join.csv") 

#filter to Intermountain West States

#COLORADO
co_min_lat = 36.9949
co_max_lat = 41.0006
co_min_long = -109.0489
co_max_long = -102.0424

co_aquasat <- raw.aquasat %>% 
  filter(lat >= co_min_lat & lat <= co_max_lat & 
           long >= co_min_long & long <= co_max_long) %>%
  filter(type == 'Lake') %>%
  drop_na(chl_a)

#IDAHO
id_min_lat = 41.9871
id_max_lat = 49.0018
id_min_long = -117.2372
id_max_long = -111.0471

id_aquasat <- raw.aquasat %>% 
  filter(lat >= id_min_lat & lat <= id_max_lat & 
           long >= id_min_long & long <= id_max_long) %>%
  filter(type == 'Lake') %>%
  drop_na(chl_a)

#MONTANA
mt_min_lat = 44.3563
mt_max_lat = 48.9991
mt_min_long = -116.0458
mt_max_long = -104.0186

mt_aquasat <- raw.aquasat %>% 
  filter(lat >= mt_min_lat & lat <= mt_max_lat & 
           long >= mt_min_long & long <= mt_max_long) %>%
  filter(type == 'Lake') %>%
  drop_na(chl_a)

#UTAH
ut_min_lat = 36.9982
ut_max_lat = 41.9993
ut_min_long = -114.0504
ut_max_long = -109.0462

ut_aquasat <- raw.aquasat %>% 
  filter(lat >= ut_min_lat & lat <= ut_max_lat & 
           long >= ut_min_long & long <= ut_max_long) %>%
  filter(type == 'Lake') %>%
  drop_na(chl_a)

#WYOMING
wy_min_lat =  40.9986
wy_max_lat = 44.9988
wy_max_long =  -104.0556
wy_min_long = -111.0539

wy_aquasat <- raw.aquasat %>% 
  filter(lat >= wy_min_lat & lat <= wy_max_lat & 
           long >= wy_min_long & long <= wy_max_long) %>%
  filter(type == 'Lake') %>%
  drop_na(chl_a)

west_aquasat <- rbind(co_aquasat, id_aquasat, mt_aquasat, ut_aquasat, wy_aquasat)

#The raw AquaSat file has the same number of observations as the training file, 
#suggesting these duplicates came from further upstream #(WQP / Aquasat.) 
#Let's make sure

west_aquasat <- west_aquasat %>%
  select(blue, red, green, date, chl_a, landsat_id)

dups.check.raw <- duplicated_rows(as.data.table(west_aquasat))

#There are the same number of duplicated observations for our training file, and
# and the raw AquaSat file. 