from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Configuración de la base de datos (reemplaza con tu información)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:root@localhost/MYHOME'

# Inicializa la extensión de SQLAlchemy
db = SQLAlchemy(app)

class Persona(db.Model):
    __tablename__ = 'persona'

    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(50))
    apellido = db.Column(db.String(50))
    fecha_nacimiento = db.Column(db.Date)

@app.route('/personas')
def listar_personas():
    personas = Persona.query.all()
    return render_template('lista_personas.html', personas=personas)

@app.route('/')
def index():
    return render_template('index.html')


if __name__ == '__main__':
    app.run()
