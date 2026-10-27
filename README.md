# E-Waste Management API

> A RESTful backend API for managing electronic waste (e-waste) collection, device evaluation, and credit point rewards.

---

## 📋 Table of Contents

- [About the Project](#about-the-project)
- [Tech Stack](#tech-stack)
- [Database Schema](#database-schema)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [API Reference](#api-reference)
- [Postman Collection](#postman-collection)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

---

## 🌱 About the Project

The **E-Waste Management API** enables users to responsibly recycle their old electronic devices. Users can:

- Browse device **categories**, **brands**, and **models**
- Submit an e-waste **pickup/drop-off order** with device condition photos
- Receive **AI-based device assessment** and earn **credit points** based on device condition
- Track all their past and current orders

---

## 🛠️ Tech Stack

| Layer      | Technology                              |
|------------|-----------------------------------------|
| Runtime    | Node.js                                 |
| Framework  | Express.js                              |
| Database   | MySQL                                   |
| Auth       | JWT (JSON Web Tokens)                   |
| File Upload| Multer                                  |
| AI Service | External AI API (condition assessment)  |

---

## 🗄️ Database Schema

The database consists of **7 tables** across two logical groups:

### Master Tables (reference / admin data)

| Table                    | Description                                      |
|--------------------------|--------------------------------------------------|
| `tbl_master_categories`  | E-waste device categories (e.g., Smartphones)    |
| `tbl_master_brands`      | Device brands under each category                |
| `tbl_master_models`      | Device models with credit point tiers            |
| `tbl_master_conditions`  | Possible device conditions with score weights    |

### Operations Tables (user / transactional data)

| Table                         | Description                                     |
|-------------------------------|-------------------------------------------------|
| `tbl_operations_user`         | Registered app users                            |
| `tbl_operations_order`        | E-waste pickup orders with AI assessment data   |
| `tbl_operations_order_images` | Photos submitted with each order                |

### Entity Relationship

```
tbl_master_categories
    └── tbl_master_brands
            └── tbl_master_models

tbl_master_conditions

tbl_operations_user
    └── tbl_operations_order ──(category, brand, model, condition)
            └── tbl_operations_order_images
```

### Credit Points Logic (`tbl_master_models`)

| Field                  | Condition Range        |
|------------------------|------------------------|
| `credit_points_plus_80`| Score > 80%            |
| `credit_points_plus_50`| Score 51% – 80%        |
| `credit_points_plus_20`| Score 21% – 50%        |
| `credit_points_plus_10`| Score 1% – 20%         |
| `credit_points_less_50`| Score below threshold  |

---

## 🚀 Getting Started

### Prerequisites

- Node.js >= 18.x
- MySQL >= 8.x
- npm or yarn

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/e-waste-api.git
cd e-waste-api

# 2. Install dependencies
npm install

# 3. Set up environment variables
cp .env.example .env
# Edit .env with your database credentials and secrets

# 4. Set up the database
mysql -u root -p < database.sql

# 5. Start the development server
npm run dev
```

The server will start at `http://localhost:3000`.

---

## 🔑 Environment Variables

Copy `.env.example` to `.env` and fill in your values:

| Variable         | Description                          | Example                  |
|------------------|--------------------------------------|--------------------------|
| `PORT`           | Port to run the server on            | `3000`                   |
| `NODE_ENV`       | Environment                          | `development`            |
| `DB_HOST`        | MySQL host                           | `localhost`              |
| `DB_PORT`        | MySQL port                           | `3306`                   |
| `DB_USER`        | MySQL username                       | `root`                   |
| `DB_PASSWORD`    | MySQL password                       | `your_password`          |
| `DB_NAME`        | Database name                        | `ewaste_db`              |
| `JWT_SECRET`     | Secret key for JWT signing           | `your_jwt_secret`        |
| `JWT_EXPIRES_IN` | Token expiry duration                | `7d`                     |
| `UPLOAD_DIR`     | Directory for uploaded images        | `uploads/`               |
| `MAX_FILE_SIZE`  | Max upload size in bytes             | `5242880` (5 MB)         |
| `AI_API_KEY`     | Key for the AI assessment service    | `your_ai_key`            |

---

## 📡 API Reference

### Base URL
```
http://localhost:3000/api
```

---

### 🔐 Authentication

All protected routes require:
```
Authorization: Bearer <token>
```

| Method | Endpoint          | Description         | Auth |
|--------|-------------------|---------------------|------|
| POST   | `/auth/signup`    | Register a new user | ❌   |
| POST   | `/auth/login`     | Login & get token   | ❌   |
| GET    | `/auth/profile`   | Get user profile    | ✅   |
| PUT    | `/auth/profile`   | Update user profile | ✅   |

---

### 📦 Master — Categories

| Method | Endpoint                  | Description            | Auth |
|--------|---------------------------|------------------------|------|
| GET    | `/master/categories`      | List all categories    | ❌   |
| GET    | `/master/categories/:id`  | Get category by ID     | ❌   |
| POST   | `/master/categories`      | Create a category      | ✅   |
| PUT    | `/master/categories/:id`  | Update a category      | ✅   |
| DELETE | `/master/categories/:id`  | Delete a category      | ✅   |

---

### 🏷️ Master — Brands

| Method | Endpoint               | Description         | Auth |
|--------|------------------------|---------------------|------|
| GET    | `/master/brands`       | List all brands     | ❌   |
| GET    | `/master/brands?category_id=1` | Filter by category | ❌ |
| GET    | `/master/brands/:id`   | Get brand by ID     | ❌   |
| POST   | `/master/brands`       | Create a brand      | ✅   |
| PUT    | `/master/brands/:id`   | Update a brand      | ✅   |
| DELETE | `/master/brands/:id`   | Delete a brand      | ✅   |

---

### 📱 Master — Models

| Method | Endpoint                  | Description         | Auth |
|--------|---------------------------|---------------------|------|
| GET    | `/master/models`          | List all models     | ❌   |
| GET    | `/master/models?brand_id=1` | Filter by brand   | ❌   |
| GET    | `/master/models/:id`      | Get model by ID     | ❌   |
| POST   | `/master/models`          | Create a model      | ✅   |
| PUT    | `/master/models/:id`      | Update a model      | ✅   |
| DELETE | `/master/models/:id`      | Delete a model      | ✅   |

---

### 🔧 Master — Conditions

| Method | Endpoint                    | Description           | Auth |
|--------|-----------------------------|-----------------------|------|
| GET    | `/master/conditions`        | List all conditions   | ❌   |
| GET    | `/master/conditions/:id`    | Get condition by ID   | ❌   |
| POST   | `/master/conditions`        | Create a condition    | ✅   |
| PUT    | `/master/conditions/:id`    | Update a condition    | ✅   |
| DELETE | `/master/conditions/:id`    | Delete a condition    | ✅   |

---

### 🗂️ Orders

| Method | Endpoint                   | Description              | Auth |
|--------|----------------------------|--------------------------|------|
| POST   | `/orders`                  | Create a new order       | ✅   |
| GET    | `/orders`                  | List all orders (admin)  | ✅   |
| GET    | `/orders/:id`              | Get order by ID          | ✅   |
| GET    | `/orders/user/:user_id`    | Get orders for a user    | ✅   |
| PUT    | `/orders/:id/status`       | Update order status      | ✅   |
| DELETE | `/orders/:id`              | Delete an order          | ✅   |

---

### 🖼️ Order Images

| Method | Endpoint                              | Description             | Auth |
|--------|---------------------------------------|-------------------------|------|
| POST   | `/orders/:order_id/images`            | Upload image for order  | ✅   |
| GET    | `/orders/:order_id/images`            | Get all images of order | ✅   |
| DELETE | `/orders/:order_id/images/:image_id`  | Delete a specific image | ✅   |

---

## 📮 Postman Collection

Import the Postman collection to test all endpoints instantly:

1. Open Postman
2. Click **Import**
3. Select `E-waste-API.postman_collection.json` from this repository
4. Set the `base_url` collection variable to your server URL
5. Run **User Login** first — the token is saved automatically via a test script

---

## 📁 Project Structure

```
e-waste-api/
├── .env.example                          # Environment variable template
├── .gitignore
├── database.sql                          # Full MySQL schema
├── E-waste-API.postman_collection.json   # Postman API collection
├── README.md
├── package.json
├── src/
│   ├── server.js                         # Entry point
│   ├── config/
│   │   └── db.js                         # Database connection
│   ├── middleware/
│   │   ├── auth.js                       # JWT middleware
│   │   └── upload.js                     # Multer file upload middleware
│   ├── routes/
│   │   ├── auth.routes.js
│   │   ├── categories.routes.js
│   │   ├── brands.routes.js
│   │   ├── models.routes.js
│   │   ├── conditions.routes.js
│   │   ├── orders.routes.js
│   │   └── orderImages.routes.js
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   ├── categories.controller.js
│   │   ├── brands.controller.js
│   │   ├── models.controller.js
│   │   ├── conditions.controller.js
│   │   ├── orders.controller.js
│   │   └── orderImages.controller.js
│   └── models/                           # DB query helpers / ORM models
└── uploads/                              # Uploaded order images (gitignored)
```

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
