import {
    addTask,
    deleteTask,
    getTaskById,
    getTasks,
    updateTask,
} from '../models/Tasks.js';

export function getAllTasks(req, res) {
    const tasks = getTasks();

    res.status(200).json(tasks);
}

export function getSingleTaskById(req, res) {
    const { id } = req.params;

    const task = getTaskById(id);

    if (!task) {
        return res.status(404).json({
            message: 'Task not found',
        });
    }

    res.status(200).json(task);
}

export function createTask(req, res) {
    const { body, deadline } = req.body;

    if (!body || !deadline) {
        return res.status(400).json({
            message: 'Every field is required',
        });
    }

    const newTask = addTask({
        body,
        deadline,
    });

    res.status(201).json(newTask);
}

export function updateTaskById(req, res) {
    const { id } = req.params;
    const updateData = req.body;

    const updatedTask = updateTask(id, updateData);

    if (!updatedTask) {
        return res.status(404).json({
            message: 'Task not found',
        });
    }

    res.status(200).json(updatedTask);
}

export function removeTaskById(req, res) {
    const { id } = req.params;

    const deletedTask = deleteTask(id);

    if (!deletedTask) {
        return res.status(404).json({
            message: 'Task not found',
        });
    }

    res.status(204).send();
}