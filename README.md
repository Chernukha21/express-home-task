# Tasks CRUD API

Simple Express server for managing tasks.

## Technologies

- Node.js
- Express
- UUID

## Features

- Get all tasks
- Get single task by id
- Create task
- Update task
- Delete task

## Task model

```js
{
  id: string,
  body: string,
  deadline: string,
  isDone: boolean
}
