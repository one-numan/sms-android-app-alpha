import sys
import json
import urllib.request

BASE_URL = 'http://127.0.0.1:8000/api/v1'

def login(username, password):
    req = urllib.request.Request(
        f'{BASE_URL}/auth/login/',
        data=json.dumps({'username': username, 'password': password}).encode('utf-8'),
        headers={'Content-Type': 'application/json'}
    )
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read().decode('utf-8'))
        return data.get('access')

def get_api(endpoint, token):
    req = urllib.request.Request(f'{BASE_URL}{endpoint}')
    req.add_header('Authorization', f'Bearer {token}')
    with urllib.request.urlopen(req) as resp:
        return resp.status, json.loads(resp.read().decode('utf-8'))

print("=== STEP 1: AUTHENTICATE TEST ACCOUNTS ===")
token_stu = login('demostudent', 'demo12345')
token_admin = login('admin', 'admin12345')
print("Student Token:", token_stu[:20] + "...")
print("Admin Token:", token_admin[:20] + "...")

print("\n=== STEP 2: PRE-CHANGE API BASELINE ===")
st, hub_orig = get_api('/student/hub/', token_stu)
print("[API] GET /student/hub/ ->", hub_orig['data']['student_name'])

st, ann_orig = get_api('/announcements/', token_admin)
print("[API] GET /announcements/ -> count =", ann_orig.get('count', len(ann_orig.get('results', []))))

st, att_orig = get_api('/attendance/student/', token_stu)
print("[API] GET /attendance/student/ -> present =", att_orig['data']['present_days'], "absent =", att_orig['data']['absent_days'])

st, fee_orig = get_api('/fees/ledger/', token_stu)
print("[API] GET /fees/ledger/ -> total_fee =", fee_orig['data']['total_fee'], "outstanding =", fee_orig['data']['outstanding_amount'])
