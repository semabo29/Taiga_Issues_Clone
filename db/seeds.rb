puts "Limpiando base de datos y cargando nuevos datos de Taiga..."

# 1. USUARIO DE PRUEBA (Para evitar errores hasta que hagáis el Login)
User.find_or_create_by!(email: "prova@taiga.com") do |u|
  u.username = "Usuari prova"
end

# 2. STATUSES (Estados)
[
  { name: "New", color: "#70728F" },            # Gris azulado
  { name: "In progress", color: "#3366FF" },    # Azul
  { name: "Ready for test", color: "#FFCC00" }, # Amarillo
  { name: "Closed", color: "#A8E43D" },         # Verde
  { name: "Needs info", color: "#999999" },     # Gris medio
  { name: "Rejected", color: "#E44057" },       # Rojo
  { name: "Postponed", color: "#777777" }       # Gris oscuro
].each do |s|
  status = Status.find_or_initialize_by(name: s[:name])
  status.color = s[:color]
  status.save!
end

# 3. ISSUE TYPES (Tipos)
[
  { name: "Bug", color: "#E44057" },         # Rojo
  { name: "Question", color: "#3366FF" },    # Azul
  { name: "Enhancement", color: "#00B19D" }  # Celeste/Teal
].each do |t|
  type = IssueType.find_or_initialize_by(name: t[:name])
  type.color = t[:color]
  type.save!
end

# 4. SEVERITIES (Severidades)
[
  { name: "Wishlist", color: "#999999" },    # Gris
  { name: "Minor", color: "#3366FF" },       # Azul
  { name: "Normal", color: "#A8E43D" },      # Verde
  { name: "Important", color: "#F57900" },   # Naranja
  { name: "Critical", color: "#E44057" }     # Rojo
].each do |sev|
  severity = Severity.find_or_initialize_by(name: sev[:name])
  severity.color = sev[:color]
  severity.save!
end

# 5. PRIORITIES (Prioridades)
[
  { name: "Low", color: "#A8E43D" },         # Verde claro
  { name: "Normal", color: "#FFCC00" },      # Amarillo
  { name: "High", color: "#FF6600" }         # Naranja fuerte
].each do |p|
  priority = Priority.find_or_initialize_by(name: p[:name])
  priority.color = p[:color]
  priority.save!
end

# 6. TAGS (Etiquetas predeterminadas)
[
  { name: "Frontend", color: "#3366FF" },   # Azul
  { name: "Backend", color: "#A8E43D" },    # Verde
  { name: "Design", color: "#999999" },     # Gris
  { name: "Urgent", color: "#E44057" },     # Rojo
  { name: "Documentation", color: "#00B19D"}# Celeste
].each do |t|
  tag = Tag.find_or_initialize_by(name: t[:name])
  tag.color = t[:color]
  tag.save!
end


puts "¡Seeds cargados con éxito!"