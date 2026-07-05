import os
from pathlib import Path

import joblib
import pandas as pd
import requests

# ======================================================
# Configuration
# ======================================================

BASE_DIR = Path(__file__).resolve().parent

STACK_MODEL = BASE_DIR / "congen-ai" / "models" / "stacking_lifespan.pkl"
BAGGING_MODEL = BASE_DIR / "congen-ai" / "models" / "bagging_rf_lifespan.pkl"

GPT5_API = os.getenv(
    "GPT5_API",
    "http://127.0.0.1:8000/complete"
)

REQUEST_TIMEOUT = 30


# ======================================================
# Load Models
# ======================================================

def load_models():
    """Load trained ML models."""

    if not STACK_MODEL.exists():
        raise FileNotFoundError(f"Missing model: {STACK_MODEL}")

    if not BAGGING_MODEL.exists():
        raise FileNotFoundError(f"Missing model: {BAGGING_MODEL}")

    stack = joblib.load(STACK_MODEL)
    bagging = joblib.load(BAGGING_MODEL)

    return stack, bagging


# ======================================================
# Example Input
# ======================================================

def build_example():
    return pd.DataFrame([
        {
            "age": 45,
            "smoking": 1,
            "exercise": 3,
            "diet_score": 7,
            "income": 50000
        }
    ])


# ======================================================
# Prediction
# ======================================================

def predict(models, data):
    stack_model, bagging_model = models

    stack_prediction = float(stack_model.predict(data)[0])
    bagging_prediction = float(bagging_model.predict(data)[0])

    return stack_prediction, bagging_prediction


# ======================================================
# GPT Explanation
# ======================================================

def explain(stack_pred, bagging_pred):

    prompt = f"""
You are GPT-5 Mini.

Two machine-learning models estimated the person's lifespan.

Predictions

• Stacking Model: {stack_pred:.2f} years
• Bagging Random Forest: {bagging_pred:.2f} years

Explain:

1. What these predictions mean.
2. Why two models may produce different values.
3. That these are statistical estimates rather than guarantees.
4. Recommend healthy lifestyle improvements.

Use simple language.
"""

    response = requests.post(
        GPT5_API,
        json={
            "prompt": prompt,
            "max_tokens": 300
        },
        timeout=REQUEST_TIMEOUT
    )

    response.raise_for_status()

    return response.json()["completion"]


# ======================================================
# Main
# ======================================================

def main():

    models = load_models()

    sample = build_example()

    stack_pred, bagging_pred = predict(models, sample)

    print("\nModel Predictions")
    print("-----------------")
    print(f"Stacking : {stack_pred:.2f} years")
    print(f"Bagging  : {bagging_pred:.2f} years")

    print("\nGenerating explanation...\n")

    explanation = explain(stack_pred, bagging_pred)

    print(explanation)


if __name__ == "__main__":
    try:
        main()
    except requests.RequestException as e:
        print("API request failed:", e)
    except Exception as e:
        print("Error:", e)
