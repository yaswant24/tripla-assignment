from fastapi import FastAPI
from pydantic import BaseModel
from pathlib import Path

app = FastAPI()

OUTPUT_DIR = Path("output")
OUTPUT_DIR.mkdir(exist_ok=True)

class Properties(BaseModel):
    aws_region: str
    acl: str
    bucket_name: str

class Payload(BaseModel):
    properties: Properties

class RequestBody(BaseModel):
    payload: Payload


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/generate")
def generate_tf(body: RequestBody):

    props = body.payload.properties

    terraform_content = f"""
provider "aws" {{
  region = "{props.aws_region}"
}}

resource "aws_s3_bucket" "this" {{
  bucket = "{props.bucket_name}"
}}

resource "aws_s3_bucket_acl" "this" {{
  bucket = aws_s3_bucket.this.id
  acl    = "{props.acl}"
}}
"""

    file_path = OUTPUT_DIR / "generated.tf"
    file_path.write_text(terraform_content)

    return {
        "message": "Terraform file generated",
        "file": str(file_path)
    }
