class Statistics
  include Database

  def winners(base)
    data = multi_sort(base)
    array_rows = to_table(data)
    table(array_rows)
  end

  private

  def to_table(data)
    rows = []
    data.each do |i|
      row = []
      row << i.name
      row << i.difficulty
      row << i.attempts_total
      row << i.attempts_used
      row << i.hints_total
      row << i.hints_used
      rows << row
    end
    rows
  end

  def multi_sort(items)
    items.sort_by { |x| [x.difficulty, x.attempts_used, x.hints_used] }
  end

  def table(rows)
    title = ['Name', 'Difficulty', 'Attempts Total', 'Attempts Used', 'Hints Total', 'Hints Used']
    Terminal::Table.new title: 'Codebreaker stats', headings: title, rows: rows
  end
end
