puts "Creating 20 users..."

20.times do |i|
  AdminUser.create!(
    email: "usuario#{i+1}@example.com",
    password: "123456",
    password_confirmation: "123456"
  )
end


puts "Users created successfully!"
# db/seeds.rb

# Crear la fila única de la secuencia si no existe
if ActiveRecord::Base.connection.select_value("SELECT COUNT(*) FROM sequences").to_i.zero?
  ActiveRecord::Base.connection.execute("INSERT INTO sequences (sequence_numero) VALUES (0)")
  puts "Secuencia inicial creada con valor 0"
else
  puts "Secuencia ya existe, no se crea de nuevo"
end


