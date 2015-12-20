defmodule Houses do
	def load(file) do
		{:ok, body} = File.read(file)
		String.codepoints(body)
	end

	def inser_or_increas([], x, y, v) do
		[[x, y, v]]
	end

	def inser_or_increas([[xl, yl, vl] | tail], x, y, v) when (xl == x) and (yl == y) do
		[[x, y, vl + v] | tail]
	end

	def inser_or_increas([head | tail], x, y, v) do
		[head | inser_or_increas(tail, x, y, v)]
	end

	def parse(data) do
		parse(data, [0, 0], [[0, 0, 1]])
	end

	def parse([], _, state) do
		state
	end

	def parse(["^" | tail], [x, y], state) do
		parse(tail, [x, y - 1], inser_or_increas(state, x, y - 1, 1))
	end

	def parse(["v" | tail], [x, y], state) do
		parse(tail, [x, y + 1], inser_or_increas(state, x, y + 1, 1))
	end

	def parse(["<" | tail], [x, y], state) do
		parse(tail, [x - 1, y], inser_or_increas(state, x - 1, y, 1))
	end

	def parse([">" | tail], [x, y], state) do
		parse(tail, [x + 1, y], inser_or_increas(state, x + 1, y, 1))
	end

	def parse([_ | tail], cp, state) do
		parse(tail, cp, state)
	end

	def count_gt([], _) do
		0
	end

	def count_gt([head | tail], val) when head > val do
		count_gt(tail, val) + 1
	end

	def count_gt([_ | tail], val) do
		count_gt(tail, val)
	end

	#2 nd 

	def split_pairs(data) do
		split_pairs(data, 0, [], [])
	end

	def split_pairs([], _, left, right) do
		[left, right]
	end

	def split_pairs([head | tail], 0, left, right) do
		split_pairs(tail, 1, left ++ [head], right)
	end

	def split_pairs([head | tail], 1, left, right) do
		split_pairs(tail, 0, left, right ++ [head])
	end

	def merge_lists(left, []) do
		left
	end

	def merge_lists([], right) do
		right
	end

	def merge_lists(left, [[x, y, v] | tail]) do
		merge_lists(inser_or_increas(left, x, y, v), tail)
	end

end

list = Houses.load("data.txt")
h_list = Houses.parse(list)

[left, right] = Houses.split_pairs(list)
l_h_list = Houses.parse(left)
r_h_list = Houses.parse(right)
merge_h_list = Houses.merge_lists(l_h_list, r_h_list)

IO.puts("Result1: #{Houses.count_gt(h_list, 1)}")
IO.puts("Result2: #{Houses.count_gt(merge_h_list, 0)}")
