defmodule AdventCoints do
	
	def find(input, pattern) do
		find(input, pattern, 1)
	end

	def find(input, pattern, count) do
		md5 = :crypto.hash(:md5, "#{input}#{count}") |> Base.encode16
		if Regex.run(pattern, md5) == nil do
			find(input, pattern, count + 1)
		else
			count
		end
	end
end

IO.puts "Result1: #{AdventCoints.find("yzbqklnj", ~r/^00000.*$/)}"
IO.puts "Result2: #{AdventCoints.find("yzbqklnj", ~r/^000000.*$/)}"