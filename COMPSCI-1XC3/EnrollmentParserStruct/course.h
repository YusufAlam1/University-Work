#ifndef COURSE_H
#define COURSE_H

// so i can use pointers without the need of the full definition (same thing done in studen.h w/ struct Course)
struct Student;

// Course struct to replace parallel arrays
typedef struct Course
{
    char *id;
    char *name;
    int capacity;
    struct Student **students;
    int studentCount;
} Course;

// the linked list
typedef struct CourseListNode
{
    Course *course;
    struct CourseListNode *next;
} CourseListNode;

extern CourseListNode *courseListHead;

CourseListNode *createCourseNode(char *id, char *name, int capacity);
void insertCourseNode(CourseListNode **head, CourseListNode *newNode);
void addStudentToCourse(Course *course, struct Student *student);
Course *findCourseById(CourseListNode *head, char *id);
void freeCourseList(CourseListNode *head);

#endif