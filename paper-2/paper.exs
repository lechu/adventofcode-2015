defmodule Paper do
	def load(file) do
		{:ok, body} = File.read(file)
		String.split(body, "\n")
	end

	def match(str) do 
		Regex.run(~r/([0-9]+)x([0-9]+)x([0-9]+)/, str)
	end

	# 1st
	def parse([]) do
		0
	end

	def parse([head | tail]) when head == "" do
		parse(tail)
	end

	def parse([head | tail]) do
		[_, l, w, h] = match(head)
		calc_paper(String.to_integer(l), String.to_integer(w), String.to_integer(h)) + parse(tail)
	end

	def calc_paper(l, w, h) do
		lw = l * w 
		lh = l * h
		wh = w * h

		min_size = Enum.min([lw, lh, wh])
		2 * lw + 2 * lh + 2 * wh + min_size
	end

	# 2nd
	def parse2([]) do
		0
	end

	def parse2([head | tail]) when head == "" do
		parse2(tail)
	end

	def parse2([head | tail]) do
		[_, l, w, h] = match(head)
		calc_ribbon(String.to_integer(l), String.to_integer(w), String.to_integer(h)) + parse2(tail)
	end


	def calc_ribbon(l, w, h) do
		v = l * w * h
		list = [l, w, h]
		max_size = Enum.max(list)

		[v1, v2] = List.delete(list, max_size)

		v + v1 * 2 + v2 * 2
	end

end

data = Paper.load("data.txt")
IO.puts("Result1: #{Paper.parse(data)}")
IO.puts("Result2: #{Paper.parse2(data)}")