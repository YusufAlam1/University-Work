/*
 ============================================================================
 Name        : Yusuf Alam
 MacID       : alamy1
 Student ID  : 400568561
 File        : main.c
 Description :
   Reads course and student info from the file specified by argv[1]
   stores this info in linked lists of structs
   Then writes info in a restructured format to file specified by argv[2]
   Also frees up memory after the fact
 ============================================================================
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "course.h"
#include "student.h"

CourseListNode *courseListHead = NULL;
StudentListNode *studentListHead = NULL;

/**
 * createCourseNode
 * Creates a new CourseListNode with the given data
 *
 * @param id course ID
 * @param name course name
 * @param capacity course capacity
 * @return pointer to the new courselistnode
 */
CourseListNode *createCourseNode(char *id, char *name, int capacity)
{
    CourseListNode *newNode = (CourseListNode *)malloc(sizeof(CourseListNode));
    if (!newNode)
    {
        printf("Memory allocation failed\n");
        exit(1);
    }

    Course *course = (Course *)malloc(sizeof(Course));
    if (!course)
    {
        printf("Memory allocation failed\n");
        free(newNode);
        exit(1);
    }

    course->id = strdup(id);
    course->name = strdup(name);
    course->capacity = capacity;
    course->students = (Student **)malloc(sizeof(Student *) * capacity);
    course->studentCount = 0;

    newNode->course = course;
    newNode->next = NULL;

    return newNode;
}

/**
 * insertCourseNode
 * inserts a courlistnode into a sorted linked list based on course ID
 *
 * @param head pointer to the head of the course list
 * @param newNode node to insert
 */
void insertCourseNode(CourseListNode **head, CourseListNode *newNode)
{
    // Empty list or new node should be first (alphabetically)
    if (*head == NULL || strcmp(newNode->course->id, (*head)->course->id) < 0)
    {
        newNode->next = *head;
        *head = newNode;
        return;
    }

    CourseListNode *current = *head;
    while (current->next != NULL && strcmp(newNode->course->id, current->next->course->id) > 0)
    {
        current = current->next;
    }

    // Insert the node
    newNode->next = current->next;
    current->next = newNode;
}

/**
 * createStudentNode
 * Creates a new StudentListNode with the given data
 *
 * @param id student ID
 * @param name student name
 * @return pointer to the new StudentListNode
 */
StudentListNode *createStudentNode(int id, char *name)
{
    StudentListNode *newNode = (StudentListNode *)malloc(sizeof(StudentListNode));
    if (!newNode)
    {
        printf("Memory allocation failed\n");
        exit(1);
    }

    Student *student = (Student *)malloc(sizeof(Student));
    if (!student)
    {
        printf("Memory allocation failed\n");
        free(newNode);
        exit(1);
    }

    student->id = id;
    student->name = strdup(name);
    student->courses = (Course **)malloc(sizeof(Course *) * 5); //allocating memory for only 5 courses in case our assumption goes wrong
    student->courseCount = 0;

    newNode->student = student;
    newNode->next = NULL;

    return newNode;
}

/**
 * insertStudentNode
 * Inserts a StudentListNode into a sorted linked list based on student ID
 *
 * @param head pointer to the head of the student list
 * @param newNode node to insert
 */
void insertStudentNode(StudentListNode **head, StudentListNode *newNode)
{
    if (*head == NULL || newNode->student->id < (*head)->student->id)
    {
        newNode->next = *head;
        *head = newNode;
        return;
    }

    StudentListNode *current = *head;
    while (current->next != NULL && newNode->student->id > current->next->student->id)
    {
        current = current->next;
    }

    newNode->next = current->next;
    current->next = newNode;
}

/**
 * findStudentById
 * Finds a student by ID in the student list
 *
 * @param head head of the student list
 * @param id student ID to find
 * @return pointer to the found Student or NULL if not found
 */
Student *findStudentById(StudentListNode *head, int id)
{
    StudentListNode *current = head;
    while (current != NULL)
    {
        if (current->student->id == id)
        {
            return current->student;
        }
        current = current->next;
    }
    return NULL;
}

/**
 * findCourseById
 * Finds a course by ID in the course list
 *
 * @param head head of the course list
 * @param id course ID to find
 * @return pointer to the found Course or NULL if not found
 */
Course *findCourseById(CourseListNode *head, char *id)
{
    CourseListNode *current = head;
    while (current != NULL)
    {
        if (strcmp(current->course->id, id) == 0)
        {
            return current->course;
        }
        current = current->next;
    }
    return NULL;
}

/**
 * addStudentToCourse
 * Adds a student to a course's student list
 * Also checks to make sure we don't add the same student twice to a course
 *
 * @param course the course to modify
 * @param student the student to add
 * 
 */
void addStudentToCourse(Course *course, Student *student)
{
    for (int i = 0; i < course->studentCount; i++)
    {
        if (course->students[i]->id == student->id)
        {
            return;
        }
    }

    if (course->studentCount < course->capacity)
    {
        course->students[course->studentCount++] = student;
    }
}

/**
 * addCourseToStudent
 * Adds a course to a student's course list
 * similar to last function duplication is accounted for
 *
 * @param student the student to modify
 * @param course the course to add
 */
void addCourseToStudent(Student *student, Course *course)
{
    for (int i = 0; i < student->courseCount; i++)
    {
        if (strcmp(student->courses[i]->id, course->id) == 0)
        {
            return; //already enroled, not much to do from there
        }
    }

    if (student->courseCount < 5)
    {
        student->courses[student->courseCount++] = course;
    }
}

/**
 * compareCoursesById
 * Compare two courses by their IDs for sorting
 *
 * @param a first course
 * @param b second course
 * @return -1, 0, or 1 based on comparison result
 */
int compareCoursesById(const void *a, const void *b)
{
    Course *courseA = *(Course **)a;
    Course *courseB = *(Course **)b;
    return strcmp(courseA->id, courseB->id);
}

/**
 * readCourseInfoFrom
 * Reads course and student info from file
 * Stores this info into linked lists of structs
 *
 * @param fileName input file name
 */
void readCourseInfoFrom(char *fileName)
{
    FILE *file = fopen(fileName, "r");

    if (!file)
    {
        printf("No file to open / failure to do so: %s\n", fileName);
        return;
    }

    char line[250]; // more than enough space for one line
    Course *currentCourse = NULL;

    // Reading from input file one line at a time
    while (fgets(line, sizeof(line), file))
    {
        if (strncmp(line, "Course", 6) == 0)
        {
            char courseID[20], courseName[50];
            int capacity;
            sscanf(line, "Course %s %s %d", courseID, courseName, &capacity);

            // create and insert
            CourseListNode *newCourseNode = createCourseNode(courseID, courseName, capacity);
            insertCourseNode(&courseListHead, newCourseNode);

            // update
            currentCourse = newCourseNode->course;
        }
        else if (currentCourse != NULL)
        {
            int id;
            char name[50];
            sscanf(line, "%d %s", &id, name);

            Student *student = findStudentById(studentListHead, id);
            if (student == NULL)
            {
                StudentListNode *newStudentNode = createStudentNode(id, name);
                insertStudentNode(&studentListHead, newStudentNode);
                student = newStudentNode->student;
            }

            // connecting
            addStudentToCourse(currentCourse, student);
            addCourseToStudent(student, currentCourse);
        }
    }

    fclose(file);

    // Sortting
    StudentListNode *current = studentListHead;
    while (current != NULL)
    {
        qsort(current->student->courses, current->student->courseCount, sizeof(Course *), compareCoursesById);
        current = current->next;
    }
}

/**
 * writeStudentInfoTo
 * Writes student and course info in the required format to a file
 *
 * @param fileName output file name
 */
void writeStudentInfoTo(char *fileName)
{
    FILE *file = fopen(fileName, "w");

    if (!file)
    {
        printf("No file to write to / failure to do so: %s\n", fileName);
        return;
    }

    // going through the students in an order that is sorted (IDs)
    StudentListNode *currentStudent = studentListHead;
    while (currentStudent != NULL)
    {
        Student *student = currentStudent->student;

        // writing the student info
        fprintf(file, "%d %s\n", student->id, student->name);

        // writing the course info after in ALPHABETICAL ORDER
        for (int i = 0; i < student->courseCount; i++)
        {
            Course *course = student->courses[i];

            //similar to how i got rid of the newline in the last assignemtn
            if (currentStudent->next == NULL && i == student->courseCount - 1)
            {
                fprintf(file, "%s %s %d", course->name, course->id, course->capacity); 
            }
            else
            {
                fprintf(file, "%s %s %d\n", course->name, course->id, course->capacity);
            }
        }


        currentStudent = currentStudent->next;
    }

    fclose(file);
}

/**
 * freeCourseList
 * Frees all memory allocated for the course list
 *
 * @param head head of the course list
 */
void freeCourseList(CourseListNode *head)
{
    CourseListNode *current = head;
    CourseListNode *next;

    while (current != NULL)
    {
        next = current->next;

        free(current->course->id);
        free(current->course->name);
        free(current->course->students);
        free(current->course);
        free(current);

        current = next;
    }
}

/**
 * freeStudentList
 * Frees all memory allocated for the student list
 *
 * @param head head of the student list
 */
void freeStudentList(StudentListNode *head)
{
    StudentListNode *current = head;
    StudentListNode *next;

    while (current != NULL)
    {
        next = current->next;

        free(current->student->name);
        free(current->student->courses);
        free(current->student);
        free(current);

        current = next;
    }
}

/**
 * cleanup
 * Frees all dynamically allocated memory used by the program
 */
void cleanup()
{
    freeCourseList(courseListHead);
    freeStudentList(studentListHead);
    courseListHead = NULL;
    studentListHead = NULL;
}

/**
 * main
 * argv[1] reads from courseInfo.txt
 * argv[2] writes to stundetINfot.txt
 * after that it cleans up allocated memory
 *
 * @param argc number of command line arguments
 * @param argv array of command line arguments
 * @return 0 means the program exited without errors
 */
int main(int argc, char **argv)
{
    if (argc != 3)
    {
        printf("Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    readCourseInfoFrom(argv[1]);
    writeStudentInfoTo(argv[2]);
    cleanup();

    return 0;
}