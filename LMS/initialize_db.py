import sqlite3

# Connect to the SQLite database (or create it if it doesn't exist)
conn = sqlite3.connect("student_registration.db")
cursor = conn.cursor()

# Create Users table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
)
""")

# Create Courses table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Courses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_name TEXT NOT NULL UNIQUE
)
""")

# Create UserCourses table
cursor.execute("""
CREATE TABLE IF NOT EXISTS UserCourses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id),
    FOREIGN KEY (course_id) REFERENCES Courses (id)
)
""")

# Insert sample courses
courses = ["Course 1", "Course 2", "Course 3", "Course 4", "Course 5"]
for course in courses:
    cursor.execute("INSERT OR IGNORE INTO Courses (course_name) VALUES (?)", (course,))

# Commit and close
conn.commit()
conn.close()

print("Database initialized successfully!")
