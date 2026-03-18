from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Secure CI/CD Pipeline Running"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
