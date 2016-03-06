require 'pg'
require 'csv'
require 'pry'

#first createdb ingredients in command shell

def db_connection
  begin
    connection = PG.connect(dbname: "ingredients")
    yield(connection)
  ensure
    connection.close
  end
end

def create_table
  sql1 = "CREATE TABLE gredients(
    id SERIAL PRIMARY KEY,
    index INTEGER,
    ingredient VARCHAR(255)
  );"
end

def table_to_postgres
  db_connection do |conn|
    conn.exec(create_table)
  end
end

def csv_to_postgres
  CSV.foreach('ingredients.csv', headers: false) do |row|
    db_connection do |conn|
      conn.exec("INSERT INTO gredients(index, ingredient) VALUES (#{row[0]}, '#{row[1]}')")
    end
  end
end

def print_to_terminal
  @ingredients = db_connection { |conn| conn.exec("SELECT index, ingredient FROM gredients") }

  @ingredients.to_a.each do |ingredient|
    puts "#{ingredient["index"]}. #{ingredient["ingredient"]}"
  end
end

table_to_postgres
csv_to_postgres
print_to_terminal
