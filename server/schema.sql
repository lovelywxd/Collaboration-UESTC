drop database if exists webApp;

create database webApp;

use webApp;

-- grant select, insert, update, delete on web.* to 'root'@'localhost' identified by 'wxd';

create table users (
    `studentNo` varchar(50) not null,
    `email` varchar(50) not null,
    `passwd` varchar(50) not null,
    `gender` bool not null,
    `name` varchar(50) not null,
    -- `image` varchar(500) not null,
    `phone` varchar(14) not null,
    `school` varchar(50) not null,
    unique key `idx_email` (`email`),
    key `idsx_studentNo` (`studentNo`),
    primary key (`name`)
) engine=innodb default charset=utf8;
