import json


def test_index(app, client):
    res = client.get('/')
    assert res.status_code == 200
    expected = 'used for health check'
    assert expected in json.loads(res.get_data(as_text=True))['message']
