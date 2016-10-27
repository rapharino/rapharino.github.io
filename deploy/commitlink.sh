#!/usr/bin/env bash
curl -H 'Content-Type:text/plain' --data-binary @urls.txt "http://data.zz.baidu.com/urls?site=rapharino.com&token=CiGKzzxvYkIYN5gj"

#success	是	int	成功推送的url条数
##remain	是	int	当天剩余的可推送url条数
#not_same_site	否	array	由于不是本站url而未处理的url列表
#not_valid	否	array	不合法的url列表

# urls.txt 包含所有连接