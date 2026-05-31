My Typst Education Templates
============================

I teach a variety of high school subjects, and I aspire to have all my questions and such in a single 
flexible system where I can easily create quizzes, worksheets, tests, exams, etc, without rewriting
and fighting word processor layouts that are just not made for this kind of work.

I had been using LaTeX templates for worksheet, test, and quiz creation, but after looking at Typst,
I think it will be a simpler option going forward. Not to mention requiring only a 50MB download
instead of several GB just to use the thing.

Right now I'm working on recreating some of the environments that in LaTeX would be taken care of by
the LaTeX exam class. Claude is a heavy partner in this work.

Eventually, I want this to be a part of a comprehensive Python app for making educational instruments.
We'll see.

# Question Environments

The question()[] environment allows you to set a question for the exam. It keeps track of the 
question's number (numbering them sequentially), allows you to add parts or choices environments to 
enable parts or multiple choices, and works in any context (which makes it better than the LaTeX 
exam class's question environment which gets confused by tables and stuff.)

N.b. the number of points passed to the question environment/function is optional. If you don't want
to both with that (and I usually don't), just make it question()[question goes here].

## EXAMPLE USAGE

*Short answer*

```
#question(points: 2)[How does Aristotle define 'virtue'?]
```

*Multiple choice*

```
#question(points: 2)[
  What is the capital of Assyria?
  #choices(
    [Jerusalem],
    [Babylon],
    [Nineveh],
    [I don't know that!],
  )
]```

The example above illustrates how to use the choices environment to create a multiple choice question.
(There is currently no way to have random shuffling of the choices, unlike the \begin{randomizechoices}
environment that you get with the )
