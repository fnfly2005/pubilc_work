#!/bin/bash
tb="upload_table"
user="fnfly2005"
host="127.0.0.1"

mysqle() {
    mysql -h$host -u$user -D$tb < $1 -p$2
}

mysqll() {
    mysqlimport -h$host -u$user -p$2 $tb --fields-terminated-by=',' $1  --local
}
