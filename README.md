# README

* Migrar base de dades

rails db:migrate

* Crear usuari per defecte

rails db:seed

* Engegar servidor

bin/rails server -b 0.0.0.0

* Entrar a la consola (per si voleu veure el contingut de la bd)

rails console

Exemples:
Issue.all (veure totes les issues)
User.first (veure l'usuari de prova)
Issue.count (quantes n'hi ha)
exit (per sortir)

ActiveRecord::Base.connection.tables (mirar que tablas (sus nombres) tenemos en la bd)
User.all  (ver todas las intancias de la tabla)
