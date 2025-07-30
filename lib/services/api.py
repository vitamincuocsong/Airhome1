from flask import Flask, request, jsonify
import joblib

model = joblib.load("predict_model.pkl")
app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    X = [[data['temp'], data['hum'], data['co2']]]
    y_pred = model.predict(X)
    return jsonify({"temp_next": y_pred[0][0], "hum_next": y_pred[0][1]})
