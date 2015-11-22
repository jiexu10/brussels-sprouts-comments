require 'pg'
require 'faker'
require 'pry'

TITLES = ["Roasted Brussels Sprouts",
  "Fresh Brussels Sprouts Soup",
  "Brussels Sprouts with Toasted Breadcrumbs, Parmesan, and Lemon",
  "Cheesy Maple Roasted Brussels Sprouts and Broccoli with Dried Cherries",
  "Hot Cheesy Roasted Brussels Sprout Dip",
  "Pomegranate Roasted Brussels Sprouts with Red Grapes and Farro",
  "Roasted Brussels Sprout and Red Potato Salad",
  "Smoky Buttered Brussels Sprouts",
  "Sweet and Spicy Roasted Brussels Sprouts",
  "Smoky Buttered Brussels Sprouts",
  "Brussels Sprouts and Egg Salad with Hazelnuts"]

MEASUREMENTS = ["cup(s)", "pound(s)", "tablespoon(s)", "teaspoon(s)", "kilogram(s)", "gram(s)", "quart(s)", "gallon(s)", "barrel(s)"]

FAKESTUFF = [Faker::Avatar.image, Faker::University.name, Faker::Internet.email, Faker::Hacker.say_something_smart, Faker::Lorem.sentence, Faker::Company.catch_phrase, Faker::Company.bs, Faker::Commerce.product_name, Faker::Commerce.department(3)]

#QUESTION 6 ANSWERS

#PART 1
def total_recipes
  total = ""
  db_connection do |conn|
    sql_query = "SELECT count(*) FROM recipes;"
    total = conn.exec(sql_query)
  end
  total.first["count"]
end

#PART 2
def total_comments
  total = ""
  db_connection do |conn|
    sql_query = "SELECT count(*) FROM comments;"
    total = conn.exec(sql_query)
  end
  total.first["count"]
end

#PART 3
def comments_per_recipe
  count = ""
  (1..11).each do |n|
    db_connection do |conn|
      sql_query = "SELECT count(*) FROM comments WHERE recipe_id = #{n};"
      count = conn.exec(sql_query)
      puts "Recipe #{n} has #{count.first["count"]} comments."
    end
  end
end

#PART 4
def comment(number)
  comment = ""
  db_connection do |conn|
    sql_query = %(
    SELECT recipes.title, comments.id, comments.comment
    FROM recipes JOIN comments ON recipes.id = comments.recipe_id
    WHERE comments.id = #{number};
    )
    comment = conn.exec(sql_query)
  end
  comment.first["title"]
end

#PART 5
def add_new_recipe
  db_connection do |conn|
    sql_query = %(
    INSERT INTO recipes(title, ingredients, steps)
    VALUES ($1, $2, $3)
    )
    data = ["Brussels Sprouts with Goat Cheese", make_ingredients, make_steps]
    conn.exec_params(sql_query, data)
  end
  2.times do
    db_connection do |conn|
      sql_query = %(
      INSERT INTO comments(comment, recipe_id)
      VALUES ($1, $2)
      )
      data = [make_comment, 12]
      conn.exec_params(sql_query, data)
    end
  end
end

#WRITE CODE TO SEED YOUR DATABASE AND TABLES HERE

# recipes id,title,ingredients,steps
# comments id,comment,recipe_id

def db_connection
  begin
    connection = PG.connect(dbname: "brussels_sprouts_recipes")
    yield(connection)
  ensure
    connection.close
  end
end

def add_recipes_to_db
  TITLES.each do |title|
    build_recipe_query(title, make_ingredients, make_steps)
  end
end

def add_comments_to_db
  150.times do
    recipe_id = rand(11)+1
    build_comment_query(make_comment, recipe_id)
  end
end

def make_ingredients
  place = [Faker::Address.city, Faker::Address.state, Faker::Address.country]
  ingredients = ["#{place.sample} brussels sprouts"]
  (rand(4)+3).times do
    ingredients << "#{rand(49)+1} #{MEASUREMENTS.sample} #{Faker::SlackEmoji.food_and_drink[1..-2]}"
  end
  ingredients.join("\n")
end

def make_steps
  steps = []
  (1..rand(5)+3).each do |n|
    steps << "#{n}. #{FAKESTUFF.sample}"
  end
  steps.join("\n")
end

def make_comment
  comment = []
  (rand(2)+1).times do
    comment << "#{FAKESTUFF.sample}"
  end
  comment.join(" ")
end

def build_recipe_query(title, ingredients, steps)
  db_connection do |conn|
    sql_query = %(
    INSERT INTO recipes(title, ingredients, steps)
    VALUES ($1, $2, $3)
    )
    data = [title, ingredients, steps]
    conn.exec_params(sql_query, data)
  end
end

def build_comment_query(comment, recipe_id)
  db_connection do |conn|
    sql_query = %(
    INSERT INTO comments(comment, recipe_id)
    VALUES ($1, $2)
    )
    data = [comment, recipe_id]
    conn.exec_params(sql_query, data)
  end
end

binding.pry
