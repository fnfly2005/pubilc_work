#!/bin/bash
task() {
echo "
##Description##

##TaskInfo##
creator = 'fannian@maoyan.com'

source = {
    'db': META['h$1'], 
}

stream = {
    'format': '', 
}

target = {
    'db': META['hmart_movie'], 
    'table': '$2', 
} 
##Extract##

##Preload##

##Load##
"
}

ins="insert OVERWRITE TABLE \`\$target.table\`"

cre="##TargetDDL##
CREATE TABLE IF NOT EXISTS \`\$target.table\`
("

com() {
echo "
)  COMMENT '$1'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orc"
}
