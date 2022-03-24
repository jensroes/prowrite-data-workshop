library(tidyr)
library(dplyr)
library(rio)
library(Hmisc)
library(irr)
options(scipen = 999)

## CHECK krippendorf alpha's
laura <- import("data/190403_laura_anot.csv")
rianne <- import("data/190327_rianne_anot.csv")
emily <- import("data/190402_Emily_anot.csv")
haley <- import("data/190403_haley_anot.csv")
mackenzie <- import("data/190328_MacKenzie_anot.csv")

# check for revision_end
all <- import("data/allfiles2.csv")
all_rel <- all %>%
  filter(label == "rel", revision == 1) %>%
  select(fileno, rev_no, annotator, revision_end) %>%
  pivot_wider(names_from = "annotator", values_from = "revision_end") %>%
  mutate(#Rianne = gsub("_", "", Rianne),
         Rianne = gsub("\\\\", "/", Rianne),
         #MacKenzie = gsub("_", "", MacKenzie),
         MacKenzie = gsub("\\\\", "/", MacKenzie),
         #Emily = gsub("_", "", Emily),
         Emily = gsub("\\\\", "/", Emily),
         #Haley = gsub("_", "", Haley),
         Haley = gsub("\\\\", "/", Haley),
         #Laura = gsub("_", "", Laura),
         Laura = gsub("\\\\", "/", Laura))

kripp.alpha(t(select(all_rel, -fileno, -rev_no)), method=c("nominal"))
all_rel$unique <- apply(all_rel, 1, function(x)length(unique(x)))
all_rel$disagree <- (all_rel$unique == 5)
(nrow(all_rel)-sum(all_rel$disagree))/nrow(all_rel)

# rename vars
rename_allvars <- function(table,prefix){
  names(table) <- paste(prefix, names(table), sep = "_")
  table
}

collapse_surface_type <- function(data){
  data <- data %>%
    rowwise() %>% 
    mutate(typography = grepl("t", surface_type),
           spelling = grepl("s", surface_type),
           grammar = grepl("g", surface_type),
           cosmetics = grepl("c", surface_type),
           wording = grepl("w", surface_type),
           surface = (surface_type != 0 | is.na(surface_type)),
           revision_end = gsub("_", "", revision_end))
}

rianne <- collapse_surface_type(rianne)
laura <- collapse_surface_type(laura)
emily <- collapse_surface_type(emily)
haley <- collapse_surface_type(haley)
mackenzie <- collapse_surface_type(mackenzie)

rianne <- rename_allvars(rianne, "r")
laura <- rename_allvars(laura, "l")
emily <- rename_allvars(emily, "e")
haley <- rename_allvars(haley, "h")
mackenzie <- rename_allvars(mackenzie, "m")

# get all files coded
files_rianne <- unique(rianne$r_file)
files_laura <- unique(laura$l_file)
files_emily <- unique(emily$e_file)
files_haley <- unique(haley$h_file)
files_mackenzie <- unique(mackenzie$m_file)

# files coded by multiple coders
all <- (c(files_rianne, files_laura, files_emily, files_haley, files_mackenzie))
int <- all[duplicated(all)]

# get raters per var into one table
allrates <- rianne %>%
    full_join(laura,  by = c("r_file" = "l_file", "r_rev_no" = "l_rev_no")) %>%
    full_join(emily,  by = c("r_file" = "e_file", "r_rev_no" = "e_rev_no")) %>%
    full_join(haley,  by = c("r_file" = "h_file", "r_rev_no" = "h_rev_no")) %>%
    full_join(mackenzie,  by = c("r_file" = "m_file", "r_rev_no" = "m_rev_no")) %>%
    filter(r_file %in% int,  (r_revision == 1 | e_revision == 1 | 
                              h_revision == 1 | l_revision == 1|  
                              m_revision == 1))
#,           (r_surface == 1 | e_surface == 1 | 
#             h_surface == 1 | l_surface == 1|  
#              m_surface == 1) )


calc_perc_agreement <- function(var, tol){
  varrate <- select(allrates, ends_with(var)) %>%
    mutate_all(na_if,"")
  varrate$rate_count <- apply(varrate, 1, function(x) sum(!is.na(x)))
  varrate2 <- varrate %>%
    filter(rate_count == 2) %>%
    select(-rate_count) 
  varrate2$unique <- apply(varrate2, 1, function(x)length(unique(x)))
  varrate2$agree <- (varrate2$unique == 2)
  sum(varrate2$agree)/nrow(varrate2)
}

calc_perc_agreement("revision")
calc_perc_agreement("revision_end")
calc_perc_agreement("surface")
calc_perc_agreement("typography")
calc_perc_agreement("spelling")
calc_perc_agreement("grammar")
calc_perc_agreement("cosmetics")
calc_perc_agreement("wording")
calc_perc_agreement("deep_change")
calc_perc_agreement("deep_type")
calc_perc_agreement("correct_start")
calc_perc_agreement("correct_end")
calc_perc_agreement("domain")
calc_perc_agreement("word_finished")
calc_perc_agreement("word_initial")
calc_perc_agreement("intended_word")
calc_perc_agreement("clause_initial")
calc_perc_agreement("sentence_initial")
calc_perc_agreement("overrides")
calc_perc_agreement("continuous")



# deep_type
files_r <- rianne %>% 
  filter(file %in% int) %>% 
  rename(r_deep_type = deep_type,
         r_domain = linguistic_domain) 

files_l <- laura %>% 
  filter(file %in% int) %>% 
  rename(l_deep_type = deep_type,
         l_domain = linguistic_domain) 

files_e <- emily %>% 
  filter(file %in% int) %>% 
  rename(e_deep_type = deep_type,
         e_domain = linguistic_domain)

files_h <- haley %>% 
  filter(file %in% int) %>% 
  rename(h_deep_type = deep_type,
         h_domain = linguistic_domain)

files_m <- mackenzie %>% 
  filter(file %in% int) %>% 
  rename(m_deep_type = deep_type,
         m_domain = linguistic_domain)



# check all
deep_type <- files_r %>%
  filter(deep_change == 1) %>%
  select(rev_no, file, r_deep_type) %>%
  full_join(select(files_l, file, rev_no, l_deep_type)) %>%
  full_join(select(files_e,  file, rev_no, e_deep_type)) %>%
  full_join(select(files_m,  file, rev_no, m_deep_type)) %>%
  full_join(select(files_h,  file, rev_no, h_deep_type)) %>%
  select(-rev_no,-file)

kripp.alpha(t(deep_type), method=c("nominal"))


# CHECK WITH WORD FINISHED Y?N
deep_type_f <-  files_r %>%
  filter(deep_change == 1, !is.na(intended_word)) %>%
  select(rev_no, file, r_deep_type) %>%
  full_join(files_l %>% filter(deep_change == 1, !is.na(intended_word))
            %>% select(file, rev_no, l_deep_type)) %>%
  full_join(files_e %>% filter(deep_change == 1, !is.na(intended_word))
            %>% select(file, rev_no, e_deep_type)) %>%
  full_join(files_m %>% filter(deep_change == 1, !is.na(intended_word))
            %>% select(file, rev_no, m_deep_type)) %>%
  full_join(files_h %>% filter(deep_change == 1, !is.na(intended_word))
            %>% select(file, rev_no, h_deep_type)) %>%
  select(-rev_no,-file)

deep_type_f2 <- deep_type_f %>%
  filter(rowSums(is.na(deep_type_f)) < 4) 

kripp.alpha(t(deep_type_f2), method=c("nominal"))


# remove where 4 NA
deep_type2 <- deep_type %>%
  filter(rowSums(is.na(deep_type)) < 4) 

deep_type2$col <- apply(deep_type2, 1, function(x) paste(sort(x), collapse = " "))

testalpha <- function(var){
  deep_type3 <- deep_type2 %>%
    select(-col) %>%
    mutate_all(~ifelse(. == var, 1, 0))
  
  kripp.alpha(t(deep_type3), method=c("nominal"))
}

testalpha("Supporting info")
testalpha("Emphasis")
testalpha("Coherence")
testalpha("Cohesiveness")
testalpha("Subtopic")
testalpha("Overall aim, RQ")
testalpha("unknown")
testalpha("Understate")

# microstructure
deep_type3 <- deep_type2 %>%
  select(-col) %>%
  mutate_all(~ifelse(. == "Overall aim, RQ" | . == "Subtopic", 0, 1)) 

kripp.alpha(t(deep_type3), method=c("nominal"))


# macrostructure
deep_type3 <- deep_type2 %>%
  select(-col) %>%
  mutate_all(~ifelse(. == "Overall aim, RQ" | . == "Subtopic", 1, 0)) 

kripp.alpha(t(deep_type3), method=c("nominal"))


tab <-as.data.frame(table(deep_type2$col))



write.csv(tab,"data/deep_type.csv")


## check double coded files
rel_check <- c(5, 8, 10, 15, 18, 26, 40, 61, 80, 83, 86, 
               88, 93, 101, 102)
data_coded <- data %>%
  filter(fileno %in% rel_check, revision ==1)

# data deep-specify
data_coded <- data %>%
  filter(deep_change ==1, revision ==1)


## LOGISTIC DOMAIN
# check all
domain <- files_r %>%
  select(rev_no, file, r_domain) %>%
  full_join(select(files_l, file, rev_no, l_domain)) %>%
  full_join(select(files_e,  file, rev_no, e_domain)) %>%
  full_join(select(files_m,  file, rev_no, m_domain)) %>%
  full_join(select(files_h,  file, rev_no, h_domain)) %>%
  select(-rev_no,-file) %>% 
  mutate_all(na_if,"")

kripp.alpha(t(domain), method=c("nominal"))


# remove where 4 NA
domain2 <- domain %>%
  filter(rowSums(is.na(domain)) < 4) 

testalpha2 <- function(var){
  domain3 <- domain2 %>%
    mutate_all(~ifelse(. == var, 1, 0))
  
  kripp.alpha(t(domain3), method=c("nominal"))
}

testalpha2("Subword")
testalpha2("Word")
testalpha2("Phrase")
testalpha2("Clause")
testalpha2("Sentence")
testalpha2("Paragraph")

domain2$col <- apply(domain2, 1, function(x) paste(sort(x), collapse = " "))
tab <-as.data.frame(table(domain2$col))



write.csv(tab,"data/domain.csv")
