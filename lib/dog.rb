class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize (id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute('DROP TABLE dogs')
  end

  def self.new_from_db (array)
    self.new(id: array[0], name: array[1], breed: array[2])
  end

  def self.find_by_name (name)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE name = ?
    SQL
    array = DB[:conn].execute(sql).first
    self.new_from_db(array)
  end

  def update
    sql = <<-SQL
      UPDATE dogs SET name = ? where id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.id)
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute('SELECT last_insert_rowid() FROM dogs')[0][0]
    self
  end

  def self.create (name:, breed:)
    pup = self.new(name: name, breed: breed)
    pup.save
  end

  def self.find_by_id (id)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE id = ?
    SQL
    array = DB[:conn].execute(sql, id).first
    self.new(id: array[0], name: array[1], breed: array[2])
  end

  def self.find_or_create_by (name:, breed:)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE name = ? AND breed = ?
    SQL
    row = DB[:conn].execute(sql, name, breed).flatten
    if !row.empty?
      pup = self.new(id: row[0], name: row[1], breed: row[2])
    else
      pup = self.create(name: name, breed: breed)
    end
    p pup
    pup
  end

  def find_by_name (name)

  end
end
