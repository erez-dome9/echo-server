from flask import request, url_for
from flask_api import FlaskAPI, status, exceptions


app = FlaskAPI(__name__)


@app.route("/", methods=['GET'])
def hello_world():

    """

    List or create notes.

    """

    if request.method == 'GET':

        return "Hello World v3"


if __name__ == "__main__":

    # HAD TO ADD host='0.0.0.0'!
    app.run(debug=True, host='0.0.0.0', port=5000)
