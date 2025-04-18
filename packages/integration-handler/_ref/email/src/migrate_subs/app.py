from flask import Flask, render_template, request, redirect, url_for
from search_subs import list_unsubable_senders, setup_gmail_service

app = Flask(__name__)

@app.route('/')
def index(service=setup_gmail_service()):
    unsubscribe_senders = list_unsubable_senders(service)
    return render_template('unsub.html', senders=set(unsubscribe_senders))

@app.route('/redirect', methods=['POST'])
def redirect_emails():
    selected_senders = request.form.getlist('senders')
    proxy_email = "clerk@feedup.today"
    # Here you can implement the logic to redirect emails to the proxy email address
    # For now, we will just print the selected senders
    print("Redirecting emails from the following senders to", proxy_email)
    for sender in selected_senders:
        print(sender)
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)