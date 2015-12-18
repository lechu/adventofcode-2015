defmodule Floors do
	def load(file) do
		{:ok, body} = File.read(file)
		body
	end

	def val("(") do
		1
	end

	def val(")") do
		-1
	end

	def val(_) do
		0
	end

	def count([]) do
		0
	end

	def count([head | tail]) do
		count(tail) + val(head)
	end

	def find_first_negative(list) do
		find_first_negative(list, 0, 0)
	end

	def find_first_negative(_, current, index) when current == -1 do
		index
	end

	def find_first_negative([], _, _) do
		0
	end

	def find_first_negative([head | tail], current, index) do
		find_first_negative(tail, current + val(head), index + 1)
	end
end

data = Floors.load("data.txt")
list = String.codepoints(data)
IO.puts "Result: #{Floors.count(list)}"
IO.puts "Result2: #{Floors.find_first_negative(list)}"