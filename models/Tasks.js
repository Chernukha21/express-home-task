import { v4 as uuidv4 } from 'uuid';
import {format} from "date-fns";

export const tasks = [
    {
        id: '1',
        body: 'Learn Express',
        deadline: format(new Date(), 'Y-MM-dd'),
        isDone: false,
    },
    {
        id: '2',
        body: 'Learn Vue',
        deadline: format(new Date(), 'Y-MM-dd'),
        isDone: false,
    },
    {
        id: '3',
        body: 'Learn React',
        deadline: format(new Date(), 'Y-MM-dd'),
        isDone: false,
    },
];

export const getTasks = (page, results) => tasks.slice((page - 1) * results, page * results);

export const getTaskById = (id) => {
    return tasks.find((task) => task.id === id);
};

export const addTask = (task) => {
    const newTask = {
        ...task,
        id: uuidv4(),
        isDone: false,
    };

    tasks.push(newTask);

    return newTask;
};

export const updateTask = (id, updateData) => {
    const taskIndex = tasks.findIndex((task) => task.id === id);

    if (taskIndex === -1) {
        return null;
    }

    tasks[taskIndex] = {
        ...tasks[taskIndex],
        ...updateData,
    };

    return tasks[taskIndex];
};

export const deleteTask = (id) => {
    const taskIndex = tasks.findIndex((task) => task.id === id);

    if (taskIndex === -1) {
        return null;
    }

    const deletedTask = tasks[taskIndex];

    tasks.splice(taskIndex, 1);

    return deletedTask;
};