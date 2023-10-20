DATE[0]="2018-01-01..2018-06-30"
DATE[1]="2017-07-01..2017-12-31"
DATE[2]="2017-01-01..2017-06-30"
DATE[3]="2016-07-01..2016-12-31"
DATE[4]="2016-01-01..2016-06-30"
DATE[5]="2015-07-01..2015-12-31"
DATE[6]="2015-01-01..2015-06-30"
DATE[7]="2014-07-01..2014-12-31"
DATE[8]="2014-01-01..2014-06-30"
DATE[9]="2013-07-01..2013-12-31"
DATE[10]="2013-01-01..2013-06-30"
DATE[11]="2012-07-01..2012-12-31"

for d in {1..11}
do
    for i in {0..10}
    do
        curl "https://api.github.com/search/repositories?q=embedded+language:C+created:${DATE[d]}&per_page=100&page=$i" \
        | jq -r '.items[].ssh_url' >> embedded_repos.txt
        sleep 5
    done
    sleep 10
done