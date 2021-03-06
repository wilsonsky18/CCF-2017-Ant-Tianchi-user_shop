CREATE TABLE IF NOT EXISTS ant_tianchi_ccf_sl_shop_info
AS
SELECT *
FROM odps_tc_257100_f673506e024.ant_tianchi_ccf_sl_shop_info;

CREATE TABLE IF NOT EXISTS ant_tianchi_ccf_sl_user_shop_behavior
AS
SELECT *
FROM odps_tc_257100_f673506e024.ant_tianchi_ccf_sl_user_shop_behavior;

CREATE TABLE IF NOT EXISTS ant_tianchi_ccf_sl_test
AS
SELECT *
FROM odps_tc_257100_f673506e024.ant_tianchi_ccf_sl_test;

CREATE TABLE IF NOT EXISTS merge_train
AS
SELECT e1.shop_id, e1.mall_id, e2.user_id, e2.longitude, e2.latitude
	, e2.wifi_infos, e2.time_stamp AS time_stamp
FROM prj_tc_231620_98365_yrdets.ant_tianchi_ccf_sl_shop_info e1
JOIN prj_tc_231620_98365_yrdets.ant_tianchi_ccf_sl_user_shop_behavior e2
ON e1.shop_id = e2.shop_id;

-- first split ;
DROP TABLE IF EXISTS temp_train_index;
CREATE TABLE temp_train_index
AS
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi_infos, ';', 1) AS wifi
FROM (
	SELECT *
	FROM merge_train_index
) wifi_new
UNION
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi_infos, ';', 2) AS wifi
FROM (
	SELECT *
	FROM merge_train_index
) wifi_new
UNION
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi_infos, ';', 3) AS wifi
FROM (
	SELECT *
	FROM merge_train_index
) wifi_new
UNION
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi_infos, ';', 4) AS wifi
FROM (
	SELECT *
	FROM merge_train_index
) wifi_new
UNION
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi_infos, ';', 5) AS wifi
FROM (
	SELECT *
	FROM merge_train_index
) wifi_new
UNION
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi_infos, ';', 6) AS wifi
FROM (
	SELECT *
	FROM merge_train_index
) wifi_new
UNION
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi_infos, ';', 7) AS wifi
FROM (
	SELECT *
	FROM merge_train_index
) wifi_new
UNION
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi_infos, ';', 8) AS wifi
FROM (
	SELECT *
	FROM merge_train_index
) wifi_new
UNION
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi_infos, ';', 9) AS wifi
FROM (
	SELECT *
	FROM merge_train_index
) wifi_new
UNION
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi_infos, ';', 10) AS wifi
FROM (
	SELECT *
	FROM merge_train_index
) wifi_new;

-- second split |
DROP TABLE IF EXISTS jpc_train_index;
CREATE TABLE jpc_train_index
AS
SELECT append_id,user_id, shop_id, mall_id, time_stamp, longitude, latitude
	, split_part(wifi, '|', 1) AS wifi_id
	, split_part(wifi, '|', 2) AS signal
	, split_part(wifi, '|', 3) AS connect
FROM (
	SELECT *
	FROM temp_train_index
	WHERE wifi IS NOT NULL
		and wifi != ''
) e;

--filter wifi number between 5 - 10000
DROP TABLE IF EXISTS jpc_wifi_filter_index;
CREATE TABLE IF NOT EXISTS jpc_wifi_filter
AS
SELECT COUNT(wifi_id) AS wifi_count, wifi_id
FROM jpc_train_index
GROUP BY wifi_id
HAVING wifi_count 
BETWEEN 5
AND 10000;

-- join the trian to wifi_filter
DROP TABLE IF EXISTS jpc_second_train_index;
CREATE TABLE IF NOT EXISTS jpc_second_train_index
AS
SELECT temp1.user_id, temp1.mall_id, temp1.shop_id, temp1.longitude, temp1.latitude
	, temp1.wifi_id, temp1.signal, temp1.connect
FROM jpc_train_indedx temp1
JOIN jpc_wifi_filter_index temp2
ON temp1.wifi_id = temp2.wifi_id

