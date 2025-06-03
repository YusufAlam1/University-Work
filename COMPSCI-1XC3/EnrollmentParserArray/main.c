/*
 ============================================================================
 Name        : Yusuf Alam
 MacID       : alamy1
 Student ID  : 400568561
 File        : main.c
 Description :
   Reads course and student info from the courseInfo.txt file
   stores this info int parallel arrays
   Then writes info in a restructured format to studentInfo.txt
   Also frees up memory after the fact
 ============================================================================
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "course.h"
#include "student.h"

/**
 * readCourseInfoFrom
 * Reads course and student info from file
 * Stores this info into the arrays from course.h & student.h
 *
 * @param fileName input file name (courseInfo.txt)
 */
void readCourseInfoFrom(char *fileName)
{
  FILE *file = fopen(fileName, "r");

  // "if not file" would be the case that the file failed to open
  if (!file)
  {
    printf("No file to open / failure to do so: %s\n", fileName);
    return;
  }

  char line[250]; // More than enough space for one line
  int courseIndex = -1;
  int studentCount[MAX_COURSE_NUM] = {0};
  int numStudents = 0;

  // Reading from courseInfo.txt one line at a time
  while (fgets(line, sizeof(line), file))
  {
    if (strncmp(line, "Course", 6) == 0)
    {
      courseIndex++;

      char courseID[20], courseName[50];
      int capacity;
      sscanf(line, "Course %s %s %d", courseID, courseName, &capacity); // How the file formats the courseInfo

      courseIDs[courseIndex] = strdup(courseID);
      courseNames[courseIndex] = strdup(courseName);
      courseCapacities[courseIndex] = capacity;
      courseTakenByStudents[courseIndex] = malloc(sizeof(int) * MAX_STUDENT_NUM);
    }
    // If its not a course its a student (Assuming input is properly formatted)
    else
    {
      int id;
      char name[50];
      sscanf(line, "%d %s", &id, name); // Format for student

      // checking if the student is already there
      int i;
      for (i = 0; i < numStudents; i++)
      {
        if (studentIDs[i] == id)
          break;
      }

      if (i == numStudents)
      {
        // New student add it to the array
        studentIDs[numStudents] = id;
        studentNames[numStudents] = strdup(name);
        studentTakesCourses[numStudents] = malloc(sizeof(char *) * 6); // max 5 courses + NULL
        numStudents++;
      }

      // Adding course to student
      int studentIndex = i;
      int j = 0;
      while (studentTakesCourses[studentIndex][j] != NULL)
        j++;
      studentTakesCourses[studentIndex][j] = strdup(courseIDs[courseIndex]);
      studentTakesCourses[studentIndex][j + 1] = NULL;

      // Add student to course
      courseTakenByStudents[courseIndex][studentCount[courseIndex]++] = id;
    }
  }

  fclose(file);
}

/**
 * writeStudentInfoTo
 * Writes student and course info in a new format to a new file
 *
 * @param fileName output file name (studentInfo.txt)
 */
void writeStudentInfoTo(char *fileName)
{
  FILE *file = fopen(fileName, "w");

  // Similar error handling from the start
  if (!file)
  {
    printf("No file to write to / failure to do so: %s\n", fileName);
    return;
  }

  int numStudents = 0;
  while (numStudents < MAX_STUDENT_NUM && studentNames[numStudents] != NULL)
  {
    numStudents++;
  }

  for (int i = 0; i < numStudents; i++)
  {
    // This is the format info will be printed on studentInfo.txt
    fprintf(file, "%d %s\n", studentIDs[i], studentNames[i]);

    // Counting amount of courses a student has
    int courseCount = 0;
    while (studentTakesCourses[i][courseCount] != NULL)
    {
      courseCount++;
    }

    for (int j = 0; j < courseCount; j++)
    {
      // Find course index
      for (int k = 0; k < MAX_COURSE_NUM; k++)
      {
        if (courseIDs[k] && strcmp(courseIDs[k], studentTakesCourses[i][j]) == 0)
        {
          // Making sure that the last course of the last studnet doesnt get an extra new line
          if (i == numStudents - 1 && j == courseCount - 1)
          {
            fprintf(file, "%s %s %d", courseNames[k], courseIDs[k], courseCapacities[k]);
          }
          else
          {
            fprintf(file, "%s %s %d\n", courseNames[k], courseIDs[k], courseCapacities[k]);
          }
          break;
        }
      }
    }
  }

  fclose(file);
}

/**
 * cleanup
 * Frees all dynamically allocated memory used by the program
 */
void cleanup()
{
  for (int i = 0; i < MAX_COURSE_NUM; i++)
  {
    free(courseIDs[i]);
    free(courseNames[i]);
    free(courseTakenByStudents[i]);
  }

  for (int i = 0; i < MAX_STUDENT_NUM && studentNames[i] != NULL; i++)
  {
    free(studentNames[i]);

    for (int j = 0; studentTakesCourses[i][j] != NULL; j++)
    {
      free(studentTakesCourses[i][j]);
    }
    free(studentTakesCourses[i]);
  }
}

/**
 * main
 * Specifies input & output file names, and calls functions
 *
 * @param argc
 * @param argv
 * @return 0
 */
int main(int argc, char **argv)
{
  char *inputFile = "courseInfo.txt";
  char *outputFile = "studentInfo.txt";
  if (argc == 3)
  {
    inputFile = argv[1];
    outputFile = argv[2];
  }
  readCourseInfoFrom(inputFile);
  writeStudentInfoTo(outputFile);
  cleanup();
  return 0;
}