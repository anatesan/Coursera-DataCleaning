library(data.table)


#################################################
# NOT KEYED - test data tables
#################################################

# small (50 row) test table
DT50<-data.table(a=rnorm(50),  b=rpois(50, 2.3), 
                 c=sample(c("x", "y", "z", "w"), replace = TRUE, prob=c(0.4, 0.25, 0.50, 0.1), size = 50))

# large (1E5 row) test table
DT1E5<-data.table(a=rnorm(1E5),  b=rpois(1E5, 6.3), 
                  c=sample(c("x", "y", "z", "w"), replace = TRUE, prob=c(0.4, 0.50, 0.50, 0.1), size = 1E5))

#################################################
# Master & Lookup Table to test merge - KEYED
#################################################
MDT50<-data.table(a=rnorm(50),  b=rpois(50, 2.3), 
                  c=sample(c("x", "y", "z", "w"), replace = TRUE, prob=c(0.4, 0.25, 0.50, 0.1), size = 50))

# Note: NonUnique_LDT25 has one extra value ("r") in key col that is not in MDT50
# Also changed the keyed column name to c to make testing a bit simpler - so keys are defined on same column name
# if you join 2 tables with different keyed col names,  MERGE seems to provide the flexibility,  but not sure if DT notation
# allows that
NonUnique_LDT25<-data.table(val=rnorm(25, 4, 3),  
                 c=sample(c("x", "y", "z", "w", "r"), replace = TRUE, prob=c(0.3, 0.25, 0.15, 0.1, 0.2), size = 25),
                 nk=sample(c("p", "q", "r", "s"), replace = TRUE, prob=c(0.1, 0.4, 0.4, 0.1), size = 25))

MDT1E5<-data.table(a=rnorm(1E5),  b=rpois(1E5, 2.3), 
                  c=sample(c("x", "y", "z", "w"), replace = TRUE, prob=c(0.4, 0.1, 0.4, 0.1), size = 1E5))


Unique_LDT4<-data.table(val=1:4,  
                  c=c("x", "y", "r", "bar"),
                  nk=sample(c("p", "q", "r", "s"), replace = TRUE, prob=c(0.1, 0.4, 0.4, 0.1), size = 4))

MDT10<-data.table(a=rnorm(10),  b=rpois(10, 2.3), 
                   c=sample(c("x", "y", "z", "w"), replace = TRUE, prob=c(0.4, 0.1, 0.4, 0.1), size = 10))


setkey(MDT50,c)
setkey(NonUnique_LDT25, c) # note no key on nk
setkey(MDT1E5, c)
setkey(Unique_LDT4, c)
setkey(MDT10, c)

###########################################################
# Aggregation columns - in the j position (expressions) - No keys needed
###########################################################

DT50[,.(sum(a), mean(b))] # expressions do not require sorting
DT50[,.(median(a), median(b))] # expressions that require sorting

###########################################################
# Aggregation with grouping (by clause) - note, no keys
###########################################################

DT50[,.(sum(a), mean(b)), by=c] # Simple by
DT50[,.(.N, sum(a), mean(b)), by=c] # ,N to get counts by group

###########################################################
# Where clause equivalents - i clause usage - No key
###########################################################

DT50[a>0] # no sorting or equality tests needed - all columns displayed
DT50[a>0, .(b)] # no sorting or equality tests needed - show only col B
DT50[a>0, .N] # no sorting or equality tests needed - show aggregated count - single row

DT50[a>0 & b>1, .N]# more complex i clauses
DT50[a>0 & b>1 & c=="x", .N]# equality but still no keys demanded - maybe because DT50 is small?

# Do we need a key with a larger table? 

DT1E5[a>0 & b>1 & c=="x", .N]       # equality but still no keys demanded 
DT1E5[a>0 & b>1 & c=="x", sum(a)]   # equality but still no keys demanded 
DT1E5[c=="x", sum(a)]               # equality but still no keys demanded

###########################################################################
# Add New columns permanently to DT - this is different from y expressions 
###########################################################################

DT50[, foo:= a+b]  # new column created and added to DT50
DT1E5[, foo:= a+b]  # new column created and added to DT1E5

#############################
# Key vs. No Key ops
#############################

#keyed column lookups

NonUnique_LDT25["x"]        # works since value found in keyed column c
MDT50["x"]        # works
MDT1E5["x"]       # works

# careful about which column you specify the lookup on a keyed data table

NonUnique_LDT25["p"]        # looks for value p in col c, not nk!    This may not be what you intended
NonUnique_LDT25[nk=="p"]    # looks for value p in nk column

# using key-ed lookup notation does not work at all on non-keyed DTs

DT50["x"]         # will error out
DT50[c=="x"]      # should work even without key but note notational difference
DT1E5[c=="x"]     # works


# Benchark non-keyed vs. keyed operational speeds

benchmark(replications = 1000, DT1E5[c=="x"], MDT1E5["x"] ) # non-keyed ops are almost 2x slower

#######################################################
# Experiments on DT notation,  sapply & tapply to get same results
#######################################################


#######################################################
# .SD and .SDncols
#######################################################

LDT25[, .(cNz=.SD[c!="z", .N], cNx=.SD[c!="x",.N]), by=nk] # drop rows in SD after grouping - not we are excluding c values differently in each col
LDT25[c!="z" & c!="y", .(cNz=.N, cNx=.N), by=nk] # Results are different than above because z & y values are dropped for both cNz and cNx


#######################################################
# MERGE experiments
# Good tutorial at https://rstudio-pubs-static.s3.amazonaws.com/52230_5ae0d25125b544caab32f75f0360e775.html
#######################################################

# Using the DT notation - needs to work with unique Lookup Tables - 1 row per unique key

left_outer_join<- Unique_LDT4[MDT10]             # intersection + 1 row per MDT10 row with key val missing in Unique_LDT4
inner_join<- MDT10[Unique_LDT4, nomatch=0]       # should get <=10 rows (intersection)
right_outer_join<- MDT10[Unique_LDT4]            # intersection + 1 row per Unique_LDT4 row with key missing in MDT10

left_outer_join<- Unique_LDT4[MDT50]             # intersection + 1 row per MDT10 row with key val missing in Unique_LDT4
inner_join<- MDT50[Unique_LDT4, nomatch=0]       # should get <=50 rows
right_outer_join<- MDT50[Unique_LDT4]            # intersection + 1 row per Unique_LDT4 row with key missing in MDT10

#######################################################
# Random experiments
#######################################################

# for data cleansing, how do we drop rows where a numeric column has a non-numeric character string

DT_bad_number<-data.table(xbad=c(1, 2, "foo"),  y=c(5,6,7))
DT_bad_number[is.numeric(xbad)]   # does not give desired results since is.numeric is not a vector operation
DT_bad_number[, xfixed:=as.numeric(DT_bad_number$xbad)] # creates another extra column with the fixed value but does not address original problem

# Test to see if setNames still allows you to refer to columns the right way

DT_col<-data.table(c(1, 2, "foo"), c(5,6,7))

# rbind test to add more rows to a data table

DT_expand <- Unique_LDT4
DT_expand <- rbind (DT_expand, Unique_LDT4)

# verify if statments in y part of DT expression - I was hoping this would work for the LIMO GS project,  but my understanding was incorrect
Unique_LDT4[, mean({if (c=="x") 5 else val})]  #  This does not work: WARNING the condition has length > 1 and only the first element will be used
Unique_LDT4[, mean(val)]



