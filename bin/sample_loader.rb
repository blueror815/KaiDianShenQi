#!/usr/bin/env ruby

retailer = Retailer.create(
  user_name: '星巴克咖啡',
  password: '12345678',
  password_confirmation: '12345678'
)

product_1 = Product.create(
    title: "意式咖啡",
    price: 22,
    description: "初级奖励",
    barcode: 22345678,
    retailer_id: retailer.id,
    quantity_in_stock: 500,
    point_value: 250
)
product_2 = Product.create(
  title: "拿铁",
  price: 33,
  description: "进阶奖励",
  barcode: 12345678, 
  retailer_id: retailer.id, 
  quantity_in_stock: 500,
  point_value: 500
)
product_3 = Product.create(
  title: "金枪鱼披萨(12寸)",
  price: 75,
  description: "终极奖励",
  barcode: 32345678, 
  retailer_id: retailer.id, 
  quantity_in_stock: 5, 
  point_value: 700
)

first_member = Member.create(
  member_external_id: '18612490818',
  password: '12345678',
  password_confirmation: '12345678',
  gender: 'Male',
  address: '初步用户',
  birth_date: 30.years.ago.to_s
)
second_member = Member.create(
  member_external_id: '15001131183',
  password: '12345678',
  password_confirmation: '12345678',
  gender: 'Male',
  address: '和平里',
  birth_date: 20.years.ago.to_s
)
third_member = Member.create(
  member_external_id: '13885006077',
  password: '12345678',
  password_confirmation: '12345678',
  gender: 'Male',
  address: '三里屯',
  birth_date: 25.years.ago.to_s
)
forth_member = Member.create(
  member_external_id: '13985336501',
  password: '12345678',
  password_confirmation: '12345678',
  gender: 'Male',
  address: '中关村东路',
  birth_date: 35.years.ago.to_s
)

first_membership = Membership.create(
  member: first_member,
  retailer: retailer
)
second_membership = Membership.create(
  member: second_member,
  retailer: retailer
)
third_membership = Membership.create(
  member: third_member,
  retailer: retailer
)
forth_membership = Membership.create(
  member: forth_member,
  retailer: retailer
)

first_membership.tag_list.add("VIP")
first_membership.save
second_membership.tag_list.add("常客")
second_membership.save
third_membership.tag_list.add("新注册")
third_membership.save
forth_membership.tag_list.add("沉睡")
forth_membership.save
