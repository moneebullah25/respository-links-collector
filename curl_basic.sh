for i in {300..2000}
do
    gh api -X GET "search/repositories?q=embedded+language:C&per_page=100&page=$i" \
    | jq -r '.items[].ssh_url' >> embedded_c_urls_curl.txt
done