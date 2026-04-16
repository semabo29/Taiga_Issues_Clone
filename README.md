# ASW Taiga Issue Tracker

Aplicació web per a la gestió i seguiment d'incidències (Issue Tracker) inspirada en Taiga, desenvolupada per a l'assignatura d'Arquitectura de Programari i Web (ASW). 

🌍 **Entorn de Producció (Render):** [https://taiga-app.onrender.com](https://taiga-app.onrender.com)
🌲 **Taiga Oficial (Backlog):** [Projecte a tree.taiga.io](https://tree.taiga.io/project/victorsalinasmontanuy-asw2526q2-it212/backlog)

**Stack:** Ruby on Rails · PostgreSQL · Google OAuth2 · Docker · S3 Active Storage

---

## Requisits previs

| Eina | Versió mínima |
|------|---------------|
| [Ruby](https://www.ruby-lang.org/es/downloads/) | 3.3.6 |
| [Rails](https://rubyonrails.org/) | 7.1.3 |
| SQLite3 | - |
| [Docker](https://www.docker.com/) *(opcional, per a desplegament)* | 24+ |

---

## Instal·lació local

```bash
# 1. Clonar el repositori
git clone [URL_DEL_TEU_REPOSITORI]
cd ASW_Taiga_Project

# 2. Instal·lar dependències
bundle install

# 3. Configurar variables d'entorn
# Crea un fitxer .env a l'arrel del projecte i afegeix les teves credencials 
# d'autenticació (Google) i d'emmagatzematge al núvol (AWS S3):

#   GOOGLE_CLIENT_ID=el_teu_client_id
#   GOOGLE_CLIENT_SECRET=el_teu_client_secret
#
#   AWS_ACCESS_KEY_ID=la_teva_access_key
#   AWS_SECRET_ACCESS_KEY=la_teva_secret_key
#   AWS_SESSION_TOKEN=el_teu_session_token_temporal
#   AWS_REGION=us-east-1
#   AWS_BUCKET=aswtaiga-bucket

# 4. Preparar la base de dades (creació i migracions)
rails db:prepare

# 5. Executar l'aplicació
bin/rails server -b 0.0.0.0

```

---

## Estructura del projecte

```
ASW_Taiga_Project/
├── app/
│   ├── controllers/      # Lògica de negoci i protecció de rutes (ex: authenticate_user!)
│   ├── models/           # Models de dades (Issue, User, Status, Priority, Tags, Comments...)
│   ├── views/            # Vistes dinàmiques (ERB) amb filtrat i llistats
│   └── assets/           # Fulls d'estil i configuració de manifestos
├── config/
│   ├── routes.rb         # Definició d'endpoints HTTP
│   ├── database.yml      # Configuració per SQLite (Local) i PostgreSQL (Producció)
│   └── initializers/     # Configuracions d'arrencada (ex: omniauth.rb per a Google)
├── db/                   # Migracions i fitxer schema.rb
├── Dockerfile            # Recepta de construcció per a l'entorn de producció
└── bin/docker-entrypoint # Script automàtic d'arrencada i migracions al servidor
```

---

## CD

- **CD** (`.github/workflows/cd.yml`): S'executa en fer merge a `main`. El desplegament a producció està totalment automatitzat. S'utilitza el Dockerfile del repositori per construir una imatge optimitzada que s'executa a Render, connectada a una base de dades PostgreSQL.

---

## Tecnologies clau

| Capa | Tecnologia |
|------|-----------|
| Framework Web | Ruby on Rails 7.1.3 |
| Llenguatge | Ruby 3.3.6 |
| BDD (Local) | SQLite3 |
| BDD (Producció) | PostgreSQL |
| Autenticació | Google OAuth2 (OmniAuth) |
| Gestió de Fitxers | Active Storage (AWS S3 ready) |
| Entorn/Contenidors | Docker |
| Hosting | Render |

---

## Equip 

| Nom |
|-----|
| Clàudia Galán Rodoreda |
| Sergi Malaguilla Bombín |
| Adrià Aguilar Garcia |
| Victor Salinas Montanuy |

**Professor:** Quim Motger De La Encarnacion
**Assignatura:** Aplicacions i Serveis Web — Grau en Enginyeria Informàtica (UPC)  
**Convocatòria:** Quadrimestre de Primavera, curs 2025/26
