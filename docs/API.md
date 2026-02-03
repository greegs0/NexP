# NexP API Documentation

## Overview

NexP provides a RESTful API for mobile and third-party integrations. All endpoints are prefixed with `/api/v1/`.

**Base URL:** `https://your-domain.com/api/v1`

## Authentication

Protected endpoints require Bearer token authentication via the `Authorization` header:

```
Authorization: Bearer <token>
```

Tokens are obtained from the login or signup endpoints and are valid for **24 hours**.

---

## Endpoints

### Authentication

#### POST /auth/login

Authenticate a user and receive a JWT token.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "john_doe",
    "name": "John Doe"
  }
}
```

**Error (401):**
```json
{
  "error": "Identifiants invalides"
}
```

---

#### POST /auth/signup

Create a new user account.

**Request:**
```json
{
  "user": {
    "email": "newuser@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "username": "newuser",
    "name": "New User"
  }
}
```

**Response (201):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 2,
    "email": "newuser@example.com",
    "username": "newuser",
    "name": "New User"
  }
}
```

**Error (422):**
```json
{
  "errors": ["Email has already been taken"]
}
```

---

### Users

#### GET /users

List all users with optional filters.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| search | string | Search by name or username |
| skill_id | integer | Filter by skill |
| available | boolean | Filter by availability |
| min_level | integer | Minimum user level |
| page | integer | Page number (default: 1) |
| per_page | integer | Items per page (default: 20, max: 50) |

**Response (200):**
```json
{
  "users": [
    {
      "id": 1,
      "username": "john_doe",
      "name": "John Doe",
      "avatar_url": "https://...",
      "level": 15,
      "available": true,
      "skills": ["Ruby", "Rails", "PostgreSQL"]
    }
  ],
  "meta": {
    "current_page": 1,
    "total_pages": 5,
    "total_count": 100
  }
}
```

---

#### GET /users/:id

Get user profile details.

**Response (200):**
```json
{
  "id": 1,
  "username": "john_doe",
  "name": "John Doe",
  "bio": "Full-stack developer...",
  "avatar_url": "https://...",
  "level": 15,
  "experience_points": 1500,
  "available": true,
  "zipcode": "75001",
  "portfolio_url": "https://...",
  "github_url": "https://github.com/johndoe",
  "linkedin_url": "https://linkedin.com/in/johndoe",
  "skills": [
    { "id": 1, "name": "Ruby", "category": "Backend" }
  ],
  "stats": {
    "posts_count": 10,
    "followers_count": 50,
    "following_count": 30,
    "projects_count": 5
  }
}
```

---

#### GET /users/me

Get current authenticated user profile.

**Authentication:** Required

**Response:** Same as GET /users/:id

---

#### PATCH /users/:id

Update user profile.

**Authentication:** Required (must be own profile)

**Request:**
```json
{
  "user": {
    "name": "Updated Name",
    "bio": "Updated bio",
    "available": true,
    "zipcode": "75002",
    "portfolio_url": "https://myportfolio.com",
    "github_url": "https://github.com/username",
    "linkedin_url": "https://linkedin.com/in/username"
  }
}
```

**Response (200):**
```json
{
  "id": 1,
  "name": "Updated Name",
  "bio": "Updated bio",
  ...
}
```

---

#### POST /users/:id/follow

Follow a user.

**Authentication:** Required

**Response (200):**
```json
{
  "message": "Successfully followed user"
}
```

---

#### DELETE /users/:id/unfollow

Unfollow a user.

**Authentication:** Required

**Response (200):**
```json
{
  "message": "Successfully unfollowed user"
}
```

---

### Projects

#### GET /projects

List all public projects.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| status | string | Filter by status (open, in_progress, completed, archived) |
| skill_id | integer | Filter by required skill |
| search | string | Search by title or description |
| available | boolean | Only projects accepting members |
| page | integer | Page number |
| per_page | integer | Items per page |

**Response (200):**
```json
{
  "projects": [
    {
      "id": 1,
      "title": "My Project",
      "description": "A cool project...",
      "status": "open",
      "visibility": "public",
      "max_members": 5,
      "current_members_count": 2,
      "owner": {
        "id": 1,
        "username": "john_doe",
        "name": "John Doe"
      },
      "skills": ["React", "Node.js"],
      "deadline": "2024-12-31"
    }
  ],
  "meta": {
    "current_page": 1,
    "total_pages": 3,
    "total_count": 50
  }
}
```

---

#### GET /projects/:id

Get project details.

**Response (200):**
```json
{
  "id": 1,
  "title": "My Project",
  "description": "A cool project...",
  "status": "open",
  "visibility": "public",
  "max_members": 5,
  "current_members_count": 2,
  "start_date": "2024-01-01",
  "end_date": "2024-12-31",
  "deadline": "2024-06-30",
  "owner": {
    "id": 1,
    "username": "john_doe",
    "name": "John Doe"
  },
  "members": [
    { "id": 2, "username": "jane", "name": "Jane Doe", "role": "member" }
  ],
  "skills": [
    { "id": 1, "name": "React", "category": "Frontend" }
  ]
}
```

---

#### POST /projects

Create a new project.

**Authentication:** Required

**Request:**
```json
{
  "project": {
    "title": "New Project",
    "description": "Project description",
    "status": "open",
    "visibility": "public",
    "max_members": 5,
    "start_date": "2024-01-01",
    "end_date": "2024-12-31",
    "deadline": "2024-06-30"
  },
  "skill_ids": [1, 2, 3]
}
```

**Response (201):**
```json
{
  "id": 10,
  "title": "New Project",
  ...
}
```

---

#### PATCH /projects/:id

Update a project.

**Authentication:** Required (must be owner)

**Request:** Same structure as POST

**Response (200):** Updated project object

---

#### DELETE /projects/:id

Delete a project.

**Authentication:** Required (must be owner)

**Response (200):**
```json
{
  "message": "Project deleted successfully"
}
```

---

#### POST /projects/:id/join

Join a project.

**Authentication:** Required

**Response (200):**
```json
{
  "message": "Successfully joined project"
}
```

**Error (422):**
```json
{
  "error": "Ce projet est complet."
}
```

---

#### DELETE /projects/:id/leave

Leave a project.

**Authentication:** Required

**Response (200):**
```json
{
  "message": "Successfully left project"
}
```

---

### Posts

#### GET /posts

List all posts.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| page | integer | Page number |
| per_page | integer | Items per page |

**Response (200):**
```json
{
  "posts": [
    {
      "id": 1,
      "content": "Hello world!",
      "user": {
        "id": 1,
        "username": "john_doe",
        "name": "John Doe"
      },
      "likes_count": 10,
      "comments_count": 5,
      "liked": false,
      "created_at": "2024-01-15T10:30:00Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "total_pages": 10
  }
}
```

---

#### GET /posts/feed

Get personalized feed (posts from followed users).

**Authentication:** Required

**Response:** Same as GET /posts

---

#### POST /posts

Create a new post.

**Authentication:** Required

**Request:**
```json
{
  "post": {
    "content": "My new post content"
  }
}
```

**Response (201):**
```json
{
  "id": 100,
  "content": "My new post content",
  ...
}
```

---

#### POST /posts/:id/like

Like a post.

**Authentication:** Required

**Response (200):**
```json
{
  "likes_count": 11
}
```

---

#### DELETE /posts/:id/unlike

Unlike a post.

**Authentication:** Required

**Response (200):**
```json
{
  "likes_count": 10
}
```

---

#### GET /posts/:id/comments

Get comments for a post.

**Response (200):**
```json
{
  "comments": [
    {
      "id": 1,
      "content": "Great post!",
      "user": {
        "id": 2,
        "username": "jane",
        "name": "Jane"
      },
      "created_at": "2024-01-15T11:00:00Z"
    }
  ]
}
```

---

#### POST /posts/:id/comments

Add a comment to a post.

**Authentication:** Required

**Request:**
```json
{
  "content": "My comment"
}
```

**Response (201):**
```json
{
  "id": 50,
  "content": "My comment",
  ...
}
```

---

### Skills

#### GET /skills

List all skills.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| category | string | Filter by category |
| search | string | Search by name |

**Response (200):**
```json
{
  "skills": [
    {
      "id": 1,
      "name": "Ruby",
      "category": "Backend",
      "users_count": 150
    }
  ]
}
```

---

#### GET /skills/categories

Get all skill categories.

**Response (200):**
```json
{
  "categories": [
    "Backend",
    "Frontend",
    "Mobile",
    "Database",
    "DevOps",
    "IA & Data",
    "Design",
    "Product & Business",
    "Security",
    "Testing & QA",
    "Blockchain",
    "Game Dev",
    "Tools",
    "Autre"
  ]
}
```

---

### Matching

#### GET /matching/projects

Get recommended projects for current user based on skills.

**Authentication:** Required

**Query Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| limit | integer | 10 | Maximum results |

**Response (200):**
```json
{
  "projects": [
    {
      "id": 1,
      "title": "Matching Project",
      "match_score": 85,
      ...
    }
  ]
}
```

---

#### GET /matching/users

Get recommended users for a project.

**Authentication:** Required

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| project_id | integer | **Required** - Project ID |
| limit | integer | Maximum results (default: 10) |

**Response (200):**
```json
{
  "users": [
    {
      "id": 5,
      "username": "developer",
      "match_score": 90,
      ...
    }
  ]
}
```

---

#### GET /matching/similar_users

Get users with similar skills.

**Authentication:** Required

**Response (200):**
```json
{
  "users": [
    {
      "id": 3,
      "username": "similar_dev",
      "common_skills": ["Ruby", "Rails"]
    }
  ]
}
```

---

### Analytics

#### GET /analytics/platform

Get platform-wide statistics.

**Response (200):**
```json
{
  "total_users": 5000,
  "total_projects": 1200,
  "total_skills": 150,
  "active_projects": 450,
  "new_users_this_week": 50
}
```

---

#### GET /analytics/me

Get current user's analytics.

**Authentication:** Required

**Response (200):**
```json
{
  "posts_count": 25,
  "likes_received": 150,
  "comments_received": 45,
  "followers_gained_this_month": 10,
  "xp_gained_this_week": 250,
  "badges_count": 5
}
```

---

#### GET /analytics/user/:id

Get analytics for a specific user.

**Authentication:** Required

**Response:** Same as /analytics/me

---

#### GET /analytics/project/:id

Get project analytics.

**Authentication:** Required

**Response (200):**
```json
{
  "members_count": 4,
  "messages_count": 150,
  "days_active": 45,
  "completion_percentage": 65
}
```

---

#### GET /analytics/trending

Get trending content.

**Authentication:** Required

**Response (200):**
```json
{
  "trending_skills": ["TypeScript", "React", "Python"],
  "trending_projects": [...],
  "top_contributors": [...]
}
```

---

## Error Codes

| Status | Description |
|--------|-------------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request |
| 401 | Unauthorized (invalid/missing token) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not Found |
| 422 | Unprocessable Entity (validation errors) |
| 500 | Internal Server Error |

---

## Rate Limiting

API requests are rate limited:
- **Anonymous:** 100 requests/minute
- **Authenticated:** 300 requests/minute
- **Auth endpoints:** 5 requests/minute per IP

When rate limited, you'll receive a `429 Too Many Requests` response with a `Retry-After` header.

---

## Changelog

### v1.0.0
- Initial API release
- User authentication and profiles
- Projects CRUD and membership
- Posts, likes, comments
- Skills and matching
- Analytics endpoints
