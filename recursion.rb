def power(x, y)
	if (y == 0)
		return 1
	end

	return power(x, y - 1) * x
end


puts power(2, 2)
puts power(2, 100)

