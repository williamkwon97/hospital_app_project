# beginning of Models.py
# note that at this point you should have created "quickbev" database (see install_postgres.txt).
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import CheckConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
import os
from sqlalchemy.schema import DropTable
from sqlalchemy.ext.compiler import compiles
from datetime import date
from base64 import b64encode

# https://stackoverflow.com/questions/38678336/sqlalchemy-how-to-implement-drop-table-cascade
@compiles(DropTable, "postgresql")
def _compile_drop_table(element, compiler, **kwargs):
    return compiler.visit_drop_table(element) + " CASCADE"

app = Flask(__name__)
username = os.environ.get("USER", "")
password = os.environ.get("PASSWORD", "")
db_string_beginning = "postgres://"
db_string_end = "@localhost:5432/hospitaldb"
db_string = db_string_beginning + username + ":" + password + db_string_end
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get("DB_STRING", db_string)


app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True # to suppress a warning message
db = SQLAlchemy(app)

class User_Info(db.Model):
    __tablename__ = 'user_info'
    id = db.Column(db.String(80), primary_key = True, unique=True, nullable=False)
    password = db.Column(db.String(80), nullable=False)
    first_name = db.Column(db.String(80), nullable = False)
    last_name = db.Column(db.String(80), nullable = False)

    @property
    def serialize(self):
        return {'id': self.id, 'password' : self.password, 'first_name': self.first_name, 'last_name': self.last_name}

class Administrator(db.Model):
    id = db.Column(db.String(80), primary_key = True, unique=True, nullable=False)
    password = db.Column(db.String(80), nullable=False)
    first_name = db.Column(db.String(80), nullable = False)
    last_name = db.Column(db.String(80), nullable = False)
    hospital = db.Column(db.String(80), db.ForeignKey('hospital.id'), nullable = False)
    image = db.Column(db.LargeBinary, nullable = False)
    employeeID = db.Column(db.String(80), nullable = False)

    @property
    def serialize(self):
        return {'id': self.id, 'password' : self.password, 'first_name': self.first_name, 'last_name': self.last_name, 'employeeID' : self.employeeID, 'hospital' : self.hospital, 'image' : b64encode(self.image).decode('ascii')}

class Hospital(db.Model):
    id = db.Column(db.String(80), primary_key = True, unique=True, nullable=False)
    name = db.Column(db.String(80), nullable = False)
    city = db.Column(db.String(80), nullable = False)
    state = db.Column(db.String(80), nullable = False)
    zipcode =  db.Column(db.String(80), nullable = False)
    street = db.Column(db.String(80), nullable = False)
    date_joined = db.Column(db.Date, nullable = False)
    administrator = relationship('Administrator', lazy = True)

    @property
    def serialize(self):
        return {'id': self.id, 'name': self.name, 'city': self.city, 'state': self.state, 'zipcode': self.zipcode, 'street': self.street, 'date_joined': self.date_joined}

# class Patient(db.Model):
#     id = db.Column(db.String(80), primary_key = True, unique=True, nullable=False)
#     first_name = db.Column(db.String(80), nullable = False)
#     last_name = db.Column(db.String(80), nullable = False)
#     room_number = db.Column(db.String(80), nullable = False)
#     birthday = db.Column(db.String(80), nullable = False)
#     phone_number = db.Column(db.String(80), nullable = False)
#     email_address = db.Column(db.String(80), nullable = False)

#     @property
#     def serialize(self):
#         return {'id': self.id, 'first_name': self.first_name, 'last_name': self.last_name}

class Patient_Request(db.Model):
    __tablename__ = 'patient_request'
    id = db.Column(UUID(as_uuid=True), primary_key = True, unique=True, nullable=False)
    designated_pickup = db.Column(db.String(80), db.ForeignKey('user_info.id'), nullable = False)
    hospital = db.Column(db.String(80), db.ForeignKey('hospital.id'), nullable = False)
    administrator = db.Column(db.String(80), db.ForeignKey('administrator.id'), nullable = True)
    first_name = db.Column(db.String(80), nullable = False)
    last_name = db.Column(db.String(80), nullable = False)
    room_number = db.Column(db.String(80), nullable = False)
    birthday = db.Column(db.String(80), nullable = False)
    phone_number = db.Column(db.String(80), nullable = False)
    email_address = db.Column(db.String(80), nullable = False)
    date = db.Column(db.Date, nullable = False)
    status = db.Column(db.String(80), nullable = False)
    administrator_message = db.Column(db.String(80), nullable = True)
    __table_args__ = (CheckConstraint(status.in_(["created", "accepted", "rejected"])), )

    @property
    def serialize(self):
        return {'id' : self.id, 'designated_pickup': self.designated_pickup,'hospital': self.hospital, 'administrator': self.administrator, 'first_name': self.first_name, 'last_name': self.last_name, 'room_number': self.room_number,'birthday': self.birthday,'phone_number': self.phone_number,'email_address': self.email_address, 'date': self.date, 'status' : self.status, 'administrator_message' : self.administrator_message}
    
