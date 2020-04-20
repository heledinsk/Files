pacman::p_load( "pacman", "tidyverse", "magrittr", "nycflights13", "gapminder", "Lahman", "maps", "lubridate", "pryr", "hms", "hexbin", "feather", "htmlwidgets", "stringr", "forcats", "broom", "pander", "modelr", "tidyr","rvest", "methods", "readr", "haven", "testthat","RSQLite")

sandbox <- read_csv("sandbox.csv")
View(sandbox)

# extract hashtags and put them in a new collumn

hash <- str_match_all(sandbox$text, "#\\w+")

sandbox_hash <- sandbox %>%
  mutate(hashtags = hash)


