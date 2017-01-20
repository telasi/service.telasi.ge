xml.users do
	@users.each do |user|
		xml.user do
			xml.perskey(user.perskey)
			xml.username(user.persname.to_s.to_ka)
			xml.login(user.login)
			xml.password(user.password)
		end
	end
end