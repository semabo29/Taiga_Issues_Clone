# --- LIMPIEZA (Opcional, activa si quieres empezar de cero siempre) ---
# Issue.destroy_all

puts "Cargando datos iniciales de Taiga..."

# 1. USUARIO DE PRUEBA
user = User.find_or_create_by!(email: "prova@taiga.com") do |u|
  u.username = "Usuari prova"
end

# 2. STATUSES (Estados)
# Usamos colores reales de la paleta de Taiga
[
  { name: "New", color: "#70728F" },
  { name: "In progress", color: "#3366FF" },
  { name: "Ready for test", color: "#FFCC00" },
  { name: "Closed", color: "#A8E43D" }
].each do |s|
  Status.find_or_create_by!(name: s[:name]) { |obj| obj.color = s[:color] }
end

# 3. PRIORITIES (Prioridades)
[
  { name: "Low", color: "#999999" },
  { name: "Normal", color: "#A8E43D" },
  { name: "High", color: "#E44057" }
].each do |p|
  Priority.find_or_create_by!(name: p[:name]) { |obj| obj.color = p[:color] }
end

# 4. SEVERITIES (Severidades)
[
  { name: "Wishlist", color: "#3366FF" },
  { name: "Minor", color: "#FFCC00" },
  { name: "Normal", color: "#A8E43D" },
  { name: "Critical", color: "#E44057" }
].each do |sev|
  Severity.find_or_create_by!(name: sev[:name]) { |obj| obj.color = sev[:color] }
end

# 5. ISSUE TYPES (Tipos)
[
  { name: "Bug", color: "#E44057" },
  { name: "Question", color: "#00b19d" },
  { name: "Enhancement", color: "#3366FF" }
].each do |t|
  IssueType.find_or_create_by!(name: t[:name]) { |obj| obj.color = t[:color] }
end

puts "¡Seeds cargados con éxito!"