defmodule Floors do
	def load(file) do
		{:ok, body} = File.read(file)
		body
	end

	def count([]) do
		0
	end

	def count([")" | tail]) do
		count(tail) - 1
	end

	def count(["(" | tail]) do
		count(tail) + 1
	end
end

data = Floors.load("data.txt")
IO.puts "Result: #{Floors.count(String.codepoints(data))}"