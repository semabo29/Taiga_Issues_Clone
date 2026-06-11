<div align="center">
  <h1>ASW Taiga Issue Tracker</h1>
  <p><em>Aplicació web per a la gestió i seguiment d'incidències inspirada en Taiga.</em></p>

  <p>
    💬 <b>Català</b> | <a href="README.en.md">🌍 English</a>
  </p>

  <img src="https://img.shields.io/badge/Ruby-CC342D?style=flat-square&logo=ruby&logoColor=white" alt="Ruby" />
  <img src="https://img.shields.io/badge/Rails-CC0000?style=flat-square&logo=ruby-on-rails&logoColor=white" alt="Rails" />
  <img src="https://img.shields.io/badge/PostgreSQL-316192?style=flat-square&logo=postgresql&logoColor=white" alt="Postgres" />
  <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white" alt="Docker" />
  <img src="https://img.shields.io/badge/Render-46E3B7?style=flat-square&logo=render&logoColor=white" alt="Render" />
</div>

<br />

Projecte desenvolupat per a l'assignatura d'Aplicacions i Serveis Web (ASW) a la Universitat Politècnica de Catalunya (UPC). Aquest projecte replica les funcionalitats core d'un Issue Tracker profesional, implementant una API RESTful robusta i una arquitectura escalable.

🌍 **Entorn de Producció:** [Taiga App (Render)](https://taiga-app.onrender.com) *(Nota: El servidor pot trigar uns segons a arrencar per les polítiques del tier gratuït).* 

🌲 **Organització:** [Organització del projecte a Taiga](https://tree.taiga.io/project/victorsalinasmontanuy-asw2526q2-it212)

---

## ✨ Demostració del Projecte

En el següent vídeo (1:30 min) es mostra el flux principal complet de l'aplicació:

https://github.com/user-attachments/assets/1831e4b5-19a0-4d83-a993-08b70420b00b

*(Nota: Funcionalitats com Visualitzar Perfil o Bulk Insert entre altres queden fora del Flux Principal del projecte pero estàn implementades).*

En la següent imatge es pot apreciar la visualització d'un Perfil que no es el nostre:

<img src="https://github.com/user-attachments/assets/3bad8143-0b86-4692-b960-77dc38f6c3ec" alt="Perfil" width="800" />

---

## 🚀 Funcionalitats del Projecte

L'aplicació replica el nucli d'un Issue Tracker estil Taiga, adaptat amb regles de negoci específiques per a l'assignatura. Les característiques estan dividides en tres blocs principals:

### 1. Gestió d'Issues (Incidències)
*   **Cicle de vida complet:** Creació, visualització, edició i esborrat d'issues. Per seguretat, **només el creador** de la incidència té permisos per editar-la o eliminar-la.
*   **Assignació directa:** Selector directe integrat a la vista per assignar de manera immediata una issue a qualsevol membre de l'equip.
*   **File Attachments (Fitxers adjunts):** Pujada de fitxers mitjançant un botó d'acció directa i llistat senzill associat a la incidència. Només el creador de l'atttachment el pot eliminar (emmagatzemats de forma persistent a un **Bucket S3 d'AWS** via Active Storage).
*   **Comentaris i Activitat:** Sistema de discussió integrat (afegir, llistar, editar i esborrar comentaris, restringit al seu autor). Inclou un **historial d'Activities** cronològic per a cada issue.
*   **Cerca i Filtratge Avançat:**
    *   Filtres de tipus "include" per acotar els llistats.
    *   Cerca textual sobre els camps *Subject* (Assumpte) i *Description* que s'executa sota demanda en prémer el botó de cerca.
*   **Bulk Insert:** Funcionalitat per a la creació massiva d'issues de cop per agilitzar la feina.
*   **Deadlines i Watchers:** Control de dates límit (afegir, visualitzar i eliminar terminis) i sistema de subscripció (Watch/Unwatch) per seguir incidències.

### 2. Control d'Usuaris i Perfils
*   **Autenticació Externa (Social Login):** Sistema de registre i login unificat a través de **Google OAuth2**. El compte d'usuari es crea automàticament a la base de dades en fer el primer "Sign In".
*   **Pàgines de Perfil Públiques:** Qualsevol usuari pot visitar el perfil d'un altre membre, on es renderitzen tres pestanyes dinàmiques:
    *   **Open Assigned Issues:** Incidències obertes assignades a l'usuari (ordenables per *type*, *severity*, *issue #*, *status* i *modified*).
    *   **Watched Issues:** Llistat de les incidències que l'usuari està seguint (visible **únicament** si el perfil correspon a l'usuari loguejat actualment).
    *   **Comments:** Historial de comentaris realitzats, ordenats de més recents a menys. Inclouen enllaços directes amb ancoratge (anchor) que et porten exactament a la posició del comentari dins de l'issue, així com botons d'edició ràpida.
*   **Edició del Perfil:** L'usuari pot personalitzar la seva biografia i la seva imatge de perfil (Avatar), la qual es gestiona també directament a l'emmagatzematge al núvol.

### 3. Configuració del Projecte (Settings)
*   Panell d'administració centralitzat de l'entorn de treball on es permet llistar, crear, modificar i eliminar els camps mestres i atributs globals del projecte:
    *   *Statuses* (Estats de les incidències)
    *   *Priorities* (Prioritats)
    *   *Types* (Tipus)
    *   *Severities* (Severitats)
    *   *Tags* (Etiquetes)
    *   *Due dates*

---

## 🔌 API REST (Segon Lliurament)

El projecte inclou una API REST de Nivell 2 (Richardson Maturity Model) per gestionar les incidències, usuaris, comentaris i fitxers adjunts.

* **Documentació (OpenAPI):** Podeu trobar l'especificació completa al fitxer `/api/api.yml`.
* **Com provar-la:**
    
    1. Aneu a [Swagger Editor](https://editor.swagger.io/) i carregueu el nostre fitxer `api.yml`.
    
    2. Registreu-vos o feu login a la nostra [App a Render](https://taiga-app.onrender.com).
    
    3. Aneu al vostre Perfil per copiar la vostra **API Key**.
    
    4. A Swagger, feu clic a "Authorize" i enganxeu-hi la clau al header per començar a fer peticions.

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
git clone https://github.com/semabo29/Taiga_Clone_Project.git
cd Taiga_Clone_Project

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
