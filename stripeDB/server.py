
from distutils.log import error
import json
import os
import stripe
from flask import request

stripe.api_key = 'YOURSECRETAPIKEY'

from flask import Flask, render_template, jsonify, request


app = Flask(__name__, static_folder='public',
            static_url_path='', template_folder='public')

@app.route('/payment', methods=['POST'])
def payment_sheet():
  #Payment Intent erstellen
    price = 100 * (request.json["price"])
    #Der Price wird vom Client als Float übergeben. Der Client über beispielsweise die Zahl 89.99.
    #Damit der richtige Preis an Stripe übertragen wird muss die Zahl mit 100 multipliziert werden, da Stripe nur Cent Beträge übernimmt.
    # Für den Preis 89.99$ müsste man 8999.00 an Stripe übergeben. 
    paymentIntent = stripe.PaymentIntent.create(
    
        amount=int(price),
        currency='eur',
        automatic_payment_methods={
            'enabled': True,
        },
    )
    return jsonify(paymentIntent=paymentIntent.client_secret,
                    publishableKey='YOURPUBLISHABLEAPIKEY')





@app.route("/cancel-payment/<secret>", methods=["POST"])
def cancel(secret):
    try:
        stripe.PaymentIntent.cancel(secret)
    except Exception as err:
        print(err)
        return "failure"
        
    return "success"

if __name__ == '__main__':
    app.run(port=5000)