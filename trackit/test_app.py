from app import app


def test_health():
    r = app.test_client().get("/health")
    assert r.status_code == 200
    # The health endpoint must return a successful status.
    assert r.get_json()["status"] == "ok"