library(httr)
library(jsonlite)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "47651de50829ec448333",
                   secret = "6e755bbde9b4801f4fa151d8b0d378e7c9a7b955")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
con<-content(req)

# con is a list - easiest to get Quiz2 Q1 answer from a data.table

con_dt<-data.table(fromJSON(toJSON(con, pretty = TRUE)))
print(con_dt[name=="datasharing", .(name, created_at)])

# OR:
#req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
#stop_for_status(req)
#content(req)
