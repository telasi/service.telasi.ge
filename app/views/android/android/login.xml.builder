xml.user do
  xml.email(@user.email)
  xml.login(@user.bs_login)
  xml.first_name(@user.first_name)
  xml.last_name(@user.last_name)
  xml.perskey(@user.bs_person)
end