# example DF

DF <- data.frame(a=1:4, b=c("x", "x", "y", "z"), d=c(NA, 1.3, "foo", "bar"))

# indexing

DF[1,]      # should get first row
DF$b        # vector of column B
DF[1,2]     # matrix like operation
DF[1, "b"]  # also works

# unlike Data Table,  filtering is not so convenient

DF[DF$a>2, 2] # Note need for DF$a notation - in DT,  could have just used a

# aggregate over group by via tapply

tapply(DF$a, DF$b, sum)             # cmpare with by clause in DT
sapply(split(DF$a, DF$b), sum)      # same results using split
