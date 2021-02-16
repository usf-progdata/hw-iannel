library(dplyr)
library(tidyr)
library(tibble)

dat_bfi <- psychTools::bfi
key_bfi <- psychTools::bfi.keys

head(dat_bfi)


# ==================================================

# getting rid of rownames
dat_bfi <- dat_bfi %>%
  rownames_to_column(var = ".id")

head(dat_bfi)
filter(dat_bfi, .id == 61617)


# ==================================================

# converting between data.frame and tibble

## data.frame (base R)
psychTools::bfi

## tibble (tibble/tidyverse) #tidyverse allows to use tibbles instead of data frames; make sure multiple columns dont have same name; There are two main differences in the usage of a data frame vs a tibble: printing, and subsetting.


##Tibbles have a refined print method that shows only the first 10 rows, and all the columns that fit on screen. This makes it much easier to work with large data. In addition to its name, each column reports its type, a nice feature borrowed from str(): 
as_tibble(psychTools::bfi) #drops out rownames automatically
as_tibble(psychTools::bfi, rownames = ".id") #adds rownames argument 

###same thing 
psychTools::bfi %>% 
  rownames_to_column(var = ".id") %>% 
  as_tibble()
  

dat_bfi <- as_tibble(dat_bfi)

print(dat_bfi, n = 30)

## tibbles are nice, but some packages (e.g., lavaan) don't play well with them
## In that case, convert back to data.frame
as.data.frame(dat_bfi)


# ==================================================

# recode()
select(dat_bfi, .id, gender, education) #DONT STORE DATA AS VALUES

## Let's recode the categorical variables
dict <- psychTools::bfi.dictionary %>%
  as_tibble(rownames = "item")

# Remember how mutate() and summary() have the form:
#   mutate(.data, new_column = computation)
#
# recode() is backwards:
#   recode(.x, old = new)

dat_bfi %>%
  mutate(
    gender = recode(gender, "1" = "man", "2" = "female")
  ) %>%
  select(.id, gender, education)

#R will dummy code for you; keep it stored as character values 
dat_bfi %>%
  mutate(
    gender = recode(gender, "1" = "man", "2" = "female")
  ) %>%
  select(A1, gender) %>%  
  lm(A1 ~ gender, data = .) %>% #automatically dummy codes the variable!!
summary()

## note that for numeric values, you need to wrap them in "quotes" or `backticks`
## That's not necessary for character values
palmerpenguins::penguins %>%
  mutate(sex = recode(sex, male = "Male", female = "Female"))

## Let's look at a few more recode options
?recode

dat_bfi %>%
  mutate(
    education = recode(education, "1" = "Some HS", "2" = "HS", "3" = "Some College", "4" = "College", "5" = "Graduate degree")
  ) %>%
  select(.id, gender, education)

## Let's say we want just "HS or less" versus "more than HS"
dat_bfi %>%
  mutate(
    education = recode(education, "1" = "HS", "2" = "HS", .default = "More than HS")
  ) %>%
  select(.id, gender, education)

## let's say college vs. not college
dat_bfi %>%
  mutate(
    education = recode(education, "4" = "College", "5" = "College", .default = "Noncollege")
    ) %>% 
  select(.id, gender, education)
  

## Let's say we want to convert NA values to an explict value
dat_bfi %>%
  mutate(
    education = recode(education, "1" = "HS", "2" = "HS", .default = "More than HS", .missing = "(Unknown)")
  ) %>%
  select(.id, gender, education)

# tidyr::replace_na()

## If we just want to replace NA values, use `tidyr::replace_na()`

dat_bfi %>%
  mutate(
    education = replace_na(education, replace = "(Unknown)")
  ) %>%
  select(.id, gender, education)




# reverse coding variables
print(dict, n = 30)

reversed <- c("A1", "C4", "C5", "E1", "E2", "O2", "O5")

reversed <- dict %>%
  filter(Keying == -1) %>%
  pull(item)

dat_bfi %>%
  mutate(A1r = recode(A1, "6" = 1, "5" = 2, "4" = 3, "3" = 4, "2" = 5, "1" = 6)) %>%
  select(A1, A1r)


dat_bfi %>%
  mutate(A1r = 7 - A1) %>%
  select(A1, A1r)

#across means across all of these 
dat_bfi %>%
  mutate(
    across(all_of(reversed), #across all of columns in reverse vector specified above; 
           ~ recode(.x, "6" = 1, "5" = 2, "4" = 3, "3" = 4, "2" = 5, "1" = 6), # ~ is placeholder .x is placeholder) or you can do ~ 7 -.x
           .names = "{.col}r")
  ) %>%
  select(A1, A1r) #typically it's better to indicate that you've reverse-coded an item


# Now you try:

## 1. Use the psychTools::bfi (or psych::bfi) data

psychTools::bfi

## 2. Recode gender to 'man', 'women', '(no response)'

psychTools::bfi %>%
  mutate(
    gender = recode(gender, "1" = "man", "2" = "women", .missing = "no response") #use .missing because .default is for actual values
  ) %>%
  select(gender) %>% 
  filter(gender == "no response")

## 3. Recode education to "Some HS", "HS", "Some College", "College", "Graduate degree", "(no response)"


psychTools::bfi %>%
  mutate(
    education = recode(education, "1" = "Some HS", "2" = "HS", "3" = "Some College", "4" = "College", "5" = "Graduate degree", .missing = "(no response)")
  ) %>%
  select(education)

## 4. Compute a new variable `hs_grad` with levels "no" and "yes"
psychTools::bfi %>%
  mutate(hs_grad = recode(education, "1" = "no", .default = "yes")
  ) %>% 
  select(education, hs_grad)

## 5. Reverse code the -1 items, as indicated in psychTools::bfi.dictionary or psych::bfi.key
dictionary <- psychTools::bfi.dictionary %>% #move rownames to a columns
  as_tibble(rownames = "item_label") 

reversed <- dictionary %>% 
  filter(Keying == -1) %>% 
  pull(item_label) #select keeps it in a column; pull pulls it out of the dataframe #vectors can be freefloating (all columns are vectors, not all vectors are columns)

###now I want a dataframe w/ reverse-coded items
bfi_dat <- psychTools::bfi %>% 
  mutate(A1 )

#Ignore the code below- it doesn't work 
psychTools::bfi.dictionary %>% 
  filter(Keying == -1) %>% 
  pull(Item) 

psychTools::bfi.dictionary %>%
  mutate(
    across(all_of(reversed), 
           ~ recode(.x, 7 - .x),
           .names = "{.col}r")
  ) %>% 
select(reversed)




