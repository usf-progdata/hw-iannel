progdata::tutorial_wrangle()

#(FILTER)
##Looking back at the bfi_data, say I wanted to look at entries that have openness scores of greater than or equal to 3:

openness_cut_off <-
  bfi_data %>% 
  filter(openness >= 3)

openness_cut_off

#filter()ing with multiple-criteria
##Say I was only interested in looking at ages 20-29. HINT: the & operator is used to check if two logical operations are TRUE

age_bfi <-
  bfi_data %>% 
  filter(age > 20 & age < 29)
