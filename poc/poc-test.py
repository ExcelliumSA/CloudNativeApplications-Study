import jwt
import requests
from datetime import timezone, datetime, timedelta
from jwt import PyJWKClient

JWKS_URL_PRIVATE_KEY = "https://raw.githubusercontent.com/righettod/toolbox-pentest-web/master/misc/rsa-2048-private.jwks.json"
KID = "d9da12e6-1bdf-4500-84a8-c77e6dd58b76"
BASE_URL = "http://192.168.49.2"
ISSUER = "excellium-ias"


def get_signing_key():
    jwks_client = PyJWKClient(JWKS_URL_PRIVATE_KEY)
    jwks = jwks_client.get_signing_key(KID)
    return jwks.key


def create_jwt(sign_key, issuer, audience, custom_claims=None):
    pld = {"sub": "caller", "data": "dummy", "exp": datetime.now(tz=timezone.utc) + timedelta(seconds=600), "iat": datetime.now(tz=timezone.utc)}
    if issuer is not None:
        pld["iss"] = issuer
    if audience is not None:
        pld["aud"] = audience
    if custom_claims is not None:
        for claim_name in custom_claims:
            pld[claim_name] = custom_claims[claim_name]
    token = jwt.encode(payload=pld, key=sign_key, algorithm="RS256", headers={"kid": KID})
    return token


def send_request(relative_path, token):
    req_headers = {"User-Agent": "PythonTestClient"}
    if token is not None:
        req_headers["Authorization"] = f"Bearer {token}"
    response = requests.get(f"{BASE_URL}/{relative_path}", headers=req_headers, timeout=30)
    return response


def display_result(response):
    code = response.status_code
    content = response.text
    if code == 200:
        content = response.text.split("\n")[0]
    print(f"HTTP {code} => {content}")


print("[+] Load signing key from JWKS")
sign_key = get_signing_key()
print("Loaded.")
print("---")
print("[+] Call app1 without a JWT token")
resp = send_request("app1", None)
display_result(resp)
print("[+] Call app1 with a JWT token having the wrong issuer but the correct audience and signer")
token = create_jwt(sign_key, "RandomISS", "app1")
resp = send_request("app1", token)
display_result(resp)
print("[+] Call app1 with a JWT token having the correct issuer and correct signer but a wrong audience (audience set to app2)")
token = create_jwt(sign_key, ISSUER, "app2")
resp = send_request("app1", token)
display_result(resp)
print("[+] Call app1 with a JWT token having the correct issuer, correct signer and correct audience")
token = create_jwt(sign_key, ISSUER, "app1")
resp = send_request("app1", token)
display_result(resp)
print("---")
print("[+] Call app2 without a JWT token")
resp = send_request("app2", None)
display_result(resp)
print("[+] Call app2 with a JWT token having the correct issuer, correct signer, correct audience but without the ispartner claim")
token = create_jwt(sign_key, ISSUER, "app2")
resp = send_request("app2", token)
display_result(resp)
print("[+] Call app2 with a JWT token having the correct issuer, correct signer, correct audience but with the ispartner claim having a wrong value")
token = create_jwt(sign_key, ISSUER, "app2", {"ispartner": "NO"})
resp = send_request("app2", token)
display_result(resp)
print("[+] Call app2 with a JWT token having the correct issuer, correct signer, correct audience but with the ispartner claim having a correct value using a wrong case")
token = create_jwt(sign_key, ISSUER, "app2", {"ispartner": "YES"})
resp = send_request("app2", token)
display_result(resp)
print("[+] Call app2 with a JWT token having the correct issuer, correct signer, correct audience and correct ispartner claim value")
token = create_jwt(sign_key, ISSUER, "app2", {"ispartner": "Yes"})
resp = send_request("app2", token)
display_result(resp)
