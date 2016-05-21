conn <- url("http://biostat.jhsph.edu/~jleek/contact.html")
h <- readLines(conn, 100)

class(h) # character array

lines<- c(h[10], h[20], h[30], h[100])
sapply(lines, nchar)
