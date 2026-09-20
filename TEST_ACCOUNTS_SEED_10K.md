# Test Accounts — seeded demo dataset

Source: `apps/core/management/commands/seed_10k.py` (base dataset: students, teachers, classes,
Principal/VP) **plus** `apps/core/management/commands/seed_connected.py` (backfills student
logins, parents, and extra staff on top of it). Run in that order:

```
python manage.py seed_10k
python manage.py seed_connected
```

All rows below were pulled directly from a local `db.sqlite3` that has both commands already run
against it — not guessed or replayed from source. **Do not use any of this for production** — it's
synthetic QA/demo data only.

## Students (50 of 10,000 — usernames only, passwords withheld)

Login pattern (from `apps.students.services.generate_student_username` /
`generate_student_password`, invoked by `seed_connected.py`'s `_backfill_student_logins`):
**username = firstname + surname + DOB (`ddmmyy`)**, **password = that student's actual date of
birth, formatted `ddmmyyyy`**. Unlike every other role below, this is a *real per-student
credential* derived from data modeled as belonging to a minor — not a shared placeholder — so
passwords are intentionally left out of this file. Anyone with DB/admin access can recompute a
given student's password directly from their `date_of_birth` field.

| # | Username | Student Name |
|---|----------|--------------|
| 1 | `demostudent` | Bushra Verified Malik Live *(manually-created demo row, not from either seed script)* |
| 2 | `remylebeau121122` | Remy LeBeau |
| 3 | `billybatson270922` | Billy Batson |
| 4 | `bobbydrake201222` | Bobby Drake |
| 5 | `kendrasaunders050122` | Kendra Saunders |
| 6 | `ririwilliams170522` | Riri Williams |
| 7 | `stephaniebrown090222` | Stephanie Brown |
| 8 | `barryallen130222` | Barry Allen |
| 9 | `ririwilliams241222` | Riri Williams |
| 10 | `sultanagrabah081022` | Sultan Agrabah |
| 11 | `sultanagrabah021122` | Sultan Agrabah |
| 12 | `wadewilson240222` | Wade Wilson |
| 13 | `nidabhatti170222` | Nida Bhatti |
| 14 | `kinzarehman121022` | Kinza Rehman |
| 15 | `kurtwagner080122` | Kurt Wagner |
| 16 | `peterquill070222` | Peter Quill |
| 17 | `erikkillmonger181122` | Erik Killmonger |
| 18 | `zarabaig110522` | Zara Baig |
| 19 | `kamalakhan201122` | Kamala Khan |
| 20 | `charlesxavier091222` | Charles Xavier |
| 21 | `andersagrabah221222` | Anders Agrabah |
| 22 | `timdrake170922` | Tim Drake |
| 23 | `alfredpennyworth100322` | Alfred Pennyworth |
| 24 | `kittypryde080822` | Kitty Pryde |
| 25 | `alibaig080422` | Ali Baig |
| 26 | `oliverqueen230322` | Oliver Queen |
| 27 | `katekane280522` | Kate Kane |
| 28 | `selinakyle220222` | Selina Kyle |
| 29 | `jasmineagrabah020222` | Jasmine Agrabah |
| 30 | `mariahill040122` | Maria Hill |
| 31 | `asmarizvi230522` | Asma Rizvi |
| 32 | `bushrafarooqi180922` | Bushra Farooqi |
| 33 | `jamesgordon011022` | James Gordon |
| 34 | `harleenquinzel131022` | Harleen Quinzel |
| 35 | `rayyanraza160222` | Rayyan Raza |
| 36 | `asmarehman190722` | Asma Rehman |
| 37 | `garfieldlogan180422` | Garfield Logan |
| 38 | `mishalmirza111122` | Mishal Mirza |
| 39 | `ririwilliams080622` | Riri Williams |
| 40 | `daliaagrabah071222` | Dalia Agrabah |
| 41 | `arhamraza181122` | Arham Raza |
| 42 | `stephaniebrown270622` | Stephanie Brown |
| 43 | `wallywest261022` | Wally West |
| 44 | `johnstewart171222` | John Stewart |
| 45 | `piotrrasputin150622` | Piotr Rasputin |
| 46 | `jubilationlee060622` | Jubilation Lee |
| 47 | `yelenabelova220422` | Yelena Belova |
| 48 | `wallywest051022` | Wally West |
| 49 | `nidaiqbal151022` | Nida Iqbal |
| 50 | `noorjaved170222` | Noor Javed |

## Teachers (50 of ~65 total, shared password: `teacher12345`)

Verified against the live DB (`home_teacher` join `auth_user`) — names match exactly what
`seed_10k.py`'s fixed RNG seed produces.

| # | Username | Name |
|---|----------|------|
| 1 | `washingtonsundar` | Washington Sundar |
| 2 | `shubmangill` | Shubman Gill |
| 3 | `souravganguly` | Sourav Ganguly |
| 4 | `gautamgambhir` | Gautam Gambhir |
| 5 | `shikhapandey` | Shikha Pandey |
| 6 | `anujapatil` | Anuja Patil |
| 7 | `renukasingh` | Renuka Singh |
| 8 | `minnumani` | Minnu Mani |
| 9 | `rahuldravid` | Rahul Dravid |
| 10 | `ishantsharma` | Ishant Sharma |
| 11 | `harbhajansingh` | Harbhajan Singh |
| 12 | `dineshkarthik` | Dinesh Karthik |
| 13 | `klrahul` | KL Rahul |
| 14 | `hardikpandya` | Hardik Pandya |
| 15 | `deepakchahar` | Deepak Chahar |
| 16 | `manishpandey` | Manish Pandey |
| 17 | `jhulangoswami` | Jhulan Goswami |
| 18 | `sunilgavaskar` | Sunil Gavaskar |
| 19 | `shikhardhawan` | Shikhar Dhawan |
| 20 | `mithaliraj` | Mithali Raj |
| 21 | `shafaliverma` | Shafali Verma |
| 22 | `jaspritbumrah` | Jasprit Bumrah |
| 23 | `radhayadav` | Radha Yadav |
| 24 | `mahendrasinghdhoni` | Mahendra Singh Dhoni |
| 25 | `jemimahrodrigues` | Jemimah Rodrigues |
| 26 | `vedakrishnamurthy` | Veda Krishnamurthy |
| 27 | `ajinkyarahane` | Ajinkya Rahane |
| 28 | `axarpatel` | Axar Patel |
| 29 | `anilkumble` | Anil Kumble |
| 30 | `poonamyadav` | Poonam Yadav |
| 31 | `prithvishaw` | Prithvi Shaw |
| 32 | `shreyasiyer` | Shreyas Iyer |
| 33 | `punamraut` | Punam Raut |
| 34 | `snehrana` | Sneh Rana |
| 35 | `kuldeepyadav` | Kuldeep Yadav |
| 36 | `meghnasingh` | Meghna Singh |
| 37 | `zaheerkhan` | Zaheer Khan |
| 38 | `ravindrajadeja` | Ravindra Jadeja |
| 39 | `titassadhu` | Titas Sadhu |
| 40 | `bhuvneshwarkumar` | Bhuvneshwar Kumar |
| 41 | `navdeepsaini` | Navdeep Saini |
| 42 | `yuvrajsingh` | Yuvraj Singh |
| 43 | `kirannavgire` | Kiran Navgire |
| 44 | `amanjotkaur` | Amanjot Kaur |
| 45 | `taniyabhatia` | Taniya Bhatia |
| 46 | `simranbahadur` | Simran Bahadur |
| 47 | `richaghosh` | Richa Ghosh |
| 48 | `umeshyadav` | Umesh Yadav |
| 49 | `poojavastrakar` | Pooja Vastrakar |
| 50 | `arundhatireddy` | Arundhati Reddy |

The remaining ~15 teachers (same cricket-squad name pool) also use `teacher12345`.

## Parents (20 of ~10,000, shared password: `parent12345`)

From `seed_connected.py` (Bollywood actor name pool). Pulled from `parents_parent` join `auth_user`.

| # | Username | Name |
|---|----------|------|
| 1 | `demoparent` | Demo Parent *(manually-created demo row)* |
| 2 | `nawazuddinsiddiqui` | Nawazuddin Siddiqui |
| 3 | `madhuridixit` | Madhuri Dixit |
| 4 | `ranveersingh` | Ranveer Singh |
| 5 | `kareenakapoor` | Kareena Kapoor |
| 6 | `ajaydevgn` | Ajay Devgn |
| 7 | `vidyabalan` | Vidya Balan |
| 8 | `saifalikhan` | Saif Ali Khan |
| 9 | `ranimukerji` | Rani Mukerji |
| 10 | `tigershroff` | Tiger Shroff |
| 11 | `kiaraadvani` | Kiara Advani |
| 12 | `akshaykumar` | Akshay Kumar |
| 13 | `katrinakaif` | Katrina Kaif |
| 14 | `manojbajpayee` | Manoj Bajpayee |
| 15 | `salmankhan` | Salman Khan |
| 16 | `kartikaaryan` | Kartik Aaryan |
| 17 | `aliabhatt` | Alia Bhatt |
| 18 | `amitabhbachchan` | Amitabh Bachchan |
| 19 | `kritisanon` | Kriti Sanon |
| 20 | `randeephooda` | Randeep Hooda |

## Staff (all 8 — this is the full set, not a sample)

| Role | Username | Password | Name |
|------|----------|----------|------|
| Principal | `principal.numan` | `principal12345` | Mohd Numan |
| Vice Principal | `viceprincipal.tendulkar` | `viceprincipal12345` | Sachin Tendulkar |
| Accountant | `accountantpriyamenon` | `staff12345` | Priya Menon |
| Accountant | `accountantravikulkarni` | `staff12345` | Ravi Kulkarni |
| Receptionist | `receptionistaditirao` | `staff12345` | Aditi Rao |
| Receptionist | `receptionistfarhansheikh` | `staff12345` | Farhan Sheikh |
| Librarian | `librarianmanojbhatt` | `staff12345` | Manoj Bhatt |
| Librarian | `librariansanaiqbal` | `staff12345` | Sana Iqbal |

Principal/VP passwords are set directly in `seed_10k.py`; the other 6 staff use `staff12345` from
`seed_connected.py`.

## Notes

- All usernames/names above were read directly from the local `db.sqlite3` (10,000 students, 255
  teacher rows total, 8 staff, thousands of parents) — this is real seeded data, not fabricated or
  replayed from source.
- Student passwords are deliberately omitted (see Students section) — they're real per-student
  DOB-derived credentials, not shared placeholders, so they're not bulk-dumped into this file.
- Everything else uses a shared, hardcoded password from its seed script — fine for local QA, not
  for anything internet-facing.
