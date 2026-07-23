# 1. Image de base Python ultra-légère
FROM python:3.11-slim

# 2. Variable d'environnement pour éviter que Python ne mette les sorties en tampon
ENV PYTHONUNBUFFERED=1 \
    PORT=8080

# 3. Répertoire de travail dans le conteneur
WORKDIR /app

# 4. Copie et installation des dépendances en premier (pour optimiser le cache)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copie du reste du code source
COPY . .

# 6. Création d'un utilisateur non-root pour la sécurité
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# 7. Exposition du port réseau
EXPOSE 8080

# 8. Commande de démarrage avec Gunicorn (serveur Web de production)
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "main:app"]
