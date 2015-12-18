defmodule Lights do
	defp _iterate_row([], _, _, _, _) do
		[]
	end

	defp _iterate_row(list, index, _, to, _) when index > to do
		list
	end

	defp _iterate_row([head | tail], index, from, to, action) when index < from do
		[head | _iterate_row(tail, index + 1, from, to, action)]
	end

	defp _iterate_row([head | tail], index, from, to , action) do
		[action.(head) | _iterate_row(tail, index + 1, from, to, action)]
	end

	defp _iterate_col([], _, _, _, _, _, _) do 
		[]
	end

	defp _iterate_col(list, row, _, _, _, to_row, _) when row > to_row do
		list
	end

	defp _iterate_col([head | tail], row, from_col, to_col, from_row, to_row, action) when row < from_row do
		[head | _iterate_col(tail, row + 1, from_col, to_col, from_row, to_row, action)]
	end

	defp _iterate_col([head | tail], row, from_col, to_col, from_row, to_row, action) do 
		[_iterate_row(head, 0, from_col, to_col, action) | _iterate_col(tail, row + 1, from_col, to_col, from_row, to_row, action)]
	end

	def fill(list, left, top, right, bottom, action) do 
		_iterate_col(list, 0, left, right, top, bottom, action)
	end

	def count_vals([], _ ) do 
		0
	end

	def count_vals([head | tail], val) when is_list(head) do 
		count_vals(head, val) + count_vals(tail, val)
	end

	def count_vals([head | tail], val) when head == val do
		count_vals(tail, val) + 1
	end

	def count_vals([_ | tail], val) do
		count_vals(tail, val)
	end

	def sum_vals([]) do 
		0
	end

	def sum_vals([head | tail]) when is_list(head) do 
		sum_vals(head) + sum_vals(tail)
	end

	def sum_vals([head | tail]) do
		sum_vals(tail) + head
	end

	def gen_row(0, _) do
		[]
	end

	def gen_row(1, fill) do
		[fill]
	end

	def gen_row(count, fill) do
		[fill | gen_row(count - 1, fill)]
	end

	def gen_table(col, rows, fill) do
		gen_row(rows, gen_row(col, fill))
	end

	def negate(0) do
		1
	end

	def negate(1) do
		0
	end

	def negate(v) do 
		v
	end

	def dec_min_0(v) when v < 1 do 
		0
	end

	def dec_min_0(v) do 
		v - 1
	end

	def match(str) do 
		m = Regex.run(~r/(turn on|toggle|turn off) ([0-9]+),([0-9]+) through ([0-9]+),([0-9]+)/, str)
	end

	def parse(list, current_state) do
		parse(list, current_state, length(list))
	end

	def parse([], current_state, _) do
		IO.puts "0"
	 	current_state
	end

	def parse([head | tail], current_state, c) when head == "" do 
		IO.puts "#{c}"
		parse(tail, current_state, c - 1)
	end

	def parse([head | tail], current_state, c) do 
		IO.puts "#{c}"
		[_, action, left, top, right, bottom] = match(head)
		parse(tail, exec(current_state, action, String.to_integer(left), String.to_integer(top), String.to_integer(right), String.to_integer(bottom)), c - 1)
	end

	def exec(list, "turn on", left, top, right, bottom) do
		Lights.fill(list, left, top, right, bottom, fn(_) -> 1 end)
	end

	def exec(list, "turn off", left, top, right, bottom) do
		Lights.fill(list, left, top, right, bottom, fn(_) -> 0 end)
	end

	def exec(list, "toggle", left, top, right, bottom) do
		Lights.fill(list, left, top, right, bottom, &Lights.negate/1)
	end

	def exec(list, _, _, _, _, _) do
		list
	end

	# 2nd part

	def parse2(list, current_state) do
		parse2(list, current_state, length(list))
	end

	def parse2([], current_state, _) do
		IO.puts "0"
	 	current_state
	end

	def parse2([head | tail], current_state, c) when head == "" do 
		IO.puts "#{c}"
		parse2(tail, current_state, c - 1)
	end

	def parse2([head | tail], current_state, c) do 
		IO.puts "#{c}"
		[_, action, left, top, right, bottom] = match(head)
		parse2(tail, exec2(current_state, action, String.to_integer(left), String.to_integer(top), String.to_integer(right), String.to_integer(bottom)), c - 1)
	end

	def exec2(list, "turn on", left, top, right, bottom) do
		Lights.fill(list, left, top, right, bottom, fn(v) -> v + 1 end)
	end

	def exec2(list, "turn off", left, top, right, bottom) do
		Lights.fill(list, left, top, right, bottom, &Lights.dec_min_0/1)
	end

	def exec2(list, "toggle", left, top, right, bottom) do
		Lights.fill(list, left, top, right, bottom, fn(v) -> v + 2 end)
	end

	def exec2(list, _, _, _, _, _) do
		list
	end

	def load(file) do
		{:ok, body} = File.read(file)
		String.split(body, "\n")
	end
end

# 1st part

data = Lights.gen_table(1000, 1000, 0)
commands = Lights.load("data.txt")
out = Lights.parse(commands, data)
count = Lights.count_vals(out, 1)
IO.puts "Result: #{count}"

# 2nd part

out2 = Lights.parse2(commands, data)
count2 = Lights.sum_vals(out2)
IO.puts "Result2: #{count2}"

# debug
# data = Lights.gen_table(25, 25, 0)
# commands = ["toggle 1,1 through 9,9", "toggle 14,14 through 23,23", "toggle 5,5 through 19,19", "turn off 11,11 through 13,13", "toggle 0,0 through 24,24"]
# out = Lights.parse(commands, data)
# IO.inspect out
