from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Persona(db.Model):
    __tablename__ = 'persona'

    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(50))
    apellido = db.Column(db.String(50))
    fecha_nacimiento = db.Column(db.Date)
