--一个mall测试版
drop table if exists m_1006_wifi;
create table if not exists m_1006_wifi as
select wifi_id, shop_id, count(signal) num from(
select user_id, shop_id, wifi_id,signal from(select user_id, shop_id, wifi_id,signal, rank () over (distribute by user_id,shop_id sort by signal asc) a  from train_m_1006) b 
where b.a=1) c group by wifi_id,shop_id;

--所有mall完整版
drop table if exists jpc_wifi_train ;
create table if not exists jpc_wifi_train as
select wifi_id, shop_id, count(signal) num from(
select user_id, shop_id, wifi_id,signal from(select user_id, shop_id, wifi_id,signal, rank () over (distribute by user_id,shop_id sort by signal asc) a  from jpc_second_train) b 
where b.a=1) c group by wifi_id,shop_id;
select count(*) from jpc_wifi_traini;
select count(distinct wifi_id) from jpc_wifi_traini;


drop table if exists jpc_wifi_test ;
create table if not exists jpc_wifi_test as

select row_id, shop_id,num,rank() over (distribute by row_id sort by num desc) rank_wifi from(
select temp2.row_id,temp1.wifi_id,temp1.shop_id,temp1.num from m_1006_wifi temp1 join test_m_1006 temp2 on temp1.wifi_id=temp2.wifi_id) temp3
