from flask import Flask, render_template, request, redirect, url_for, session
import sqlite3

app = Flask(__name__)
app.secret_key = "your_secret_key"  # For session management

# Database connection
def get_db_connection():
    conn = sqlite3.connect("student_registration.db")
    conn.row_factory = sqlite3.Row
    return conn

# Home Page
@app.route("/")
def home():
    return render_template("index.html")

# Signup Page
@app.route("/signup", methods=["GET", "POST"])
def signup():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        confirm_password = request.form["confirmPassword"]

        if password != confirm_password:
            return "Passwords do not match. Please try again."

        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("INSERT INTO Users (username, password) VALUES (?, ?)", (username, password))
            conn.commit()
            return redirect(url_for("login"))
        except sqlite3.IntegrityError:
            return "Username already exists. Please choose another one."
        finally:
            conn.close()

    return render_template("signup.html")

# Login Page
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        conn = get_db_connection()
        cursor = conn.cursor()
        user = cursor.execute("SELECT * FROM Users WHERE username = ? AND password = ?", (username, password)).fetchone()
        conn.close()

        if user:
            session["user_id"] = user["id"]
            session["username"] = user["username"]
            return redirect(url_for("manage_courses"))
        else:
            return "Invalid username or password."

    return render_template("login.html")

# Add/Remove Courses
@app.route("/manage_courses", methods=["GET", "POST"])
def manage_courses():
    if "user_id" not in session:
        return redirect(url_for("login"))

    conn = get_db_connection()
    cursor = conn.cursor()

    if request.method == "POST":
        action = request.form["action"]
        selected_courses = request.form.getlist("courses[]")
        user_id = session["user_id"]

        if action == "add":
            for course_id in selected_courses:
                cursor.execute("INSERT OR IGNORE INTO UserCourses (user_id, course_id) VALUES (?, ?)", (user_id, course_id))
        elif action == "remove":
            for course_id in selected_courses:
                cursor.execute("DELETE FROM UserCourses WHERE user_id = ? AND course_id = ?", (user_id, course_id))

        conn.commit()

    courses = cursor.execute("SELECT * FROM Courses").fetchall()
    user_courses = cursor.execute("""
        SELECT course_id FROM UserCourses WHERE user_id = ?
    """, (session["user_id"],)).fetchall()

    selected_ids = {course["course_id"] for course in user_courses}
    conn.close()

    return render_template("manage_courses.html", courses=courses, selected_ids=selected_ids)

# Logout
@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))

if __name__ == "__main__":
    app.run(debug=True)
