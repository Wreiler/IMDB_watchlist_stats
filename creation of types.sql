-- type with number-number value pair
create type num_num as object
(
  value  NUMBER,
  count  NUMBER
);
-- type with string-number value pair
create type str_num as object
(
  value  VARCHAR2(200),
  count  NUMBER
);
