# Stock API

REST API สำหรับจัดการสินค้าคงคลัง สร้างด้วย Ruby on Rails 7 ตาม Layer Architecture

## Architecture
Request → Middleware → Controller → Service → Repository → Database
↓
Form Object (validate input)
↓
Policy (authorize)
↓
Serializer (format output)

### Layer ทั้งหมด

| Layer | ไฟล์ | หน้าที่ |
|-------|------|---------|
| Presentation | controllers, serializers, middleware | รับ/ส่ง HTTP |
| Application | services, policies, form_objects | Business logic |
| Domain | models, enums, value_objects, interfaces | กฎธุรกิจ |
| Infrastructure | repositories, jobs, migrations | Database, Background jobs |

## Requirements

- Ruby 3.2.2
- Rails 7.0
- PostgreSQL 15
- Docker + Docker Compose

## Quick Start (Docker)
```bash
# 1. Clone และตั้งค่า
git clone <repo-url>
cd stock_api
cp .env.example .env

# 2. แก้ไข .env ใส่ค่าจริง
SECRET_KEY_BASE=your_secret_here
JWT_SECRET=your_jwt_secret_here

# 3. รัน
docker compose up --build

# 4. ทดสอบ
curl http://localhost:3000/health
```

## Local Development
```bash
# ติดตั้ง dependencies
bundle install

# ตั้งค่า database
rails db:create db:migrate

# รัน server
rails s

# รัน tests
bundle exec rspec --format documentation
```

## API Endpoints

### Authentication
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | /api/v1/auth/register | สมัครสมาชิก | ไม่ต้อง |
| POST | /api/v1/auth/login | เข้าสู่ระบบ | ไม่ต้อง |
| GET | /api/v1/auth/me | ดูข้อมูลตัวเอง | ต้อง |

### Products
| Method | Endpoint | Description | Role |
|--------|----------|-------------|------|
| GET | /api/v1/products | รายการสินค้า | admin, staff |
| GET | /api/v1/products/:id | ดูสินค้าชิ้นเดียว | admin, staff |
| POST | /api/v1/products | สร้างสินค้า | admin, staff |
| PATCH | /api/v1/products/:id | แก้ไขสินค้า | admin, staff |
| DELETE | /api/v1/products/:id | ลบสินค้า | admin เท่านั้น |

### System
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /health | Health check |
| GET | /api-docs | Swagger UI |

## Authentication

ใช้ JWT Bearer Token:
```bash
# Login
TOKEN=$(curl -s -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@test.com","password":"123456"}' \
  | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

# ใช้ token
curl http://localhost:3000/api/v1/products \
  -H "Authorization: Bearer $TOKEN"
```

## Security

- **JWT Authentication** — ทุก endpoint ต้องมี token ยกเว้น login/register
- **Role Authorization** — admin และ staff มีสิทธิ์ต่างกัน
- **Rate Limiting** — login จำกัด 5 ครั้ง/นาที ต่อ IP
- **Input Validation** — Form Objects ตรวจข้อมูลก่อนเข้า Service
- **Strong Parameters** — ป้องกัน mass assignment

## Testing
```bash
# รัน test ทั้งหมด
bundle exec rspec --format documentation

# รันแค่ unit tests
bundle exec rspec spec/services spec/policies spec/form_objects

# รันแค่ request specs
bundle exec rspec spec/requests
```

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| DATABASE_URL | PostgreSQL connection URL | ✅ |
| SECRET_KEY_BASE | Rails secret key | ✅ |
| JWT_SECRET | JWT signing secret | ✅ |
| RAILS_ENV | Environment (development/production) | ✅ |

## Roles

| Role | สร้างสินค้า | แก้ไขสินค้า | ลบสินค้า |
|------|------------|------------|---------|
| admin | ✅ | ✅ | ✅ |
| staff | ✅ | ✅ | ❌ |
