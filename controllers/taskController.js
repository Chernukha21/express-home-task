import {
    addTask,
    deleteTask,
    getTaskById,
    getTasks,
    updateTask,
} from '../models/Tasks.js';
import createError from "http-errors";

export function getAllTasks(req, res) {
    const { page, results } = req.pagination;
    const tasks = getTasks(page, results);

    res.status(200).json(tasks);
}

export function getSingleTaskById(req, res, next) {
    const { id } = req.params;

    const task = getTaskById(id);

    if (!task) {
        return next(createError(404, 'Task not found'));
    }

    res.status(200).json(task);
}

export function createTask(req, res, next) {
    const { body, deadline } = req.body;

    if (!body || !deadline) {
        return next(createError(400, 'All fields required'));
    }

    const newTask = addTask({
        body,
        deadline,
    });

    res.status(201).json(newTask);
}

export function updateTaskById(req, res, next) {
    const { id } = req.params;
    const updateData = req.body;

    const updatedTask = updateTask(id, updateData);

    if (!updatedTask) {
        return next(createError(404, 'Task not found'));
    }

    res.status(200).json(updatedTask);
}

export function removeTaskById(req, res, next) {
    const { id } = req.params;

    const deletedTask = deleteTask(id);

    if (!deletedTask) {
        return next(createError(404, 'Task not found'));
    }

    res.status(204).send();
}