/**
 * BÀI TẬP 2: ĐỊNH NGHĨA MONGOOSE SCHEMAS (MONGODB)
 * File: mongoose_schemas.js
 * Mô hình hóa CSDL Quản lý Sinh viên chuyển đổi từ MySQL sang MongoDB
 */

const mongoose = require('mongoose');
const { Schema } = mongoose;

// 1. Class Schema (Lớp hành chính)
const ClassSchema = new Schema({
  classCode: { type: String, required: true, unique: true, uppercase: true, trim: true },
  className: { type: String, required: true },
  academicYear: { type: String, required: true }
}, { timestamps: true });

// 2. Lecturer Schema (Giảng viên)
const LecturerSchema = new Schema({
  lecturerCode: { type: String, required: true, unique: true, uppercase: true, trim: true },
  fullName: { type: String, required: true },
  email: { type: String, required: true, unique: true, lowercase: true },
  phone: { type: String },
  department: { type: String, default: 'Công nghệ thông tin' }
}, { timestamps: true });

// 3. Course Schema (Môn học)
const CourseSchema = new Schema({
  courseCode: { type: String, required: true, unique: true, uppercase: true, trim: true },
  courseName: { type: String, required: true },
  credits: { type: Number, required: true, min: 1 }
}, { timestamps: true });

// 4. Student Schema (Sinh viên - Embedded Address, Referencing Class)
const StudentSchema = new Schema({
  studentCode: { type: String, required: true, unique: true, uppercase: true, trim: true },
  fullName: { type: String, required: true },
  email: { type: String, required: true, unique: true, lowercase: true },
  phone: { type: String },
  dateOfBirth: { type: Date },
  // EMBEDDING Document: Địa chỉ sinh viên ít biến động, luôn đi kèm hồ sơ sinh viên
  address: {
    street: { type: String },
    district: { type: String },
    city: { type: String }
  },
  // REFERENCING Document: Tham chiếu tới Lớp hành chính để tránh dư thừa khi thông tin Lớp thay đổi
  class: { type: Schema.Types.ObjectId, ref: 'Class', required: true }
}, { timestamps: true });

// 5. Enrollment Schema (Đăng ký học phần & Điểm số - Referencing Student/Course/Lecturer, Embedded Scores)
const EnrollmentSchema = new Schema({
  // REFERENCING Student
  student: { type: Schema.Types.ObjectId, ref: 'Student', required: true },
  // REFERENCING Course & Lecturer trong Lớp học phần
  section: {
    course: { type: Schema.Types.ObjectId, ref: 'Course', required: true },
    lecturer: { type: Schema.Types.ObjectId, ref: 'Lecturer', required: true },
    semester: { type: String, required: true },
    room: { type: String }
  },
  // EMBEDDING Scores: Nhúng điểm số trực tiếp vào lượt đăng ký học
  scores: {
    midterm: { type: Number, min: 0, max: 10 },
    final: { type: Number, min: 0, max: 10 },
    total: { type: Number, min: 0, max: 10 }
  },
  status: {
    type: String,
    enum: ['REGISTERED', 'STUDYING', 'COMPLETED', 'FAILED'],
    default: 'REGISTERED'
  },
  enrollDate: { type: Date, default: Date.now }
}, { timestamps: true });

// Tính điểm tổng kết tự động (Pre-save hook)
EnrollmentSchema.pre('save', function(next) {
  if (this.scores.midterm !== undefined && this.scores.final !== undefined) {
    this.scores.total = Number((this.scores.midterm * 0.4 + this.scores.final * 0.6).toFixed(2));
  }
  next();
});

const Class = mongoose.model('Class', ClassSchema);
const Lecturer = mongoose.model('Lecturer', LecturerSchema);
const Course = mongoose.model('Course', CourseSchema);
const Student = mongoose.model('Student', StudentSchema);
const Enrollment = mongoose.model('Enrollment', EnrollmentSchema);

module.exports = { Class, Lecturer, Course, Student, Enrollment };
