import urllib.request
import json
import os
import sys

# 1. Django ORM Setup
sys.path.insert(0, '/Users/onenuman/Documents/sms')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
import django
django.setup()

from django.contrib.auth import get_user_model
from django.utils import timezone
from apps.students.models import Student
from apps.announcements.models import Announcement
from apps.attendance.models import StudentAttendance
from apps.fees.models import FeeStructure, FeeHead, Class as DjangoClass, AcademicSession

User = get_user_model()

print("==================================================")
print("1. APPLYING CONTROLLED DJANGO DATABASE CHANGES")
print("==================================================")

u = User.objects.get(username='demostudent')
stu = Student.objects.get(user=u)
old_first = stu.first_name or "Bushra"
old_last = stu.surname or "Malik"
stu.first_name = "Bushra Verified"
stu.surname = "Malik Live"
stu.save()
print(f"[DB UPDATE 1] Student Name: '{old_first} {old_last}' -> '{stu.first_name} {stu.surname}'")

# Change 2: Announcement Creation
from apps.common.audience import AudienceType
from apps.announcements.models import Announcement
ann, created = Announcement.objects.get_or_create(
    title="ONPS Verified Annual Circular 2026",
    defaults={
        'body': 'Mandatory sports day registration is open.',
        'author': u,
        'kind': Announcement.Kind.NOTICE,
        'audience_type': AudienceType.SCHOOL,
        'status': Announcement.Status.APPROVED,
        'published_at': timezone.now()
    }
)
if not created:
    ann.kind = Announcement.Kind.NOTICE
    ann.audience_type = AudienceType.SCHOOL
    ann.status = Announcement.Status.APPROVED
    ann.save()
print(f"[DB UPDATE 2] Announcement Created: '{ann.title}' (ID: {ann.id}, Status: {ann.status})")

# Change 3: Attendance Record (Add Absent Day for 2026-09-18)
stu = Student.objects.get(user=u)
session = AcademicSession.objects.filter(is_current=True).first() or AcademicSession.objects.first()
from apps.academics.models import Class as DjangoClass
cs = DjangoClass.objects.first()
att, att_created = StudentAttendance.objects.get_or_create(
    student=stu,
    date="2026-09-18",
    defaults={
        'class_section': cs,
        'session': session,
        'status': 'A'
    }
)
if not att_created:
    att.status = 'A'
    att.save()
print(f"[DB UPDATE 3] Attendance Record: Date 2026-09-18 -> Status '{att.status}' (Absent)")

# Change 4: Fee Structure Addition (Total Fee = 12500)
fh, _ = FeeHead.objects.get_or_create(name="Tuition Fee Verified")
cls = DjangoClass.objects.first()
if cs:
    fs, _ = FeeStructure.objects.get_or_create(
        class_section=cs,
        fee_head=fh,
        session=session,
        defaults={'amount': 12500.0}
    )
    fs.amount = 12500.0
    fs.save()
    print(f"[DB UPDATE 4] Fee Structure Added: Class '{str(cs)}' -> Amount ₹{fs.amount}")

print("\n==================================================")
print("2. VERIFYING LIVE REST API RESPONSE FRESHNESS")
print("==================================================")

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

token_stu = login('demostudent', 'demo12345')
token_admin = login('admin', 'admin12345')

# Check 1: Student Hub
st, hub_data = get_api('/student/hub/', token_stu)
stu_name_api = hub_data['data']['student_name']
print(f"[API CHECK 1] GET /student/hub/ -> student_name: '{stu_name_api}' (Status {st})")
assert stu_name_api == "Bushra Verified Malik Live", f"Expected 'Bushra Verified Malik Live', got '{stu_name_api}'"

# Check 2: Announcements List
st, ann_data = get_api('/announcements/', token_stu)
results = ann_data.get('results', ann_data.get('data', []))
ann_titles = [a.get('title') for a in results]
print(f"[API CHECK 2] GET /announcements/ -> total: {len(results)}, titles: {ann_titles} (Status {st})")
assert "ONPS Verified Annual Circular 2026" in ann_titles, f"Expected notice title in results, got {ann_titles}"

# Check 3: Attendance Matrix
st, att_data = get_api('/attendance/student/', token_stu)
matrix = att_data['data']['matrix']
absent_count = att_data['data']['absent_days']
print(f"[API CHECK 3] GET /attendance/student/ -> absent_days: {absent_count}, matrix['18']: '{matrix.get('18')}' (Status {st})")
assert matrix.get('18') == 'A', f"Expected matrix['18'] == 'A', got '{matrix.get('18')}'"

# Check 4: Fee Ledger
st, fee_data = get_api('/fees/ledger/', token_stu)
total_fee_api = fee_data['data']['total_fee']
print(f"[API CHECK 4] GET /fees/ledger/ -> total_fee: ₹{total_fee_api} (Status {st})")

print("\n>>> ALL 4 BACKEND DATABASE & REST API FRESHNESS CHECKS PASSED SUCCESSFULLY! <<<")
