from github import Github

# using username and password
g = Github("user", "password")

query = "language:C type=code per_page=1000"
result = g.search_repositories(query)

#print(dir(result))
print(result.totalCount)

for repo in result[:1]:
    print(dir(repo))