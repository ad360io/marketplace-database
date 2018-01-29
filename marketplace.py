from datetime import date, datetime
from decimal import Decimal
from pony.orm import *


db = Database()


class User(db.Entity):
    id = PrimaryKey(str, auto=True)


class Contract(db.Entity):
    number = PrimaryKey(int, auto=True)
    name = Required(str)
    advertiser = Required('Advertiser')
    publisher = Required('Publisher')
    start_date = Required(datetime, sql_default='current_timestamp')
    end_date = Required(datetime)
    currency = Required(str)
    payout_cap = Optional(Decimal, default=6)
    invoices = Set('Invoice')
    ad = Required('Ad')
    adspace = Required('Adspace')


class Invoice(db.Entity):
    number = PrimaryKey(int, auto=True)
    contract = Required(Contract)
    date = Required(datetime, sql_default='current_timestamp')
    currency = Required(str)
    amount = Required(Decimal)
    due_date = Required(datetime)
    paid = Required(bool, default='false')
    tx_hash = Required(str)


class Advertiser(User):
    ads = Set('Ad')
    contracts = Set(Contract)


class Publisher(User):
    websites = Set('Website')
    adspaces = Set('Adspace')
    contracts = Set(Contract)


class Website(db.Entity):
    URL = PrimaryKey(str, auto=True)
    publisher = Required(Publisher)
    adspaces = Set('Adspace')


class Listing(db.Entity):
    id = PrimaryKey(str, auto=True)
    name = Required(str, 80)
    description = Required(str, 1024)
    date_added = Required(datetime, sql_default='current_timestamp')
    expiration_date = Optional(date)
    currency = Required(str)
    price = Optional(str)
    type = Required(str)


class Adspace(Listing):
    publisher = Required(Publisher)
    website = Required(Website)
    contracts = Set(Contract)


class Ad(Listing):
    advertiser = Required(Advertiser)
    contracts = Set(Contract)



db.generate_mapping()
