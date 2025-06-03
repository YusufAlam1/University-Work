#ifndef STUDENT_H
#define STUDENT_H

// * strucutre pretty much the same from course.h

struct Course;

typedef struct Student
{
    int id;
    char *name;
    struct Course **courses;
    int courseCount;
} Student;

typedef struct StudentListNode
{
    Student *student;
    struct StudentListNode *next;
} StudentListNode;

extern StudentListNode *studentListHead;

// Function prototypes
StudentListNode *createStudentNode(int id, char *name);
void insertStudentNode(StudentListNode **head, StudentListNode *newNode);
void addCourseToStudent(Student *student, struct Course *course);
Student *findStudentById(StudentListNode *head, int id);
void freeStudentList(StudentListNode *head);

#endif