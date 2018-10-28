create table todo (
    `id` int auto_increment primary key COMMENT '主键',
    `title` text COMMENT '标题',
    `created` datetime default CURRENT_TIMESTAMP COMMENT '创建时间',
    `done` boolean default 0 );
