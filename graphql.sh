# Set up variables
query='
query($cursor: String) {
  search(query: "language:C embedded", type: REPOSITORY, first: 100, after: $cursor) {
    pageInfo {
      hasNextPage
      endCursor
    }
    nodes {
      ... on Repository {
        sshUrl
      }
    }
  }
}'

# Fetch repositories
cursor=""
while true
do
  result=$(gh api graphql --paginate -f query="$query" -f cursor="$cursor")
  ssh_urls=$(echo "$result" | jq -r '.data.search.nodes[].sshUrl')
  echo "$ssh_urls" >> embedded_c_urls.txt

  hasNextPage=$(echo "$result" | jq -r '.data.search.pageInfo.hasNextPage')
  if [ "$hasNextPage" == "false" ]; then
    break
  fi

  cursor=$(echo "$result" | jq -r '.data.search.pageInfo.endCursor')
done
